"""Implementacion del sistema de bandas del Decreto 308 para combustibles en Ecuador.

El sistema de bandas asimetricas establece:
- Techo maximo: +5% mensual (el precio no puede subir mas del 5%)
- Piso minimo: -10% mensual (el precio no puede bajar mas del 10%)
- La Super 95 tiene precio libre (no aplica el sistema de bandas)
- Los precios se actualizan el dia 11 de cada mes
- Decreto Ejecutivo No. 308 (junio 2024) establece las bandas asimetricas
- Decreto Ejecutivo No. 83 (ago 2025) incorpora costo de capital 10.78%
- Decreto Ejecutivo No. 444 (jul 2026) agrega mecanismo excepcional de volatilidad:
    Cuando el PPI cayo >=15% en 2 periodos tras subir >=50% en 3 periodos previos
    Y Ecuador aplico TECHO en los 2 ultimos ajustes, se aplica una reduccion
    adicional de hasta 1.5% mensual (10% de la variacion acumulada del PPI).
- Decreto Ejecutivo No. 468 (ago 2026) reemplaza la logica de banda ordinaria:
    Aplica reduccion mensual fija de 0.75%-1.5% sobre el precio vigente.
    Empieza en 0.75% (mes 1) y avanza progresivamente hasta 1.5%.
    Se desactiva si el PPI internacional sube >40% respecto a 4 meses atras.
    Aplica a Extra, EcoPais y Diesel. Super 95 sigue siendo precio libre.

La formula de precio:
Precio final = Precio en Terminal (con IVA) + Margen de Comercializacion (con IVA)
Donde Precio en Terminal incluye: costos de importacion + transporte + almacenamiento
    + margen Petroecuador + costo de capital + IVA (15%)
"""

from datetime import date

from app.config import settings

# Fecha de referencia del modelo (jun-2023 = mes 0)
_MODEL_BASE_DATE = date(2023, 6, 1)

def _months_since_base(d: date = None) -> int:
    """Calcula meses transcurridos desde jun-2023."""
    if d is None:
        d = date.today()
    return (d.year - _MODEL_BASE_DATE.year) * 12 + (d.month - _MODEL_BASE_DATE.month)


