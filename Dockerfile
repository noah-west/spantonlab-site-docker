FROM debian:latest

USER root

RUN    apt-get update \
    && apt-get install -y \
                python3 \
                python3-pip \
                git \
                libmariadb-dev \
                mariadb-client \
                libgl1-mesa-glx \
                libglib2.0-0 \
                libsm6 \
                libxrender1 \
                libxext6 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/app-root/src


WORKDIR /tmp

RUN    git clone https://github.com/noah-west/spantonlab-site.git \
    && mv /tmp/spantonlab-site/flakesite /opt/app-root/src/ \
    && rm -rf /tmp/spantonlab-site

WORKDIR /opt/app-root/src/flakesite

RUN pip3 install -r dependencies.txt

RUN     chown -R 1001:0 /opt/app-root/src \
     && chmod -Rf ug=rwx /opt/app-root/src

USER 1001

CMD ["python3", "manage.py", "collectstatic", "--noinput"]

CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]
