#lang reader "beancount.rkt"
;; -*- mode: org; mode: beancount; -*-
;; Birth: 1980-05-12
;; Dates: 2020-01-01 - 2022-09-25
;; THIS FILE HAS BEEN AUTO-GENERATED.
* Options

option "title" "Example Beancount file"
option "operating_currency" "USD"




* Commodities


1792-01-01 commodity USD
  export: "CASH"
  name: "US Dollar"

1900-01-01 commodity VMMXX
  export: "MUTF:VMMXX (MONEY:USD)"

1980-05-12 commodity VACHR
  export: "IGNORE"
  name: "Employer Vacation Hours"

1980-05-12 commodity IRAUSD
  export: "IGNORE"
  name: "US 401k and IRA Contributions"

1995-09-18 commodity VBMPX
  export: "MUTF:VBMPX"
  name: "Vanguard Total Bond Market Index Fund Institutional Plus Shares"
  price: "USD:google/MUTF:VBMPX"


* Equity Accounts

1980-05-12 open Equity:Opening-Balances
1980-05-12 open Liabilities:AccountsPayable



* Banking

2020-01-01 open Assets:US:BofA
  address: "123 America Street, LargeTown, USA"
  institution: "Bank of America"
  phone: "+1.012.345.6789"
2020-01-01 open Assets:US:BofA:Checking                        USD
  account: "00234-48574897"

2020-01-01 * "Opening Balance for checking account"
  Assets:US:BofA:Checking                         3239.66 USD
  Equity:Opening-Balances                        -3239.66 USD

2020-01-02 balance Assets:US:BofA:Checking        3239.66 USD

2020-01-04 * "BANK FEES" "Monthly bank fee"
  Assets:US:BofA:Checking                           -4.00 USD
  Expenses:Financial:Fees                            4.00 USD

2020-01-06 * "RiverBank Properties" "Paying the rent"
  Assets:US:BofA:Checking                        -2400.00 USD
  Expenses:Home:Rent                              2400.00 USD

2020-01-08 * "EDISON POWER" ""
  Assets:US:BofA:Checking                          -65.00 USD
  Expenses:Home:Electricity                         65.00 USD

2020-01-20 * "Verizon Wireless" ""
  Assets:US:BofA:Checking                          -46.30 USD
  Expenses:Home:Phone                               46.30 USD

2020-01-21 * "Wine-Tarner Cable" ""
  Assets:US:BofA:Checking                          -80.08 USD
  Expenses:Home:Internet                            80.08 USD

2020-01-22 balance Assets:US:BofA:Checking        3181.52 USD

2020-02-03 * "RiverBank Properties" "Paying the rent"
  Assets:US:BofA:Checking                        -2400.00 USD
  Expenses:Home:Rent                              2400.00 USD

2022-09-23 * "Chichipotle" "Eating out with Julie"
  Liabilities:US:Chase:Slate                       -45.43 USD
  Expenses:Food:Restaurant                          45.43 USD



* Taxable Investments

2020-01-01 open Assets:US:ETrade:Cash                       USD
2020-01-01 open Assets:US:ETrade:ITOT                       ITOT
2020-01-01 open Assets:US:ETrade:VEA                       VEA
2020-01-01 open Assets:US:ETrade:VHT                       VHT
2020-01-01 open Assets:US:ETrade:GLD                       GLD
2020-01-01 open Income:US:ETrade:PnL                        USD
2020-01-01 open Income:US:ETrade:ITOT:Dividend              USD
2020-01-01 open Income:US:ETrade:VEA:Dividend              USD
2020-01-01 open Income:US:ETrade:VHT:Dividend              USD
2020-01-01 open Income:US:ETrade:GLD:Dividend              USD

2020-09-12 * "Buy shares of VEA"
  Assets:US:ETrade:Cash                          -1239.85 USD
  Assets:US:ETrade:VEA                                 11 VEA {111.90 USD, 2020-09-12}
  Expenses:Financial:Commissions                     8.95 USD

2020-09-12 * "Buy shares of GLD"
  Assets:US:ETrade:Cash                          -1307.35 USD
  Assets:US:ETrade:GLD                                 12 GLD {108.20 USD, 2020-09-12}
  Expenses:Financial:Commissions                     8.95 USD

