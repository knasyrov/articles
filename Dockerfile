FROM ruby:3.1.2-slim

ENV LANG=ru_RU.UTF-8 \
    LC_ALL=ru_RU.UTF-8 \
    LANGUAGE=ru_RU.UTF-8

RUN apt-get update -qq && apt-get install -yq --no-install-recommends \
    build-essential \
    git \
    libc6-dev \
    freetds-dev \
    freetds-bin \
    wget \
    telnet \
    libpq-dev \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV APP_NAME /articles
RUN mkdir /$APP_NAME
WORKDIR /$APP_NAME

COPY Gemfile* $APP_NAME/

ENV BUNDLE_PATH=/bundle \
    BUNDLE_JOBS=3 \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"

RUN gem install bundler \
  && bundle install

COPY . /$APP_NAME

EXPOSE 3001
ENTRYPOINT ["./entrypoint.sh"]