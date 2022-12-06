FROM ruby:3.1.2-alpine

RUN apk add --update git less build-base chromium chromium-chromedriver gcompat

# Create a root directory for the app within the Docker container
RUN mkdir /app
RUN mkdir -p /app/lib/hyper_kitten_tables
WORKDIR /app

COPY Gemfile Gemfile.lock hyper-kitten-tables.gemspec ./
COPY ./lib/hyper_kitten_tables/version.rb ./lib/hyper_kitten_tables/
RUN bundle install

COPY . .

LABEL maintainer="Josh Klina"

CMD spec/dummy/bin/rails server -b 0.0.0.0
