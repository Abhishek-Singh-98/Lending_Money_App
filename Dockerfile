FROM ruby:3.2.2
#ENV is used to set any environment variables in our docker build
ENV INSTALL_PATH /app

RUN mkdir -p $INSTALL_PATH

#WORKDIR defines the working directory for the application else at 
#every place we need to explicitly need to define the path with /app/..
WORKDIR /app

#RUN is used to execute command during the build process is going on.
RUN apt-get update -qq && apt-get install -y \
build-essential \
libpq-dev \
nodejs \
yarn \
postgresql-client \
tzdata

RUN apt-get install -y redis

RUN gem install rails bundler

#copy is used to copy the file from the local build context into the root directory of our image
COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .
#RUN is used to execute some process or task during container getting started
RUN bundle exec rails assets:precompile

#This sets the listening port for the application to run
EXPOSE 3000
#CMD is used to run some commands that needs to be executed after the containers has started.
CMD ["bundle", "exec", "sidekiq"]

CMD ["bash", "-c", "bin/rails db:migrate && rails server -b 0.0.0.0"]
