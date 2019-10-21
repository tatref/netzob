FROM debian:buster

WORKDIR /root

RUN apt update && \
  apt upgrade && \
  apt install -y python3 python3-setuptools python3-dev python-virtualenv build-essential git libpcap-dev && \
  useradd --create-home netzob

WORKDIR /home/netzob
USER netzob

COPY --chown=netzob:netzob requirements_0.txt requirements.txt /home/netzob/

RUN virtualenv -p python3 ~/virtualenv && \
  . ~/virtualenv/bin/activate && \
  pip install -r requirements_0.txt && \
  pip install -r requirements.txt && \
  echo '. ~/virtualenv/bin/activate' >> ~/.bashrc

COPY --chown=netzob:netzob . netzob/

RUN . ~/virtualenv/bin/activate && \
  cd netzob/netzob && \
  python setup.py build && \
  python setup.py develop && \
  python setup.py install && \
  mkdir -p ~/.ipython/profile_default/startup/ && \
  echo "from netzob.all import *" > ~/.ipython/profile_default/startup/00_netzob.py

CMD ~/virtualenv/bin/ipython
