Redmine::Plugin.register :computed_custom_field do
  name 'Computed custom field'
  author 'Yakov Annikov'
  url 'https://github.com/annikoff/redmine_plugin_computed_custom_field'
  description ''
  version '1.0.7'
  settings default: {}
end

if Rails::VERSION::MAJOR >= 5
  version = "#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}".to_f
  PLUGIN_MIGRATION_CLASS = ActiveRecord::Migration[version]
  preparation_class = ActiveSupport::Reloader
else
  PLUGIN_MIGRATION_CLASS = ActiveRecord::Migration
  preparation_class = ActionDispatch::Callbacks
end

$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/lib"
require 'computed_custom_field'
#require 'computed_custom_field/custom_field_patch'
require 'computed_custom_field/custom_fields_helper_patch'
#require 'computed_custom_field/model_patch'
#require 'computed_custom_field/issue_patch'
require 'computed_custom_field/hooks'

RedmineApp::Application.configure do
  config.after_initialize do
    ComputedCustomField.patch_models
  end
end
