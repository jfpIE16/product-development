# Documentación Proyecto final 
### José Fernando Pérez Pérez, 20000756  
---
A continuación se presentarán los razonamientos e implemetación técnica utilizados en la creación del proyecto final del curso desarrollo de productos de la maestría en Ciencia de Datos ofrecida por Universidad Galileo.  
**Descripción del proyecto**: Se solicito la creación de un pipelane para simular el proceso de ETL con el objetivo de alimentar una base de datos que funcionara como punto de partida para el análisis estadístico de la
información acumulada en forma de series de tiempo para la evolución del virus *COVID-19* a nivel global.

### Tecnologías utilizadas
* *Docker*, para creación de contenedores con distintas aplicaciones.
* *Apache airflow*, se utilizo para calendarización y orquestación de tareas en el proceso ETL, se implementaron las funciones para transformación y carga de datos.
* *Docker Compose*, utilizado para orquestar las imágenes de *docker* y crear un ambiente de desarrollo funcional.
* *MySQL*, base de datos relacional utilizada para almacenar y consultar la información ya procesada.
* *Streamlit*, librería utilizada para la creación del dashboard con el análisis de los datos de **COVID-19** en forma de series de tiempo. Se crearon 2 gráficos principales, un mapa con los datos acumulados por país/provincia y 
un gráfico de línea con la sumarización del crecimiento a traves del tiempo de los contadores implementados.

### Infraestructura del proyecto
Se utilizó *docker* y *docker-compose* para montar un entorno de desarrollo unificado, "parecido" a un entorno real. Se utilizarón las siguientes imágenes:
* *MySQL* versión 5.7.17, se nombro como **db**.
* *Postgres* versión 9.6, se nombro como **postgres** utilizada para *airflow* exclusivamente.
* *Airflow* imagen creada y mantenida por **Puckel**, se nombro como **webserver**.
* *Streamlit* imagen creada utilizando **Dockerfile** a partir de *python 3.7*, se nombro como **dashboard**.
Para simular un ambiente más real se creo una red interna y se asigno una IP estática a cada imagen mencionada anteriormente la *subnet* creada es la 172.28.0.0/16 y se asignaron las IPs de la siguiente manera:
* db &#8594; 172.28.1.2/32 exponiendo el puerto 3306.
* postgres &#8594; 172.28.1.3/32
* airflow &#8594; 172.28.1.4/32 exponiendo el puerto 8080.
* dashboard &#8594; 172.28.1.5/32 exponiendo el puerto 8501.

A continuación se muestra un diagrama de árbol de la estructura de ficheros utilizada para el proyecto.
![img](/proyecto_final_pd/img/project_tree.png)

### Desarrollo del proyecto
#### Implementación de la base de datos
Para la creación de la base de datos se monto el volumen /data/db_schemas en la carpeta /docker-entrypoint-initdb.d, la imagen esta configurada de tal forma que al inicializarse ejecuta los scripts **.sql** y **.sh** que se encuentren en dicho directorio, se agrego un script en SQL para la creación de las 3 bases de datos que corresponden a cada conjunto de datos. A continuación se observa la definición de una tabla en dicho script:
~~~~sql
USE proyecto_pd;

CREATE TABLE covid19_confirmed (
	id INT NOT NULL AUTO_INCREMENT,
	province VARCHAR(90),
	country VARCHAR(90),
	lat DECIMAL(16,7),
	lon DECIMAL(16,7),
	event_date DATE,
	accumulated INT,
	PRIMARY KEY (id)
);
~~~~
#### Creación de DAGs en airflow
Tomando como ejemplo lo aprendido en clase se creo un DAG para cada archivo de la siguiente manera:
* Implementación de un sensor que espera un archivo específico (confirmed|deaths|recovered).
~~~~python
file_sensor_task = FileSensor(dag=dag,
                              task_id="file_sensor",
                              fs_conn_id=FILE_CONNECTION_ID,
                              filepath=FILE_NAME,
                              poke_interval=10,
                              timeout=300
                             )
~~~~
* **Python operator** para aplicar una función de transformación, el proceso de transformación utiliza la función *melt* de pandas utilizada como el inverso de pivotear con el objetivo de conservar las columnas fijas indicadas y crear una fila nueva con cada registro de fecha. Como salida se retorna la ruta de un archivo temporal con la información procesada al contexto **XCOM** de airflow para que se pueda accesar desde otra función.
~~~python
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
~~~~
* **Python operator** para carga de información a la base de datos. Se lee el archivo temporal y se sube a la BD, se crea una variable de persistencia hacía la base de datos *MySQL* utilizando la función *MySQLHook* de *airflow*.
~~~~python
def insert_process(**kwargs):
    ti = kwargs['ti']
    source_csv = ti.xcom_pull(task_ids='transform_process')
    source_df = pd.read_csv(source_csv)
    db_connection = MySqlHook('db_proyecto').get_sqlalchemy_engine()
    
    with db_connection.begin() as transaction:
        transaction.execute("DELETE FROM proyecto_pd.covid19_confirmed WHERE 1=1")
        source_df.to_sql("covid19_confirmed", con=transaction,
                         schema="proyecto_pd", if_exists="append", index=False)
    os.remove(source_csv)

insert_process = PythonOperator(dag=dag,
                                task_id="insert_process",
                                provide_context=True,
                                python_callable=insert_process
                                )
~~~~
* Finalmente se define el flujo que seguira el proceso.
~~~~python
file_sensor_task >> transform_process >> insert_process
~~~~
#### Creación de dashboard
Una vez cargada la información en la base de datos se procedió a crear un dashboard interactivo utilizando la librearía de *streamlit* como base, *pandas* para procesamiento de datos y *plotly* para creación de gráficos.  
Se definieron dos gráficos principales, el primero permite seleccionar el conjunto de datos a visualizar *deaths*, *confirmed* y *recovered*. Luego utilizando pandas se obtienen la fecha mínima y máxima del conjunto de datos seleccionados, a partir de esa información se genera un *slider* de fechas que al seleccionar una en específico se muestra un mapa del mundo utilizando una proyección naturan en el cual se observa la información en forma de burbuja con los datos acumulados a esa fecha. El resultado fue el siguiente:
![img2](/proyecto_final_pd/img/confirmed_map_bubble.png)
El segundo es un gráfico consolidado por país, utilizando *pandas* se realiza una unión de la información de las distintas bases de datos y se genera un acumulado por cada país en una fecha específica utilizando las funciones *groupby* y *sum*. A partir de dicha información se genera un gráfico de líneas con cada uno de los contadores y se le agregan filtros para actualizar los ejes a un rango de fechas específico, por ejemplo, los últimos 6 o 4 meses. El resultado fue el siguiente:
![img2](/proyecto_final_pd/img/line-chart.png)
