FROM harbor.k8s.temple.edu/library/ruby:3.3-alpine

WORKDIR /app

COPY . .

USER root

ARG RAILS_MASTER_KEY=$MANIFOLD_MASTER_KEY \
  RAILS_ENV=production \
  K8=yes

RUN apk add -U --no-cache \
      bash=5.2.26-r0 \
      imagemagick=7.1.1.32-r2 \
      imagemagick-jpeg=7.1.1.32-r2 \
      imagemagick-libs=7.1.1.32-r2 \
      libjpeg-turbo=3.0.3-r0 \
      musl=1.2.5-r0 \
      libc6-compat=1.1.0-r4 \
      libxslt=1.1.39-r1 \
      postgresql16-client=16.3-r0 \
      shared-mime-info=2.4-r0 \
      tzdata=2024b-r0 && \
    apk add -U --no-cache --virtual build-dependencies \
      git=2.45.2-r0 \
      build-base=0.5-r3 \
      libjpeg=9e-r1 \
      jpeg-dev=9e-r1 \
      libjpeg-turbo-dev=3.0.3-r0 \
      libxslt-dev=1.1.39-r1 \
      postgresql16-dev=16.3-r0 \
      nodejs=20.15.1-r0 \
      yarn=1.22.22-r0 && \
    if [ "${RAILS_ENV}" = "production" ]; then bundle config set --local without "development test"; fi && \
    bundle install --jobs=8 && \
    find "$GEM_HOME" -name Gemfile.lock -exec rm "{}" \; && \
    find "$GEM_HOME" -name yarn.lock -exec rm "{}" \; && \
    bundle exec rails assets:precompile && \
    if [ "${RAILS_ENV}" = "production" ]; then rm -rf node_modules; fi && \
    if [ "${RAILS_ENV}" = "production" ]; then rm -rf tmp/*; fi && \
    if [ "${RAILS_ENV}" = "production" ]; then apk del build-dependencies; fi && \
    rm -rf /var/cache/apk/ && \
    rm -rf /usr/local/share/.cache/yarn && \
    chown nobody -R /app/tmp && \
    chown nobody -R /app/log

USER nobody

ENTRYPOINT [".docker/app/entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
