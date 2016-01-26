FROM rails:latest
MAINTAINER gigadoc2@revreso.de

# create klausurtool user
RUN adduser --disabled-login --gecos "Klausurtool ruby-on-rails" klausurtool

WORKDIR /home/klausurtool/klausurtool-ror/

# copy project files
COPY . .

RUN bundle install

# TODO: ony chown what really needs to be writable
RUN chown -hR klausurtool .

USER klausurtool

# create empty development database
RUN bin/rake db:schema:load
# precompile assets
RUN bin/rake assets:precompile

# start rails, listening on port 3000
EXPOSE 3000
CMD ["rails", "server", "--binding", "0.0.0.0"]
