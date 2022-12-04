import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import os

covid_df = pd.read_csv(r'covid_data_updated.csv')
covid_df = covid_df.drop(['Unnamed: 0', 'State'], axis=1)

# create new folder for images
os.mkdir('hist_img/')

for column in covid_df.columns:
    sns.displot(data=covid_df[column], kde=True, color='red')
    plt.ylabel('Frequency')
    plt.title(f'Histogram for {column}')
    column_name = column.replace(' ', '')
    plt.savefig(f'hist_img/{column_name}')
    plt.show()
