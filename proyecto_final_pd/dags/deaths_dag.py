import os

from airflow import DAG
from airflow.contrib.hooks.fs_hook import FSHook
from airflow.contrib.sensors.file_sensor import FileSensor
from airflow.hooks.mysql_hook import MySqlHook
from airflow.operators.python_operator import PythonOperator
from airflow.utils.dates import days_ago
from structlog import get_logger
import pandas as pd

logger = get_logger()

FILE_CONNECTION_ID = "fs_default"
FILE_NAME = "time_series_covid19_deaths_global.csv"
OUTPUT_TRANSFORM_FILE = "temp_deaths.csv"
COLUMNS = ["province",
           "country",
           "lat",
           "lon",
           "event_date",
           "accumulated"
          ]

KEPT_COLUMNS = ["Province/State",
                "Country/Region",
                "Lat",
                "Long"
               ]

dag = DAG('deaths_covid_dag', description='Timeseries covid19',
         default_args={
            'owner':'josef.perez',
            'depends_on_past': False,
            'max_active_runs': 1,
            'start_date': days_ago(1)
         },
         schedule_interval='0 2 * * *',
         catchup=False)

file_sensor_task = FileSensor(dag=dag,
                              task_id="file_sensor",
                              fs_conn_id=FILE_CONNECTION_ID,
                              filepath=FILE_NAME,
                              poke_interval=10,
                              timeout=300
                             )

def transform_func(**kwargs):
    folder_path = FSHook(conn_id=FILE_CONNECTION_ID).get_path()
    file_path = f"{folder_path}/{FILE_NAME}"
    destination_file = f"{folder_path}/{OUTPUT_TRANSFORM_FILE}"
    df_original = pd.read_csv(file_path)
    df_processed = df_original.melt(id_vars=KEPT_COLUMNS,
                                    var_name="Date",
                                    value_name="Accumulated"
                                   )
    df_processed.columns = COLUMNS
    df_processed["event_date"] = pd.to_datetime(df_processed["event_date"])
    df_processed.to_csv(destination_file, index=False)
    os.remove(file_path)
    return destination_file

transform_process = PythonOperator(dag=dag,
                                   task_id="transform_process",
                                   python_callable=transform_func,
                                   provide_context=True
                                  )

def insert_process(**kwargs):
    ti = kwargs['ti']
    source_csv = ti.xcom_pull(task_ids='transform_process')
    source_df = pd.read_csv(source_csv)
    db_connection = MySqlHook('db_proyecto').get_sqlalchemy_engine()
    
    with db_connection.begin() as transaction:
        transaction.execute("DELETE FROM proyecto_pd.covid19_deaths WHERE 1=1")
        source_df.to_sql("covid19_deaths", con=transaction,
                         schema="proyecto_pd", if_exists="append", index=False)

    os.remove(source_csv)

insert_process = PythonOperator(dag=dag,
                                task_id="insert_process",
                                provide_context=True,
                                python_callable=insert_process
                                )

file_sensor_task >> transform_process >> insert_process
