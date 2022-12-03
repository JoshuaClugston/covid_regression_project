import pandas as pd
import datetime
from dateutil import parser

'''
note: one value (Feb-29) was changed manually to 29-Feb to
match the other values' pattern in covid_data.csv below. 
'''

covid_df = pd.read_csv(r'covid_data.csv')

'''
according to CDC (https://www.cdc.gov/museum/timeline/covid19.html#:~:t
ext=January%2020%2C%202020,respond%20to%20the%20emerging%20outbreak.),
fist officially (laboratory) reported case in US was discovered on
2020-20-2020. This information is used to define orig_date below.
'''

orig_date = '2020-01-20'
day_orig = parser.parse(orig_date)

day_lst = []

for ind in covid_df.index:
   date = covid_df['State of emergency declared'][ind]
   new_date = '2020-' + date
   day = parser.parse(new_date)
   delta = day-day_orig
   delta_update = delta.days + 1
   day_lst.append(delta_update)

covid_df['State of emergency declared'] = day_lst
covid_df.to_csv('covid_data_updated.csv')

   
# note: one value (Feb-29) was changed manually to 29-Feb
# to match the other values' pattern

















 
