FROM trueagi/hyperon

ENV HOME=/home/user
WORKDIR ${HOME}

RUN git clone https://github.com/trueagi-io/pln-experimental.git
WORKDIR ${HOME}/pln-experimental
