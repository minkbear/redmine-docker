require File.expand_path('../lib/google_analytics_hooks', __FILE__)

Redmine::Plugin.register :google_analytics_plugin do
  name 'Google Analytics plugin'
  author 'Eric Davis, Raphael Kallensee, Tobias Fischer'
  description 'Redmine plugin to insert a Google Analytics (or e.g. Piwik) tracking code into Redmine based on user roles.'
  url 'https://github.com/paginagmbh/redmine-google-analytics-plugin'
  version '1.0.1'

  requires_redmine :version_or_higher => '2.0.0'

  settings :default => {
    'google_analytics_code' => '',
    'google_analytics_log_anonymous' => true,
    'google_analytics_log_authenticated' => true,
    'google_analytics_log_administrator' => true
  }, :partial => 'google_analytics_settings'

end
