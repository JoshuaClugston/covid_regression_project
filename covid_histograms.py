import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd

covid_df = pd.read_csv(r'covid_data_updated.csv')
covid_df = covid_df.drop(['Unnamed: 0', 'State'], axis=1)


for column in covid_df.columns:
    sns.displot(data=covid_df[column], kde=True, color='red')
    plt.title(f'Histogram for {column}')
    plt.show()
