FROM ruby:2.5.1
ENV LANG C.UTF-8
ENV APP /app
ENV BUNDLE_PATH /vendor/bundle
RUN mkdir $APP
WORKDIR $APP

RUN apt-get update -qq \
    && apt-get install -y \
        build-essential \
        bash \
        mysql-client \
        vim \
        imagemagick \
    &&rm -rf /var/lib/apt/lists/* /var/cache/apt/*

COPY ./Gemfile $APP/Gemfile

RUN touch Gemfile.lock && bundle install --path=$APP/vendor/bundle --jobs 4
COPY . $APP