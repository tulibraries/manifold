FROM ruby:2.5.1
LABEL Steven Ng <steven.ng@temple.edu>
ARG GOOGLE_OAUTH_CLIENT_ID
ARG GOOGLE_OAUTH_SECRET
RUN \
      wget -qO- https://deb.nodesource.com/setup_9.x | bash - && \
      wget -qO- https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
      echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
      apt-get update -qq && \
      apt-get install -y --force-yes --no-install-recommends \
      nodejs build-essential libpq-dev
ENV GOOGLE_OAUTH_CLIENT_ID=$GOOGLE_OAUTH_CLIENT_ID
ENV GOOGLE_OAUTH_SECRET=$GOOGLE_OAUTH_SECRET
RUN mkdir /manifold
WORKDIR /manifold
ADD Gemfile .
ADD Gemfile.lock .
RUN bundle install
COPY . .
