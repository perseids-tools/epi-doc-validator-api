FROM jruby:9.2.11.1

ADD . /app
WORKDIR /app

ENV RACK_ENV=production
ENV BUNDLE_SILENCE_ROOT_WARNING 1

RUN gem install bundler --version 2.1.4
RUN bundle install

CMD bundle exec ruby app.rb
