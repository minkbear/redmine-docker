FROM redmine:5.0.6-alpine

# ARG AWS_ACCESS_KEY_ID
# ARG AWS_SECRET_ACCESS_KEY
# ARG AWS_BUCKET

WORKDIR /usr/src/redmine

COPY /patches/app_views_layouts_base.html.erb /usr/src/redmine/app/views/layouts/base.html.erb
COPY /patches/lib_redmine_preparation.rb /usr/src/redmine/lib/redmine/preparation.rb

COPY plugins /usr/src/redmine/plugins
COPY config /usr/src/redmine/config

RUN bundle install --without development test --jobs=8

# HEALTHCHECK CMD wget --no-verbose --tries=1 --spider http://localhost:3000 || exit