2020-09-12 * "Buy shares of ITOT"
  Assets:US:ETrade:Cash                          -1134.67 USD
  Assets:US:ETrade:ITOT                                 6 ITOT {187.62 USD, 2020-09-12}
  Expenses:Financial:Commissions                     8.95 USD



* Vanguard Investments

2020-01-01 open Assets:US:Vanguard:VBMPX                     VBMPX
  number: "882882"
2020-01-01 open Assets:US:Vanguard:RGAGX                     RGAGX
  number: "882882"
2020-01-01 open Assets:US:Vanguard                            USD
  address: "P.O. Box 1110, Valley Forge, PA 19482-1110"
  institution: "Vanguard Group"
  phone: "+1.800.523.1188"
2020-01-01 open Income:US:BayBook:Match401k                   USD
2020-01-01 open Assets:US:Vanguard:Cash                       USD
  number: "882882"

2020-01-03 * "Employer match for contribution"
  Assets:US:Vanguard:Cash                          600.00 USD
  Income:US:BayBook:Match401k                     -600.00 USD

2020-01-06 * "Investing 40% of cash in VBMPX"
  Assets:US:Vanguard:VBMPX                          5.646 VBMPX {85.02 USD, 2020-01-06}
  Assets:US:Vanguard:Cash                         -480.02 USD

2020-01-06 * "Investing 60% of cash in RGAGX"
  Assets:US:Vanguard:RGAGX                          5.203 RGAGX {138.37 USD, 2020-01-06}
  Assets:US:Vanguard:Cash                         -719.94 USD




* Sources of Income

2020-01-01 open Income:US:BayBook:Salary                      USD
2020-01-01 open Income:US:BayBook:GroupTermLife               USD
2020-01-01 open Income:US:BayBook:Vacation                    VACHR
2020-01-01 open Assets:US:BayBook:Vacation                    VACHR
2020-01-01 open Expenses:Vacation                               VACHR
2020-01-01 open Expenses:Health:Life:GroupTermLife
2020-01-01 open Expenses:Health:Medical:Insurance
2020-01-01 open Expenses:Health:Dental:Insurance
2020-01-01 open Expenses:Health:Vision:Insurance

2020-01-01 event "employer" "BayBook, 1501 Billow Rd, Benlo Park, CA"

2020-01-02 * "BayBook" "Payroll"
  Assets:US:BofA:Checking                         1350.60 USD
  Assets:US:Vanguard:Cash                         1200.00 USD
  Income:US:BayBook:Salary                       -4615.38 USD
  Income:US:BayBook:GroupTermLife                  -24.32 USD
  Expenses:Health:Life:GroupTermLife                24.32 USD
  Expenses:Health:Dental:Insurance                   2.90 USD
  Expenses:Health:Medical:Insurance                 27.38 USD
  Expenses:Health:Vision:Insurance                  42.30 USD
  Expenses:Taxes:Y2020:US:Medicare                 106.62 USD
  Expenses:Taxes:Y2020:US:Federal                 1062.92 USD
  Expenses:Taxes:Y2020:US:State                    365.08 USD
  Expenses:Taxes:Y2020:US:CityNYC                  174.92 USD
  Expenses:Taxes:Y2020:US:SDI                        1.12 USD
  Expenses:Taxes:Y2020:US:SocSec                   281.54 USD
  Assets:US:Federal:PreTax401k                   -1200.00 IRAUSD
  Expenses:Taxes:Y2020:US:Federal:PreTax401k      1200.00 IRAUSD
  Assets:US:BayBook:Vacation                            5 VACHR
  Income:US:BayBook:Vacation                           -5 VACHR





** Tax Year 2020

2020-01-01 open Expenses:Taxes:Y2020:US:Federal:PreTax401k      IRAUSD
2020-01-01 open Expenses:Taxes:Y2020:US:Medicare                USD
2020-01-01 open Expenses:Taxes:Y2020:US:Federal                 USD
2020-01-01 open Expenses:Taxes:Y2020:US:CityNYC                 USD
2020-01-01 open Expenses:Taxes:Y2020:US:SDI                     USD
2020-01-01 open Expenses:Taxes:Y2020:US:State                   USD
2020-01-01 open Expenses:Taxes:Y2020:US:SocSec                  USD

2020-01-01 balance Assets:US:Federal:PreTax401k         0 IRAUSD

