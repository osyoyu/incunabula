FROM ubuntu:22.04

ENV TZ=Asia/Tokyo

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

RUN mkdir /tmp/ruby
WORKDIR /tmp/ruby
RUN \
  curl -fsSL -o /tmp/ruby/ruby-3.3.2.tar.gz https://cache.ruby-lang.org/pub/ruby/3.3/ruby-3.3.2.tar.gz \
  && echo "b49719ef383c581008c1fd3b68690f874f78557b /tmp/ruby/ruby-3.3.2.tar.gz" | sha1sum --check \
  && tar -xzf ruby-3.3.2.tar.gz \
  && cd /tmp/ruby/ruby-3.3.2 \
  && ./configure \
       --enable-shared \
       --enable-yjit=stats \
       --disable-install-doc \
  && make -j$(nproc) \
  && make install
RUN ruby -e 'puts RUBY_VERSION'


RUN apt-get update && apt-get install -y \
  git \
  libimage-exiftool-perl \
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
