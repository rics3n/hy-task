FROM ruby:2.7-alpine

ENV LANG C.UTF-8

ENV BUILD_PACKAGES="ruby-dev build-base git make" \
    DEV_PACKAGES="zlib-dev libxml2-dev libxslt-dev tzdata yaml-dev postgresql-dev postgresql-client"

RUN apk update && apk --update add $DEV_PACKAGES

# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.

ENV APP_HOME /app
ENV RAILS_ENV production
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

# Copy the Gemfile as well as the Gemfile.lock and install
# the RubyGems. This is a separate step so the dependencies
# will be cached unless changes to one of those two files
# are made.
COPY Gemfile Gemfile.lock ./
RUN apk --update add --no-cache --virtual .ruby-builddeps \
    $BUILD_PACKAGES && \
    gem install bundler && \
    cd /app ; bundle config set without 'development test' ; bundle install --jobs 20 --retry 5 && \
    apk del .ruby-builddeps

# Copy the main application.
COPY . ./

RUN rm -R /root/.bundle
RUN rm -R /root/.gem

EXPOSE 3000

HEALTHCHECK --interval=10s CMD wget -qO- localhost:3000/api/v1/status

# Start puma
CMD bundle exec puma -C config/puma.rb
