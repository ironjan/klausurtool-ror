# HowTo Docker

## Quick start
You can use the provided *Dockerfile* to test the tool, and start hacking without worrying about dependencies, bind mounting, or your ruby version.

**Warning:** This will run rails with insecure settings, make sure no one but you can access your container! Also, change `changeme`.
For a proper deployment look below.

* Clone the project: `git clone https://github.com/ironjan/klausurtool-ror.git && cd klausurtool-ror`
 * Optionally: switch to the latest tag: ```git checkout $(git describe --tags `git rev-list --tags --max-count=1`)```
* Build the image: `docker build -t klausurtool .`
* Start a MySQL-server: `docker run --name mariadb -e MYSQL_ROOT_PASSWORD=changeme mariadb`
* Create the database: `docker run --rm --link mariadb:mysql -e DATABASE_PW=changeme klausurtool bin/rake db:create` and `docker run --rm --link mariadb:mysql -e DATABASE_PW=changeme klausurtool bin/rake db:schema:load`
* Run the tool: `docker run -ti --link mariadb:mysql klausurtool`
* Access the tool at `http://your_container_ip:3000/` (the ip probably is `172.17.0.3`)

## Configuration and Deployment
The aforementioned *Quick Start* will set you up with an empty database, and rails in development mode.

In order to deploy the tool in production, you might want to change the following things:

### Switch to production mode
* Set `RAILS_ENV` to *production*
 * `docker run […] -e RAILS_ENV=production klausurtool`
* Populate `SECRET_TOKEN` and `SECRET_KEY_BASE`
 * Generate two random strings with at least 30 characters
 * `docker run […] -e SECRET_KEY_BASE=your_random_string -e SECRET_TOKEN=your_other_random_string klausurtool`
* Bind mount your mysql socket
 * `docker run […] -v /run/mysqld/:/var/run/mysqld/ klausurtool`
 * alternatively, set `DATABASE_URL` like described [here](http://guides.rubyonrails.org/configuring.html#configuring-a-database)
* Create the Database 'klausurtool' (or set a different one with `DATABASE_URL`)
* Populate `DATABASE_USER` and `DATABASE_PW`

You might want to look at dockers `--env-file` to simplify this.

### Serving static files
We currently do not have a solution for serving assets statically when using docker, sorry. Instead, rails is set to serve everything, including static files.

## Customize the server ip
Per default rails binds to *0.0.0.0*, as docker only uses ipv4 in its default configuration.

If you want to change this (maybe you are using `--net=host` and want to restrict access), just set `__LISTEN_ADDR` to whatever you need.
