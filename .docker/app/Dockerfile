FROM harbor.k8s.temple.edu/library/ruby:3.1-alpine

WORKDIR /app

COPY . .

USER root

ARG GOOGLE_OAUTH_CLIENT_ID
ARG GOOGLE_OAUTH_SECRET
ARG S3_ACCESS_KEY
ARG S3_BUCKET
ARG S3_REGION
ARG S3_SECRET_ACCESS_KEY
ARG RAILS_MASTER_KEY

RUN apk add -U --no-cache \
      bash=5.2.12-r0 \
      busybox=1.35.0-r29 \
      imagemagick=7.1.0.52-r0 \
      libc6-compat=1.2.3-r4 \
      libxslt=1.1.37-r0 \
      postgresql14-client=14.6-r1 \
      shared-mime-info=2.2-r2 \
      ssl_client=1.35.0-r29 \
      tzdata=2022f-r1 && \
    apk add -U --no-cache --virtual build-dependencies \
      git=2.38.1-r0 \
      build-base=0.5-r3 \
      libxslt-dev=1.1.37-r0 \
      postgresql14-dev=14.6-r1 \
      nodejs=18.12.1-r0 \
      yarn=1.22.19-r0 && \
    if [ "${RAILS_ENV}" = "production" ]; then bundle config set --local without "development test"; fi && \
    gem install bundler:2.3.26 && \
    bundle config build.nokogiri --use-system-libraries && \
    bundle install --jobs=8 && \
    find "$GEM_HOME" -name Gemfile.lock -exec rm "{}" \; && \
    find "$GEM_HOME" -name yarn.lock -exec rm "{}" \; && \
    bundle exec rails assets:precompile && \
    if [ "${RAILS_ENV}" = "production" ]; then rm -rf node_modules; fi && \
    if [ "${RAILS_ENV}" = "production" ]; then rm -rf tmp/*; fi && \
    if [ "${RAILS_ENV}" = "production" ]; then apk del build-dependencies; fi && \
    rm -rf /var/cache/apk/ && \
    chown nobody -R /app/tmp && \
    chown nobody -R /app/log

USER nobody

ENTRYPOINT [".docker/app/entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
