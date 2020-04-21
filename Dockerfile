FROM python:3.7.3-alpine3.10
MAINTAINER david.leonard@flexential.com

WORKDIR /opt

ENV USERNAME "username"
ENV HOSTNAME "10.0.0.1"
ENV PASSWORD "password"
ENV FILENAME "output.json"
ENV LOOP "True"

RUN apk update && apk add --virtual .build-deps curl git gcc musl-dev libffi-dev libxml2-dev libxslt-dev
RUN apk add libressl-dev py3-lxml py3-cryptography

RUN curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
RUN python3 get-pip.py
RUN pip3 --version

RUN pip3 install --upgrade pip setuptools
RUN pip3 install --upgrade git+https://github.com/vmware/vsphere-automation-sdk-python.git
RUN pip3 install --upgrade click

COPY vmconnection.py /opt/vmconnection.py
COPY main.py /opt/main.py

RUN apk del .build-deps

CMD python3 /opt/main.py --hostname $HOSTNAME --username $USERNAME --password $PASSWORD --file $FILENAME --loop