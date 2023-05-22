FROM redmine:4.0.9-alpine

WORKDIR /usr/src/redmine

COPY /patches/app_views_layouts_base.html.erb /usr/src/redmine/app/views/layouts/base.html.erb
COPY /patches/lib_redmine.rb /usr/src/redmine/lib/redmine.rb

COPY plugins /usr/src/redmine/plugins

RUN bundle install --without development test --jobs=8

# HEALTHCHECK CMD wget --no-verbose --tries=1 --spider http://localhost:3000 || exit