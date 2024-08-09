# Copyright 2024 olayeku
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     https://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
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
const TARGET = "TGT" # Target
const KROGERS = "KR" # Kroger
const WALMART = "WMT" # Walmart
const MCDONALDS = "MCD" # McDonald's
const UNION = "UN" # Union
const JNJ = "JNJ" # Johnson & Johnson
const JPM = "JPM" # JPMorgan Chase
const V = "V" # Visa
const CONSUMER = [TARGET, KROGERS, WALMART, MCDONALDS, UNION, JNJ, JPM, V]

# Hospitality
const MARRIOTT = "MARA" # Marriott
const HI = "HI" # Hilton
const HIW = "HIW" # Hilton Worldwide
const AIRBNB = "AIR" # Airbnb   
const HOSPITALITY = [MARRIOTT, HI, HIW, AIRBNB]

# Finance
const CHASE = "CM" # Chase
const BAC = "BAC" # Bank of America
const MASTERCARD = "MS" # Mastercard
const VISA = "V" # Visa
const AMEX = "AXP" # American Express
const WELLSFARGO = "WFC" # Wells Fargo
const FINANCE = [CHASE, BAC, MASTERCARD, VISA, AMEX, WELLSFARGO]

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
const AUTOMOTIVE = [GM, FORD, AUDI, VOLKSWAGEN, RIVIAN, TOYOTA, HONDA, BMW, VOLVO]





export TECH, CONSUMER, HOSPITALITY, FINANCE, AUTOMOTIVE

end # module