2020-01-01 * "Allowed contributions for one year"
  Income:US:Federal:PreTax401k                     -18500 IRAUSD
  Assets:US:Federal:PreTax401k                      18500 IRAUSD

2021-03-25 * "Filing taxes for 2020"
  Expenses:Taxes:Y2020:US:Federal                  513.35 USD
  Expenses:Taxes:Y2020:US:State                    361.95 USD
  Liabilities:AccountsPayable                     -875.30 USD

2021-03-27 * "STATE TAX & FINANC PYMT"
  Assets:US:BofA:Checking                         -361.95 USD
  Liabilities:AccountsPayable                      361.95 USD

2021-03-28 * "FEDERAL TAXPYMT"
  Assets:US:BofA:Checking                         -513.35 USD
  Liabilities:AccountsPayable                      513.35 USD



** Tax Year 2021

2021-01-01 open Expenses:Taxes:Y2021:US:Federal:PreTax401k      IRAUSD
2021-01-01 open Expenses:Taxes:Y2021:US:Medicare                USD
2021-01-01 open Expenses:Taxes:Y2021:US:Federal                 USD
2021-01-01 open Expenses:Taxes:Y2021:US:CityNYC                 USD
2021-01-01 open Expenses:Taxes:Y2021:US:SDI                     USD
2021-01-01 open Expenses:Taxes:Y2021:US:State                   USD
2021-01-01 open Expenses:Taxes:Y2021:US:SocSec                  USD

2021-01-01 balance Assets:US:Federal:PreTax401k         0 IRAUSD

2021-01-01 * "Allowed contributions for one year"
  Income:US:Federal:PreTax401k                     -18500 IRAUSD
  Assets:US:Federal:PreTax401k                      18500 IRAUSD

2022-03-20 * "Filing taxes for 2021"
  Expenses:Taxes:Y2021:US:Federal                  617.92 USD
  Expenses:Taxes:Y2021:US:State                    333.66 USD
  Liabilities:AccountsPayable                     -951.58 USD

2022-03-23 * "FEDERAL TAXPYMT"
  Assets:US:BofA:Checking                         -617.92 USD
  Liabilities:AccountsPayable                      617.92 USD

2022-03-23 * "STATE TAX & FINANC PYMT"
  Assets:US:BofA:Checking                         -333.66 USD
  Liabilities:AccountsPayable                      333.66 USD



** Tax Year 2022

2022-01-01 open Expenses:Taxes:Y2022:US:Federal:PreTax401k      IRAUSD
2022-01-01 open Expenses:Taxes:Y2022:US:Medicare                USD
2022-01-01 open Expenses:Taxes:Y2022:US:Federal                 USD
2022-01-01 open Expenses:Taxes:Y2022:US:CityNYC                 USD
2022-01-01 open Expenses:Taxes:Y2022:US:SDI                     USD
2022-01-01 open Expenses:Taxes:Y2022:US:State                   USD
2022-01-01 open Expenses:Taxes:Y2022:US:SocSec                  USD

2022-01-01 balance Assets:US:Federal:PreTax401k         0 IRAUSD

2022-01-01 * "Allowed contributions for one year"
  Income:US:Federal:PreTax401k                     -18500 IRAUSD
  Assets:US:Federal:PreTax401k                      18500 IRAUSD



* Expenses

1980-05-12 open Expenses:Food:Groceries
1980-05-12 open Expenses:Food:Restaurant
1980-05-12 open Expenses:Food:Coffee
1980-05-12 open Expenses:Food:Alcohol
1980-05-12 open Expenses:Transport:Tram
1980-05-12 open Expenses:Home:Rent
1980-05-12 open Expenses:Home:Electricity
1980-05-12 open Expenses:Home:Internet
1980-05-12 open Expenses:Home:Phone
1980-05-12 open Expenses:Financial:Fees
1980-05-12 open Expenses:Financial:Commissions



* Prices

2020-01-03 price VBMPX                              85.02 USD
2020-01-03 price RGAGX                             138.37 USD
2020-01-03 price ITOT                              196.86 USD
2020-01-03 price VEA                               118.76 USD
2020-01-03 price VHT                                57.41 USD
2020-01-03 price GLD                               107.85 USD
2020-01-10 price VBMPX                              85.48 USD
2020-01-10 price RGAGX                             139.61 USD



* Cash


