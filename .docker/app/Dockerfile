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
      bash=5.2.15-r5 \
      busybox=1.36.0-r9 \
      imagemagick=7.1.1.10-r0 \
      libc6-compat=1.2.4-r0 \
      libxslt=1.1.38-r0 \
      postgresql14-client=14.8-r0 \
      shared-mime-info=2.2-r5 \
      ssl_client=1.36.0-r9 \
      tzdata=2023c-r1 && \
    apk add -U --no-cache --virtual build-dependencies \
      git=2.40.1-r0 \
      build-base=0.5-r3 \
      libxslt-dev=1.1.38-r0 \
      postgresql14-dev=14.8-r0 \
      nodejs=18.16.0-r1 \
      yarn=1.22.19-r0 && \
    if [ "${RAILS_ENV}" = "production" ]; then bundle config set --local without "development test"; fi && \
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
