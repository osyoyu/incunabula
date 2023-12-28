FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
  autoconf \
  cargo \
  curl \
  gcc \
  libssh-dev \
  libyaml-dev \
  make \
  rustc \
  zlib1g-dev

RUN mkdir /ruby-build
WORKDIR /ruby-build
RUN curl -fsSL -o ruby-3.3.0.tar.gz https://cache.ruby-lang.org/pub/ruby/3.3/ruby-3.3.0.tar.gz && tar -xzf ruby-3.3.0.tar.gz
WORKDIR /ruby-build/ruby-3.3.0
RUN ./configure --disable-install-doc --enable-yjit=stats
RUN make -j$(nproc)
RUN make install
RUN ruby -e 'puts RUBY_VERSION'


RUN apt-get update && apt-get install -y \
  git \
  libpq-dev \
  patch \
  pkg-config \
  postgresql-client \
  xz-utils

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock /app/
RUN bundle install -j$(nproc)

COPY . /app
