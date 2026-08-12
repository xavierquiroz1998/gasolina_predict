"""Configuracion central de la aplicacion GasPredict Ecuador."""

from pydantic import BaseModel


class Settings(BaseModel):
    """Configuracion de la aplicacion."""

    APP_NAME: str = "GasPredict Ecuador"
    APP_VERSION: str = "1.4.0"

    # Tickers de Yahoo Finance
    WTI_TICKER: str = "CL=F"              # Crudo WTI
    BRENT_TICKER: str = "BZ=F"            # Crudo Brent
    NATURAL_GAS_TICKER: str = "NG=F"      # Gas Natural (referencia)
    DOLLAR_INDEX_TICKER: str = "DX-Y.NYB"  # Indice del Dolar

    # Tipos de combustible ecuatorianos
    FUEL_TYPES: dict = {
        "extra": {
            "name": "Extra (RON 87)",
            "band_system": True,
            "max_increase": 0.05,   # +5% mensual maximo
            "max_decrease": -0.10,  # -10% mensual maximo
        },
        "ecopais": {
            "name": "Ecopais",
            "band_system": True,
            "max_increase": 0.05,
            "max_decrease": -0.10,
        },
        "super_95": {
            "name": "Super 95",
            "band_system": False,  # Precio libre, no esta en el sistema de bandas
            "max_increase": None,
            "max_decrease": None,
        },
        "diesel": {
            "name": "Diesel Premium",
            "band_system": True,
            "max_increase": 0.05,
            "max_decrease": -0.10,
        },
    }

    # Factores de la formula de precio del gobierno
    # Precio final = Precio en Terminal (con IVA) + Margen de Comercializacion (con IVA)
    # Calibrado con datos reales: Marzo 2026 WTI~$70 -> Extra=$2.89, Super=$3.41, Diesel=$2.828
    IMPORT_COST_WEIGHT: float = 1.00       # Peso del costo de importacion (incluido en WTI_TO_GALLON_FACTOR)
    TRANSPORT_COST: float = 0.12           # $/galon transporte
    STORAGE_COST: float = 0.05             # $/galon almacenamiento
    PETROECUADOR_MARGIN: float = 0.08      # $/galon margen EP Petroecuador
    COMMERCIAL_MARGIN: float = 0.128       # $/galon margen comercializacion
    CAPITAL_COST_RATE: float = 0.1078      # Tasa costo de capital (10.78% - D.E. 83)
    IVA_RATE: float = 0.15                 # 15% IVA Ecuador (desde abril 2024)

    # Factor de conversion WTI ($/barril) a $/galon base (CALIBRADO)
    # Calibrado inversamente: WTI=$70 -> import cost ~$1.90/galon -> Extra teorico $2.89
    # Anteriormente era 0.022*0.45=0.0099 (incorrecto, daba precios irreales)
    WTI_TO_GALLON_FACTOR: float = 0.0272   # Factor calibrado con datos reales 2024-2026

    # Factores de ajuste por tipo de combustible (CALIBRADOS con precios reales)
    FUEL_REFINING_FACTOR: dict = {
        "extra": 1.000,      # Base (RON 87) - calibrado a $2.89 con WTI=$70
        "ecopais": 1.000,    # Mismo precio que Extra (mezcla con etanol)
        "super_95": 1.214,   # Mayor octanaje (RON 95) - calibrado a $3.41 con WTI=$70
        "diesel": 0.974,     # Calibrado a $2.828 con WTI=$70 (post-eliminacion subsidio)
    }

    # Modelo HIBRIDO para Super 95 (precio libre, no usa formula del Decreto 308)
    # Regresion multiple calibrada con 34 meses de datos reales (jun-2023 a abr-2026)
    # Super = WTI_COEFF*WTI + TIME_COEFF*(meses_desde_jun2023) + INTERCEPT
    # MAPE=3.6% sobre ultimos 12 meses (mejor que lineal simple MAPE=7%)
    SUPER_95_WTI_COEFF: float = 0.016108    # impacto del WTI en precio
    SUPER_95_TIME_COEFF: float = 0.036084   # tendencia mensual estructural
    SUPER_95_INTERCEPT: float = 2.0587      # constante
    SUPER_95_BASE_MONTH: int = 34           # abr-2026 = mes 34 desde jun-2023
    # Coeficientes legacy (no usados)
    SUPER_95_SLOPE: float = 0.03314
    SUPER_95_COEFF_A: float = 0.0
    SUPER_95_COEFF_B: float = 0.0
    SUPER_95_COEFF_C: float = 0.0

    # Correlacion empirica WTI -> precio local
    WTI_CORRELATION: dict = {
        "extra": 0.72,
        "ecopais": 0.72,
        "super_95": 0.85,
        "diesel": 0.68,
    }

    # Parametros del sistema de bandas (Decreto 308)
    BAND_CEILING: float = 0.05    # +5% maximo mensual
    BAND_FLOOR: float = -0.10     # -10% maximo mensual
    PRICE_UPDATE_DAY: int = 11    # Dia en que EP Petroecuador publica los precios (noche del 11)
    PRICE_EFFECTIVE_DAY: int = 12  # Dia en que el nuevo precio entra en vigencia

    # Decreto Ejecutivo 444 (9 julio 2026) - Mecanismo excepcional de volatilidad
    # Reforma el Decreto 83 (ago-2025). Activa una reduccion adicional cuando el mercado
    # internacional cae bruscamente despues de un alza prolongada y Ecuador aplico TECHO.
    #
    # Condiciones de activacion (las 3 deben cumplirse simultaneamente):
    #   1. PPI acumulo caida >= 15% en los 2 periodos bimestrales anteriores
    #   2. PPI acumulo alza >= 50% en hasta 3 periodos trimestrales previos
    #   3. El precio en terminal alcanzo el TECHO (+5%) en los 2 ultimos ajustes
    #
    # Formula de reduccion:
    #   reduccion_mensual = 10% * variacion_acumulada_PPI_2_periodos
    #   tope maximo de reduccion: 1.5% del precio vigente por mes
    DECRETO444_ACTIVE: bool = True           # activar logica del D.E. 444
    DECRETO444_PPI_CAIDA_MIN: float = 0.15   # caida PPI minima para activar (15%)
    DECRETO444_PPI_ALZA_PREVIA: float = 0.50 # alza PPI previa necesaria (50%)
    DECRETO444_TECHOS_REQUERIDOS: int = 2    # meses consecutivos en TECHO requeridos
    DECRETO444_REDUCCION_FACTOR: float = 0.10  # reduccion = 10% de variacion PPI acumulada
    DECRETO444_REDUCCION_MAX: float = 0.015  # tope maximo de reduccion mensual (1.5%)

    # Decreto Ejecutivo 468 (11 agosto 2026) - Mecanismo de reduccion gradual
    # Reemplaza la logica de banda ordinaria cuando esta activo: en lugar de subir
    # al TECHO o calcular precio libre de mercado, aplica una reduccion mensual fija
    # del precio vigente dentro del rango [0.75%, 1.5%].
    # Empieza en el minimo (0.75%) y avanza progresivamente hasta el maximo (1.5%).
    # Se desactiva cuando el PPI internacional sube >40% respecto al valor de 4 meses atras.
    # Aplica a: Extra, EcoPais, Diesel. No aplica a Super 95 (precio libre).
    DECRETO468_ACTIVE: bool = True
    DECRETO468_FECHA_INICIO: str = "2026-08-12"   # vigencia desde esta fecha
    DECRETO468_REDUCCION_MIN: float = 0.0075      # 0.75% reduccion minima mensual
    DECRETO468_REDUCCION_MAX: float = 0.015       # 1.50% reduccion maxima mensual
    DECRETO468_MESES_ACTIVO: int = 0              # meses que lleva activo (0=primer mes)
    DECRETO468_PPI_ALZA_DESACTIVACION: float = 0.40  # se desactiva si PPI sube >40% en 4 meses

    # Datos
    DEFAULT_HISTORY_YEARS: int = 6          # Desde 2020
    DEFAULT_PREDICTION_MONTHS: int = 3
    BAND_START_DATE: str = "2020-07-01"     # Inicio del sistema de bandas

    # CORS
    CORS_ORIGINS: list[str] = ["http://localhost:3000", "http://localhost:3001"]

    # Base de datos PostgreSQL
    DATABASE_URL: str = "postgresql://gaspredict:gaspredict2026@localhost:5436/gaspredict"
    DB_ENABLED: bool = True  # Se pone False automaticamente si no hay conexion


settings = Settings()
