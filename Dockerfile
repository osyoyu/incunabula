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
  curl -fsSL -o /tmp/ruby/ruby-3.3.3.tar.gz https://cache.ruby-lang.org/pub/ruby/3.3/ruby-3.3.3.tar.gz \
  && echo "b71971b141ee2325d99046a02291940fcca9830c /tmp/ruby/ruby-3.3.3.tar.gz" | sha1sum --check \
  && tar -xzf ruby-3.3.3.tar.gz \
  && cd /tmp/ruby/ruby-3.3.3 \
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
