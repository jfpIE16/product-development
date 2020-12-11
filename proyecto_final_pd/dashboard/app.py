import pandas as pd
import numpy
import streamlit as st
from sqlalchemy import create_engine
import pymysql
import plotly.express as px
from datetime import date, timedelta


@st.cache
def load_data(op="deaths"):
    db_connection_str = 'mysql+pymysql://test:test123@172.28.1.2/proyecto_pd'
    db_connection = create_engine(db_connection_str)
    df = pd.read_sql(f'SELECT province, country, lat, lon,event_date,accumulated as {op} FROM covid19_{op}', con=db_connection)
    return df
    
st.title("COVID19 Time series Analysis")
st.subheader("José Fernando Pérez Pérez , 20000756")
st.write("\n")
st.subheader("Mapa Interactivo")
st.markdown("Selecciona el dataset a visualizar: ")
st.markdown("**Opciones:** Casos confirmados, Muertes confirmadas y pacientes\
            recuperados")

data_option = st.selectbox("Dataset", ["deaths", "recovered", "confirmed"])
df = load_data(data_option)
date_value = st.slider("Seleccione fecha:",
                      value=date(2020,1,1),
                      format="MM/DD/YY",
                      min_value=df.event_date.min(),
                      max_value=df.event_date.max())
filtered_df = df[df.event_date == date_value]
try:
    fig = px.scatter_geo(filtered_df,
                         lat=filtered_df.lat,
                         lon=filtered_df.lon,
                         color=data_option,
                         size=filtered_df[data_option],
                         projection="natural earth",
                         title=f"Accumulated {data_option}",
                         size_max=50
                        )
    st.plotly_chart(fig, use_container_width=True)
except:
   st.write("No hay datos disponibles")

st.subheader("Análisis por país")
df_deaths = load_data(op="deaths")
df_recove = load_data(op="recovered")
df_confir = load_data(op="confirmed")

r_df = pd.merge(df_deaths, df_recove,
                on=['province','country','lat','lon','event_date'])
r_df = pd.merge(r_df,df_confir,
                on=['province','country','lat','lon','event_date'])
r_df = r_df.drop(['province','lat','lon'], axis=1)
r_df = r_df.groupby(['country',
                     'event_date']
                   )[['deaths',
                      'confirmed',
                      'recovered']].sum().reset_index()
country = st.selectbox("Seleccione país", r_df.country.unique())

country_data = r_df[r_df.country == country]
fig2 = px.line(country_data, x="event_date",
               y=["confirmed","deaths","recovered"],
               title=f"Time Series for {country}",
               labels={"event_date":"Fecha en meses"}
              )
fig2.update_xaxes(
    rangeslider_visible=True,
    rangeselector=dict(
        buttons=list([
            dict(count=1, label="1m", step="month", stepmode="backward"),
            dict(count=4, label="4m", step="month", stepmode="backward"),
            dict(count=6, label="6m", step="month", stepmode="backward"),
            dict(count=1, label="1y", step="year", stepmode="backward"),
            dict(step="all")
        ])
    )
)
st.plotly_chart(fig2)

