FROM rails:latest
MAINTAINER gigadoc2@revreso.de

# create klausurtool user
RUN adduser --disabled-login --gecos "Klausurtool ruby-on-rails" klausurtool

WORKDIR /home/klausurtool/klausurtool-ror/

# copy gemfiles and run bundler
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

# copy everything else (do this after installing deps, our code changes more often than deps)
COPY . .

# TODO: ony chown what really needs to be writable
RUN chown -hR klausurtool .

USER klausurtool

# create empty development database
RUN bin/rake db:schema:load
# precompile assets for production
RUN RAILS_ENV=production bin/rake assets:precompile

# start rails, listening on port 3000
ENV __LISTEN_ADDR="0.0.0.0"
EXPOSE 3000
CMD rails server --binding $__LISTEN_ADDR
