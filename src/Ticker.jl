
module Ticker 

# Tech
const MICROSOFT = "MSFT" # Microsoft
const APPLE = "AAPL" # Apple
const GOOGLE = "GOOGL" # Google
const TESLA = "TSLA" # Tesla
const ORACLE = "ORCL" # Oracle
const IBM = "IBM" # IBM
const NVIDIA = "NVDA" # NVIDIA
const ADOBE = "ADBE" # Adobe
const AMD = "AMD" # AMD
const PAYPAL = "PYPL" # Paypal
const CISCO = "CSCO" # Cisco
const META = "META" # Meta
const SAP = "SAP" # SAP
const WORKDAY = "WDAY" # Workday
const SALESFORCE = "CRM" # Salesforce
const NETFLIX = "NFLX" # Netflix
const AMAZON = "AMZN" # Amazon
const TECH = [MICROSOFT, APPLE, GOOGLE, TESLA, ORACLE, IBM, NVIDIA, ADOBE, AMD, PAYPAL, CISCO, META, SAP, WORKDAY, SALESFORCE, NETFLIX, AMAZON]

# Consumer
const WMT = "WMT" # Walmart
const PG = "PG" # Procter & Gamble
const COKE = "KO" # Coca-Cola
const PEP = "PEP" # PepsiCo
const COST = "COST" # Costco
const NKE = "NKE" # Nike
const MCD = "MCD" # McDonald's
const SBUX = "SBUX" # Starbucks
const TGT = "TGT" # Target
const HD = "HD" # Home Depot
const LOWE = "LOW" # Lowe's
const DISNEY = "DIS" # Disney
const NETFLIX = "NFLX" # Netflix
const CONSUMER = [WMT, PG, COKE, PEP, COST, NKE, MCD, SBUX, TGT, HD, LOWE, DISNEY, NETFLIX]

# Hospitality
const MARRIOTT = "MARA" # Marriott
const HILTON = "HI" # Hilton
const HILTON_WORLDWIDE = "HIW" # Hilton Worldwide
const AIRBNB = "AIR" # Airbnb   
const HOSPITALITY = [MARRIOTT, HILTON, HILTON_WORLDWIDE, AIRBNB]

# Finance
const CHASE = "CM" # Chase
const BAC = "BAC" # Bank of America
const MASTERCARD = "MS" # Mastercard
const VISA = "V" # Visa
const AMEX = "AXP" # American Express
const WELLSFARGO = "WFC" # Wells Fargo
const JPM = "JPM" # JPMorgan Chase
const CITI = "C" # Citigroup
const PYPL = "PYPL" # Paypal
const BLK = "BLK" # Blackrock
const MS = "MS" # Morgan Stanley
const GS = "GS" # Goldman Sachs
const COF = "COF" # Capital One
const SCHW = "SCHW" # Charles Schwab
const WFC = "WFC" # Wells Fargo
const FINANCE = [CHASE, BAC, MASTERCARD, VISA, AMEX, WELLSFARGO, CITI, PYPL, BLK, MS, GS, COF, SCHW, WFC] 

# Automotive
const GM = "GM" # General Motors
const FORD = "F" # Ford
const AUDI = "AUD" # Audi
const VOLKSWAGEN = "V" # Volkswagen
const RIVIAN = "RIV" # Rivian
const TOYOTA = "TM" # Toyota    
const HONDA = "HMC" # Honda
const BMW = "BMW" # BMW
const VOLVO = "VOLV" # Volvo
const MERCEDES = "MBG" # Mercedes
const AUTOMOTIVE = [GM, FORD, AUDI, VOLKSWAGEN, RIVIAN, TOYOTA, HONDA, BMW, VOLVO, MERCEDES]

# Energy
const XOM = "XOM" # Exxon Mobil 
const CVX = "CVX" # Chevron
const BP = "BP" # BP
const SHELL = "SHEL" # Shell
const TOTAL = "TOT" # Total
const ENI = "ENI" # Eni
const RWE = "RWE" # RWE
const ENERGY = [XOM, CVX, BP, SHELL, TOTAL, ENI, RWE]

# Healthcare
const JNJ = "JNJ" # Johnson & Johnson
const PFE = "PFE" # Pfizer
const MRK = "MRK" # Merck
const ABBV = "ABBV" # AbbVie
const AMGN = "AMGN" # Amgen
const BMY = "BMY" # Bristol-Myers Squibb
const GSK = "GSK" # GlaxoSmithKline
const HEALTHCARE = [JNJ, PFE, MRK, ABBV, AMGN, BMY, GSK]    



export TECH, CONSUMER, HOSPITALITY, FINANCE, AUTOMOTIVE, ENERGY, HEALTHCARE 

end # module
