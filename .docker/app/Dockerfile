FROM harbor.k8s.temple.edu/library/ruby:3.4-alpine

WORKDIR /app

COPY . .

USER root

ARG RAILS_MASTER_KEY=$MANIFOLD_MASTER_KEY \
  RAILS_ENV=production

RUN apk add -U --no-cache \
      bash=5.3.3-r1 \
      imagemagick=7.1.2.13-r0\
      imagemagick-jpeg=7.1.2.13-r0\
      imagemagick-libs=7.1.2.13-r0\
      libjpeg-turbo=3.1.2-r0 \
      musl=1.2.5-r21 \
      libc6-compat=1.1.0-r4 \
      libxslt=1.1.43-r3 \
      postgresql17-client=17.8-r0 \
      shared-mime-info=2.4-r6 \
      tzdata=2025c-r0 && \
    apk add -U --no-cache --virtual build-dependencies \
      git=2.52.0-r0 \
      build-base=0.5-r3 \
      yaml=0.2.5-r2 \
      yaml-dev=0.2.5-r2 \
      libjpeg=9f-r0 \
      jpeg-dev=9f-r0 \
      libjpeg-turbo-dev=3.1.2-r0 \
      libxslt-dev=1.1.43-r3 \
      postgresql17-dev=17.8-r0 \
      nodejs=24.13.0-r1 \
      yarn=1.22.22-r1 && \
    if [ "${RAILS_ENV}" = "production" ]; then bundle config set --local without "development test"; fi && \
    bundle install --jobs=8 && \
    find "$GEM_HOME" -name Gemfile.lock -exec rm "{}" \; && \
    find "$GEM_HOME" -name yarn.lock -exec rm "{}" \; && \
    SECRET_KEY_BASE=dummy bundle exec rails assets:precompile && \
    if [ "${RAILS_ENV}" = "production" ]; then rm -rf node_modules; fi && \
    if [ "${RAILS_ENV}" = "production" ]; then rm -rf tmp/*; fi && \
    if [ "${RAILS_ENV}" = "production" ]; then apk del build-dependencies; fi && \
    rm -rf /var/cache/apk/ && \
    rm -rf /usr/local/share/.cache/yarn  && \
    mkdir -p /secure-tmp && chmod 700 /secure-tmp && \
    mkdir -p /secure-tmp/log && chmod 700 /secure-tmp/log

USER 65534

ENTRYPOINT [".docker/app/entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
