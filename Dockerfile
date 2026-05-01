ARG APP_NAME=hankouki
ARG RUBY_IMAGE=ruby:3.3.6-slim
ARG BUNDLER_VERSION=2.5.22

FROM $RUBY_IMAGE
ARG APP_NAME
ARG BUNDLER_VERSION

ENV RAILS_ENV production
ENV BUNDLE_DEPLOYMENT true
ENV BUNDLE_WITHOUT development:test
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true

RUN mkdir /$APP_NAME
WORKDIR /$APP_NAME

RUN apt-get update -qq \
&& apt-get install -y build-essential \
&& rm -rf /var/lib/apt/lists/*

RUN gem install bundler:$BUNDLER_VERSION

COPY Gemfile /$APP_NAME/Gemfile
COPY Gemfile.lock /$APP_NAME/Gemfile.lock

RUN bundle install

COPY . /$APP_NAME/

RUN SECRET_KEY_BASE="$(bundle exec rake secret)" bin/rails assets:precompile assets:clean \
&& rm -rf /$APP_NAME/tmp/cache

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
