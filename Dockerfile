FROM ubuntu:22.04

ENV TZ=Asia/Tokyo

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
  autoconf \
  cargo \
  curl \
  gcc \
  libffi-dev \
  libssh-dev \
  libyaml-dev \
  make \
  rustc \
  zlib1g-dev

RUN mkdir /tmp/ruby
WORKDIR /tmp/ruby
RUN \
  curl -fsSL -o /tmp/ruby/ruby-3.4.2.tar.gz https://cache.ruby-lang.org/pub/ruby/3.4/ruby-3.4.2.tar.gz \
  && echo "1537911b4a47940f11c309898e04187344a43167 /tmp/ruby/ruby-3.4.2.tar.gz" | sha1sum --check \
  && tar -xzf ruby-3.4.2.tar.gz \
  && cd /tmp/ruby/ruby-3.4.2 \
  && ./configure \
       --enable-shared \
       --with-ext=openssl,psych,+ \
       --enable-yjit=stats \
       --disable-install-doc \
  && make -j$(nproc) \
  && make install \
  && rm -rf /tmp/ruby \
  && rm -rf /root/.cargo
RUN ruby -e 'puts RUBY_VERSION'


RUN apt-get update && apt-get install -y \
  git \
  libimage-exiftool-perl \
  libjemalloc2 \
  libpq-dev \
  patch \
  pkg-config \
  postgresql-client \
  xz-utils \
  tzdata

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock /app/
RUN bundle install -j$(nproc)

RUN mkdir -p /app/tmp/pids && mkdir -p /app/tmp/cache

COPY . /app