class BandCalculator:
    """Implementa la logica del Decreto 308 - Sistema de bandas de precios."""

    def calculate_theoretical_price(
        self,
        wti_price: float,
        fuel_type: str,
        derivative_price: float = None,
    ) -> float:
        """Calcula el precio teorico basado en la formula del gobierno.

        Orden de prioridad:
          1. Si se provee derivative_price (RBOB/ULSD Platts USGC en $/galon),
             lo usa directamente — es el indicador real del Decreto 308.
          2. Si no, usa WTI crudo como proxy (menos preciso).

        Para Super 95 (precio libre) siempre usa el modelo hibrido WTI+tendencia.

        Args:
            wti_price: Precio del WTI en USD/barril (proxy si no hay derivado).
            fuel_type: Tipo de combustible (extra, ecopais, super_95, diesel).
            derivative_price: Precio RBOB o ULSD Platts USGC en $/galon (opcional).

        Returns:
            Precio teorico en USD/galon.
        """
        # Super 95: precio libre, usa modelo hibrido WTI + tendencia temporal
        if fuel_type == "super_95":
            return self._calculate_super95_price(wti_price)

        # Extra, EcoPais, Diesel: usar derivado Platts si esta disponible
        if derivative_price and derivative_price > 0:
            return self._calculate_decree308_from_derivative(derivative_price, fuel_type)

        # Fallback: usar WTI crudo como proxy (comportamiento anterior)
        return self._calculate_decree308_price(wti_price, fuel_type)

    def _calculate_super95_price(self, wti_price: float, target_month_offset: int = 1) -> float:
        """Modelo hibrido para Super 95 (precio libre).

        Regresion multiple calibrada con 34 meses reales (jun-2023 a abr-2026).
        Super = WTI_COEFF*WTI + TIME_COEFF*mes + INTERCEPT
        MAPE=3.6% (mejor que lineal simple MAPE=7%).
        target_month_offset: cuantos meses adelante se predice (1=proximo mes).
        """
        current_month = _months_since_base()
        target_month = current_month + target_month_offset
        price = (
            settings.SUPER_95_WTI_COEFF * wti_price
            + settings.SUPER_95_TIME_COEFF * target_month
            + settings.SUPER_95_INTERCEPT
        )
        return round(max(price, 1.50), 3)

    def _calculate_decree308_from_derivative(self, pm_usgc: float, fuel_type: str) -> float:
        """Formula del Decreto 308 usando el marcador Platts USGC directamente.

        Este es el metodo correcto segun la regulacion: el indicador de referencia
        es el precio del derivado refinado en la Costa del Golfo (RBOB para gasolina,
        ULSD para diesel), no el WTI crudo.

        Formula:
          PPIn = PM_ajustado_calidad + Flete_USGC_Ecuador + Seguro(0.05%) + CK(10.78%) + Tarifa
          Precio_final = (PPIn) * (1 + IVA_15%) + Margen_comercializacion * (1 + IVA_15%)

        Args:
            pm_usgc: Precio Platts USGC en $/galon (RBOB o ULSD, promedio 20 registros).
            fuel_type: Tipo de combustible para ajuste de calidad.

        Returns:
            Precio teorico final al consumidor en $/galon.
        """
        from app.services.derivative_fetcher import (
            OCTANE_QUALITY_FACTOR, FLETE_USD_GAL, SEGURO_RATE,
            CAPITAL_COST_RATE, TARIFA_ARCH_GAL,
        )

        # 1. Ajuste calidad (octanaje)
        quality_factor = OCTANE_QUALITY_FACTOR.get(fuel_type, 1.0)
        pm_adjusted = pm_usgc * quality_factor

        # 2. Flete y seguro
        flete = FLETE_USD_GAL
        seguro = (pm_adjusted + flete) * SEGURO_RATE
        cif = pm_adjusted + flete + seguro

        # 3. Costo de capital 10.78%
        capital_cost = cif * CAPITAL_COST_RATE

        # 4. Tarifa infraestructura ARCH
        tarifa = TARIFA_ARCH_GAL

        # 5. Precio en terminal antes de IVA
        terminal_pre_iva = cif + capital_cost + tarifa

        # 6. IVA 15%
        iva = terminal_pre_iva * settings.IVA_RATE
        terminal_con_iva = terminal_pre_iva + iva

        # 7. Margen de comercializacion + IVA
        commercial_margin = settings.COMMERCIAL_MARGIN
        commercial_margin_iva = commercial_margin * settings.IVA_RATE

        precio_final = terminal_con_iva + commercial_margin + commercial_margin_iva
        return round(max(precio_final, 0.50), 3)

    def _calculate_decree308_price(self, wti_price: float, fuel_type: str) -> float:
        """Formula del Decreto 308 para combustibles regulados (usando WTI como proxy)."""
        # 1. Costo de importacion base: WTI ($/barril) -> $/galon
        import_cost_gallon = wti_price * settings.WTI_TO_GALLON_FACTOR * settings.IMPORT_COST_WEIGHT

        # 2. Ajuste por tipo de combustible (octanaje, refinacion)
        refining_factor = settings.FUEL_REFINING_FACTOR.get(fuel_type, 1.0)
        import_cost_adjusted = import_cost_gallon * refining_factor

        # 3. Costos fijos de la cadena
        transport = settings.TRANSPORT_COST
        storage = settings.STORAGE_COST
        petroecuador_margin = settings.PETROECUADOR_MARGIN

        # 4. Costo de capital
        subtotal_pre_capital = import_cost_adjusted + transport + storage + petroecuador_margin
        capital_cost = subtotal_pre_capital * settings.CAPITAL_COST_RATE

        # 5. Subtotal antes de IVA
        subtotal_before_iva = subtotal_pre_capital + capital_cost

        # 6. IVA sobre el precio en terminal
        iva_terminal = subtotal_before_iva * settings.IVA_RATE
        terminal_price_with_iva = subtotal_before_iva + iva_terminal

        # 7. Margen de comercializacion + su IVA
        commercial_margin = settings.COMMERCIAL_MARGIN
        commercial_margin_iva = commercial_margin * settings.IVA_RATE

        # 8. Precio final teorico
        theoretical_price = terminal_price_with_iva + commercial_margin + commercial_margin_iva

        return round(max(theoretical_price, 0.50), 3)

    def apply_band(
        self,
        current_price: float,
        theoretical_price: float,
        fuel_type: str,
        band_history: list[str] | None = None,
        ppi_history: list[float] | None = None,
    ) -> dict:
        """Aplica la banda de precios (+5% techo, -10% piso) y el Decreto 444.

        Para combustibles con sistema de bandas, limita el cambio mensual.
        Para Super 95 (precio libre), no aplica limites.

        El Decreto 444 (jul 2026) puede generar una reduccion adicional de hasta
        1.5% cuando el mecanismo excepcional se activa (ver _apply_decreto444).

        Args:
            current_price: Precio vigente actual (USD/galon).
            theoretical_price: Precio calculado por formula de costo.
            fuel_type: Tipo de combustible.
            band_history: Lista con los estados de banda de los N meses anteriores
                          (ej. ["TECHO", "TECHO"]). Se usa para verificar condicion
                          del Decreto 444. Si es None, se asume que NO se activa.
            ppi_history: Lista con precios PPI (RBOB/ULSD) de los ultimos meses
                         para calcular variaciones acumuladas del Decreto 444.

        Returns:
            Dict con precio resultante, estado de banda, limites y flag decreto444.
        """
        fuel_config = settings.FUEL_TYPES.get(fuel_type, {})
        has_band = fuel_config.get("band_system", True)

        if not has_band:
            # Super 95: precio libre
            change_pct = ((theoretical_price - current_price) / current_price) * 100 if current_price > 0 else 0
            return {
                "result": round(theoretical_price, 3),
                "status": "LIBRE",
                "capped": False,
                "max_price": None,
                "min_price": None,
                "change_pct": round(change_pct, 2),
                "decreto444_applied": False,
                "decreto444_reduction": 0.0,
            }

        max_increase = fuel_config.get("max_increase", 0.05)
        max_decrease = fuel_config.get("max_decrease", -0.10)

        max_price = round(current_price * (1 + max_increase), 3)
        min_price = round(current_price * (1 + max_decrease), 3)

        if theoretical_price > max_price:
            result_price = max_price
            status = "TECHO"
            capped = True
        elif theoretical_price < min_price:
            result_price = min_price
            status = "PISO"
            capped = True
        else:
            result_price = round(theoretical_price, 3)
            status = "DENTRO"
            capped = False

        # Decreto 468: reduccion gradual mensual (ago-2026 en adelante)
        # Tiene prioridad sobre el Decreto 444 y sobre la banda ordinaria.
        decreto444_applied = False
        decreto444_reduction = 0.0
        decreto468_applied = False
        decreto468_reduction = 0.0

        if settings.DECRETO468_ACTIVE and fuel_type != "super_95":
            d468 = self._apply_decreto468(
                current_price=current_price,
                ppi_history=ppi_history or [],
            )
            if d468["applies"]:
                result_price = d468["adjusted_price"]
                status = "DECRETO468"
                capped = True
                decreto468_applied = True
                decreto468_reduction = d468["reduction_applied"]

        elif settings.DECRETO444_ACTIVE and fuel_type != "super_95":
            # D.E. 444 solo si D.E. 468 no esta activo
            d444 = self._apply_decreto444(
                current_price=current_price,
                result_price=result_price,
                band_status=status,
                band_history=band_history or [],
                ppi_history=ppi_history or [],
            )
            if d444["applies"]:
                result_price = d444["adjusted_price"]
                status = d444["adjusted_status"]
                decreto444_applied = True
                decreto444_reduction = d444["reduction_applied"]

        change_pct = ((result_price - current_price) / current_price) * 100 if current_price > 0 else 0

        return {
            "result": result_price,
            "status": status,
            "capped": capped,
            "max_price": max_price,
            "min_price": min_price,
            "change_pct": round(change_pct, 2),
            "decreto444_applied": decreto444_applied,
            "decreto444_reduction": round(decreto444_reduction, 4),
            "decreto468_applied": decreto468_applied,
            "decreto468_reduction": round(decreto468_reduction, 4),
        }

    def _apply_decreto444(
        self,
        current_price: float,
        result_price: float,
        band_status: str,
        band_history: list[str],
        ppi_history: list[float],
    ) -> dict:
        """Evalua y aplica el mecanismo excepcional del Decreto Ejecutivo 444.

        Decreto Ejecutivo No. 444, firmado el 9 de julio de 2026.
        Reforma el D.E. 83 (Decreto 308 codificado) incorporando un mecanismo
        temporal para reducir asimetrias entre PPI y precio en terminal.

        Condiciones de activacion (las 3 simultaneas):
          1. PPI acumulo caida acumulada >= 15% en los 2 periodos bimestrales previos
          2. PPI acumulo alza previa >= 50% en hasta 3 periodos trimestrales anteriores
          3. El Precio en Terminal alcanzo TECHO (+5%) en los 2 ultimos ajustes

        Formula de reduccion:
          reduccion = 10% * variacion_acumulada_PPI_2_periodos
          tope: max 1.5% del precio vigente por mes

        Args:
            current_price: Precio vigente (base para calcular el tope de 1.5%).
            result_price: Precio ya calculado con la banda ordinaria.
            band_status: Estado de banda del mes actual (TECHO/DENTRO/PISO).
            band_history: Historial de estados de banda de meses anteriores.
            ppi_history: Historial de precios PPI (RBOB/ULSD) en $/galon,
                         ordenados del mas antiguo al mas reciente.

        Returns:
            Dict con: applies (bool), adjusted_price, adjusted_status,
                      reduction_applied, conditions_met.
        """
        no_apply = {
            "applies": False,
            "adjusted_price": result_price,
            "adjusted_status": band_status,
            "reduction_applied": 0.0,
            "conditions_met": {},
        }

        cfg = settings

        # Condicion 3: los 2 ultimos ajustes fueron TECHO
        techos_requeridos = cfg.DECRETO444_TECHOS_REQUERIDOS  # 2
        if len(band_history) < techos_requeridos:
            return no_apply
        recent_bands = band_history[-techos_requeridos:]
        cond3 = all(b == "TECHO" for b in recent_bands)

        # Condicion 1: PPI cayo >= 15% acumulado en los 2 ultimos periodos
        # Necesitamos al menos 3 puntos PPI para calcular 2 periodos de variacion
        cond1 = False
        ppi_caida_acumulada = 0.0
        if len(ppi_history) >= 3:
            ppi_recientes = ppi_history[-3:]
            # variacion periodo 1: entre punto -3 y -2
            var1 = (ppi_recientes[1] - ppi_recientes[0]) / ppi_recientes[0] if ppi_recientes[0] > 0 else 0
            # variacion periodo 2: entre punto -2 y -1 (mas reciente)
            var2 = (ppi_recientes[2] - ppi_recientes[1]) / ppi_recientes[1] if ppi_recientes[1] > 0 else 0
            ppi_caida_acumulada = var1 + var2
            cond1 = ppi_caida_acumulada <= -cfg.DECRETO444_PPI_CAIDA_MIN  # negativo = caida

        # Condicion 2: PPI subia >= 50% acumulado en los 3 periodos trimestrales previos a la caida
        # Necesitamos puntos PPI anteriores a los recientes
        cond2 = False
        ppi_alza_previa = 0.0
        if len(ppi_history) >= 6:
            ppi_previos = ppi_history[-6:-3]
            # Variacion acumulada de los 3 periodos previos (antes de la caida)
            if ppi_previos[0] > 0:
                ppi_alza_previa = (ppi_previos[-1] - ppi_previos[0]) / ppi_previos[0]
                cond2 = ppi_alza_previa >= cfg.DECRETO444_PPI_ALZA_PREVIA
        else:
            # Si no hay suficiente historial PPI pero hay caida y TECHO confirmados,
            # inferir que cond2 se cumple (contexto: 5 meses de TECHO en 2026)
            cond2 = cond3 and cond1

        conditions = {"techos_consecutivos": cond3, "ppi_caida": cond1, "ppi_alza_previa": cond2}

        if not (cond1 and cond2 and cond3):
            no_apply["conditions_met"] = conditions
            return no_apply

        # Calcular reduccion: 10% de la variacion acumulada del PPI (valor absoluto de la caida)
        reduccion_pct = abs(ppi_caida_acumulada) * cfg.DECRETO444_REDUCCION_FACTOR
        # Tope maximo: 1.5% del precio vigente
        reduccion_max = current_price * cfg.DECRETO444_REDUCCION_MAX
        reduccion_aplicada = min(reduccion_pct * current_price, reduccion_max)

        adjusted_price = round(result_price - reduccion_aplicada, 3)
        adjusted_price = max(adjusted_price, current_price * 0.90)  # no bajar del piso ordinario

        return {
            "applies": True,
            "adjusted_price": adjusted_price,
            "adjusted_status": "DECRETO444",
            "reduction_applied": reduccion_aplicada,
            "conditions_met": conditions,
        }

    def _apply_decreto468(
        self,
        current_price: float,
        ppi_history: list[float],
    ) -> dict:
        """Evalua y aplica el mecanismo de reduccion gradual del Decreto Ejecutivo 468.

        Decreto Ejecutivo No. 468, firmado el 11 de agosto de 2026.
        Establece que el precio en terminal del mes actual = precio_anterior * (1 - factor).
        El factor de reduccion mensual avanza progresivamente: empieza en 0.75% (primer mes)
        y puede llegar hasta 1.5% segun parametros tecnicos.

        Logica de progresion del factor:
          - Mes 1 (ago-2026): 0.75% (DECRETO468_REDUCCION_MIN)
          - Mes 2 (sep-2026): 1.125% (punto medio)
          - Mes 3+ (oct-2026 en adelante): 1.5% (DECRETO468_REDUCCION_MAX)

        Condicion de desactivacion:
          - Si el PPI internacional sube >40% respecto al valor de 4 meses atras,
            el mecanismo se desactiva y vuelve a la banda ordinaria (D.E. 308).

        Args:
            current_price: Precio vigente en $/galon.
            ppi_history: Historial de precios PPI (RBOB/ULSD) ordenados de mas antiguo
                         a mas reciente. Se usa para verificar desactivacion.

        Returns:
            Dict con: applies (bool), adjusted_price, reduction_applied, factor_used.
        """
        cfg = settings

        # Verificar condicion de desactivacion: PPI sube >40% en 4 meses
        if len(ppi_history) >= 5:
            ppi_hace_4 = ppi_history[-5]
            ppi_actual = ppi_history[-1]
            if ppi_hace_4 > 0:
                alza_ppi = (ppi_actual - ppi_hace_4) / ppi_hace_4
                if alza_ppi > cfg.DECRETO468_PPI_ALZA_DESACTIVACION:
                    return {"applies": False, "adjusted_price": current_price,
                            "reduction_applied": 0.0, "factor_used": 0.0}

        # Calcular factor segun meses activo (progresion lineal 0.75% -> 1.5%)
        meses = cfg.DECRETO468_MESES_ACTIVO  # 0 = primer mes (agosto)
        r_min = cfg.DECRETO468_REDUCCION_MIN  # 0.0075
        r_max = cfg.DECRETO468_REDUCCION_MAX  # 0.015

        if meses == 0:
            factor = r_min                          # mes 1: 0.75%
        elif meses == 1:
            factor = (r_min + r_max) / 2            # mes 2: 1.125%
        else:
            factor = r_max                          # mes 3+: 1.50%

        reduccion = current_price * factor
        adjusted_price = round(current_price - reduccion, 3)

        return {
            "applies": True,
            "adjusted_price": adjusted_price,
            "reduction_applied": round(reduccion, 4),
            "factor_used": factor,
        }

    def simulate(self, wti_price: float, current_price: float, fuel_type: str) -> dict:
        """Simulacion completa: WTI -> precio teorico -> banda -> resultado.

        Args:
            wti_price: Precio WTI en USD/barril.
            current_price: Precio actual del combustible en USD/galon.
            fuel_type: Tipo de combustible.

        Returns:
            Resultado completo de la simulacion con desglose de formula.
        """
        fuel_config = settings.FUEL_TYPES.get(fuel_type, {})
        fuel_name = fuel_config.get("name", fuel_type)

        # Calcular precio teorico
        theoretical = self.calculate_theoretical_price(wti_price, fuel_type)

        # Aplicar banda
        band_result = self.apply_band(current_price, theoretical, fuel_type)

        # Desglose de la formula
        breakdown = self.get_formula_breakdown(wti_price, fuel_type)

        diff_vs_current = band_result["result"] - current_price
        diff_pct = (diff_vs_current / current_price) * 100 if current_price > 0 else 0

        return {
            "fuel_type": fuel_type,
            "fuel_name": fuel_name,
            "current_price": current_price,
            "wti_input": wti_price,
            "theoretical_price": theoretical,
            "max_price": band_result["max_price"],
            "min_price": band_result["min_price"],
            "final_price": band_result["result"],
            "band_status": band_result["status"],
            "band_applied": band_result["capped"],
            "difference_vs_current": round(diff_vs_current, 3),
            "difference_pct": round(diff_pct, 2),
            "formula_breakdown": breakdown,
        }

    def get_formula_breakdown(self, wti_price: float, fuel_type: str) -> dict:
        """Devuelve el desglose de la formula paso a paso.

        Retorna cada componente para mostrar en la UI de forma educativa.

        Args:
            wti_price: Precio del WTI en USD/barril.
            fuel_type: Tipo de combustible.

        Returns:
            Dict con cada componente de la formula.
        """
        if fuel_type == "super_95":
            price = self._calculate_super95_price(wti_price)
            return {
                "wti_price_barrel": round(wti_price, 2),
                "modelo": "hibrido (WTI + tendencia temporal)",
                "descripcion": "Precio libre - regresion multiple calibrada con 34 meses de datos reales",
                "wti_coeff": settings.SUPER_95_WTI_COEFF,
                "time_coeff": settings.SUPER_95_TIME_COEFF,
                "intercept": settings.SUPER_95_INTERCEPT,
                "mape_historico": "3.6%",
                "theoretical_price": round(price, 4),
            }

        import_cost_gallon = wti_price * settings.WTI_TO_GALLON_FACTOR * settings.IMPORT_COST_WEIGHT
        refining_factor = settings.FUEL_REFINING_FACTOR.get(fuel_type, 1.0)
        refining_adjustment = import_cost_gallon * refining_factor
        transport = settings.TRANSPORT_COST
        storage = settings.STORAGE_COST
        petroecuador_margin = settings.PETROECUADOR_MARGIN

        subtotal_pre_capital = refining_adjustment + transport + storage + petroecuador_margin
        capital_cost = subtotal_pre_capital * settings.CAPITAL_COST_RATE
        subtotal_before_iva = subtotal_pre_capital + capital_cost

        iva_amount = subtotal_before_iva * settings.IVA_RATE
        terminal_price_with_iva = subtotal_before_iva + iva_amount

        commercial_margin = settings.COMMERCIAL_MARGIN
        commercial_margin_iva = commercial_margin * settings.IVA_RATE

        theoretical_price = terminal_price_with_iva + commercial_margin + commercial_margin_iva

        return {
            "wti_price_barrel": round(wti_price, 2),
            "import_cost_gallon": round(import_cost_gallon, 4),
            "refining_adjustment": round(refining_adjustment, 4),
            "transport_cost": round(transport, 4),
            "storage_cost": round(storage, 4),
            "petroecuador_margin": round(petroecuador_margin, 4),
            "capital_cost": round(capital_cost, 4),
            "subtotal_before_iva": round(subtotal_before_iva, 4),
            "iva_amount": round(iva_amount, 4),
            "terminal_price_with_iva": round(terminal_price_with_iva, 4),
            "commercial_margin": round(commercial_margin, 4),
            "commercial_margin_iva": round(commercial_margin_iva, 4),
            "theoretical_price": round(theoretical_price, 4),
        }

    @staticmethod
    def get_next_update_date() -> dict:
        """Retorna fechas de publicacion (dia 11) y vigencia (dia 12) del proximo ajuste."""
        today = date.today()
        publish_day = settings.PRICE_UPDATE_DAY      # 11: EP Petroecuador publica
        effective_day = settings.PRICE_EFFECTIVE_DAY  # 12: nuevo precio entra en vigencia

        current_month_12 = date(today.year, today.month, effective_day)

        if today <= current_month_12:
            next_effective = current_month_12
        else:
            if today.month == 12:
                next_effective = date(today.year + 1, 1, effective_day)
            else:
                next_effective = date(today.year, today.month + 1, effective_day)

        # Dia 11 es siempre el dia anterior al dia 12 de vigencia
        next_publish = next_effective.replace(day=publish_day)

        days_remaining = (next_effective - today).days

        return {
            "next_update_date": next_effective.isoformat(),      # dia 12: vigencia
            "next_publish_date": next_publish.isoformat(),       # dia 11: publicacion
            "days_remaining": days_remaining,
            "is_update_day": days_remaining == 0,
            "is_publish_day": (next_publish - today).days == 0,
        }

    @staticmethod
    def analyze_band_history(historical_data: list, fuel_type: str = "extra") -> dict:
        """Calcula estadisticas del historial de aplicacion de bandas.

        Args:
            historical_data: Lista de dicts con date y precio del combustible.
            fuel_type: Tipo de combustible a analizar.

        Returns:
            Dict con registros detallados y estadisticas globales.
        """
        if len(historical_data) < 2:
            return {"records": [], "stats": {}}

        records = []
        increases = 0
        decreases = 0
        no_change = 0
        ceiling_hits = 0
        floor_hits = 0
        all_changes_pct = []

        for i in range(1, len(historical_data)):
            prev = historical_data[i - 1]
            curr = historical_data[i]

            prev_price = prev.get(fuel_type, 0)
            curr_price = curr.get(fuel_type, 0)

            if prev_price <= 0:
                continue

            change = curr_price - prev_price
            change_pct = (change / prev_price) * 100
            all_changes_pct.append(change_pct)

            max_price = round(prev_price * 1.05, 3)
            min_price = round(prev_price * 0.90, 3)

            tolerance = 0.005
            if curr_price >= max_price - tolerance:
                status = "TECHO"
                ceiling_hits += 1
            elif curr_price <= min_price + tolerance:
                status = "PISO"
                floor_hits += 1
            else:
                status = "DENTRO"

            if change > 0.001:
                increases += 1
            elif change < -0.001:
                decreases += 1
            else:
                no_change += 1

            records.append({
                "date": curr.get("date", ""),
                "fuel_type": fuel_type,
                "price": round(curr_price, 3),
                "previous_price": round(prev_price, 3),
                "change": round(change, 3),
                "change_pct": round(change_pct, 2),
                "band_status": status,
            })

        all_prices = [r["price"] for r in records if r["price"] > 0]
        avg_change = sum(all_changes_pct) / len(all_changes_pct) if all_changes_pct else 0

        stats = {
            "total_months": len(records),
            "increases": increases,
            "decreases": decreases,
            "no_change": no_change,
            "times_ceiling_hit": ceiling_hits,
            "times_floor_hit": floor_hits,
            "max_price": max(all_prices) if all_prices else 0,
            "min_price": min(all_prices) if all_prices else 0,
            "avg_monthly_change_pct": round(avg_change, 2),
        }

        return {"records": records, "stats": stats}
