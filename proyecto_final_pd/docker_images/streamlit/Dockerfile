FROM python:3.7

EXPOSE 8501

WORKDIR /app
COPY requirements.txt ./requirements.txt

RUN pip3 install -r requirements.txt

ENTRYPOINT ["streamlit", "run"]
CMD ["app.py"]
