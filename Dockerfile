FROM python:2.7

RUN pip install flask==0.12.2

ADD app /app
CMD ["/usr/local/bin/python", "/app/webapp.py"]
