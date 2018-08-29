FROM ruby:2.5.1
MAINTAINER Steven Ng <steven.ng@temple.edu>
RUN \
      wget -qO- https://deb.nodesource.com/setup_9.x | bash - && \
      wget -qO- https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
      echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
      apt-get update -qq && \
      apt-get install -y --force-yes --no-install-recommends \
      nodejs build-essential libpq-dev
ENV GOOGLE_OAUTH_CLIENT_ID="401908166360-95amck0v2qa63frgp2msla3q0q4iv1t3.apps.googleusercontent.com"
ENV GOOGLE_OAUTH_SECRET="7vre-9qtgGQuqQJ7Q-u-9x1p"
RUN mkdir /fortytude
WORKDIR /fortytude
ADD Gemfile .
ADD Gemfile.lock .
RUN bundle install
COPY . .
