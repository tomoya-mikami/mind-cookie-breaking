FROM ruby:2.5.1
RUN curl -SL https://deb.nodesource.com/setup_10.x | bash
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs imagemagick ibmagick++-dev
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp