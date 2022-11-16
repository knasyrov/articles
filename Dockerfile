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
    curl \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install nodejs

RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarnkey.gpg >/dev/null
RUN echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install yarn

RUN node -v


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

EXPOSE 3000
ENTRYPOINT ["./entrypoint.sh"]