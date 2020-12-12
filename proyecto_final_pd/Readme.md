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
![tree](/proyecto_pd/img/project_tree.png)
