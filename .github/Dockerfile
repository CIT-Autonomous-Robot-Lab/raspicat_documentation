FROM python:3.9-alpine

WORKDIR /app

RUN pip install mkdocs mkdocs-material pymdown-extensions

EXPOSE 8000

ENTRYPOINT ["mkdocs", "serve", "--dev-addr=0.0.0.0:8000"]
