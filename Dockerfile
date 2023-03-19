FROM ubuntu:22.04 as build

ARG PYTHON_VER=3.10.9

WORKDIR /build

RUN apt-get update && apt-get install -y \
    build-essential \
    libbz2-dev \
    libffi-dev \
    libgdbm-compat-dev \
    libgdbm-dev \
    liblzma-dev \
    libncurses-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    software-properties-common \
    wget \
    zlib1g-dev

# https://www.python.org/ftp/python/
RUN wget --no-check-certificate https://www.python.org/ftp/python/${PYTHON_VER}/Python-${PYTHON_VER}.tar.xz \
    && tar -xf Python-${PYTHON_VER}.tar.xz \
    && cd Python-${PYTHON_VER} \
    && ./configure \
    && make \
    && make install


FROM ubuntu:22.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    tk \
    tzdata

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /usr/local/bin/ /usr/local/bin/
COPY --from=build /usr/local/lib/ /usr/local/lib/

RUN cd /usr/local/bin \
    && ln -s `readlink python3` python \
    && ln -s pip3 pip

ENV TZ Asia/Tokyo
ENV LANG C.UTF-8
