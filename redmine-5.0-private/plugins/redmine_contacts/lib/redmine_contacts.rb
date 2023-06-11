# This file is a part of Redmine CRM (redmine_contacts) plugin,
# customer relationship management plugin for Redmine
#
# Copyright (C) 2010-2023 RedmineUP
# http://www.redmineup.com/
#
# redmine_contacts is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# redmine_contacts is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with redmine_contacts.  If not, see <http://www.gnu.org/licenses/>.

module RedmineContacts
  def self.companies_select
    RedmineContacts.settings['select_companies_to_deal'].to_i > 0
  end

  def self.settings()
    return {} if Setting[:plugin_redmine_contacts].blank?
    if Setting[:plugin_redmine_contacts].respond_to?(:to_unsafe_hash)
      Setting[:plugin_redmine_contacts] = Setting[:plugin_redmine_contacts].to_unsafe_hash
    end
    Setting[:plugin_redmine_contacts].with_indifferent_access
  end

  def self.default_list_style
    return (%w(list list_excerpt list_cards) && [RedmineContacts.settings["default_list_style"]]).first || "list_excerpt"
    return 'list_excerpt'
  end

  def self.products_plugin_installed?
    @@products_plugin_installed ||= (Redmine::Plugin.installed?(:redmine_products) && Redmine::Plugin.find(:redmine_products).version >= '2.0.2')
  end

  def self.unstable_branch?
    Redmine::VERSION::BRANCH != 'stable'
  end
end

REDMINE_CONTACTS_REQUIRED_FILES = [
  'csv_importable',
  'redmine_contacts/patches/compatibility/application_helper_patch',
  'redmine_contacts/helpers/contacts_helper',
  'redmine_contacts/helpers/crm_calendar_helper',
  # Plugins
  'redmine_contacts/utils/thumbnail',
  'redmine_contacts/utils/check_mail',
  'redmine_contacts/utils/date_utils',
  'redmine_contacts/utils/csv_utils',
  # Hooks
  'redmine_contacts/hooks/views_projects_hook',
  'redmine_contacts/hooks/views_layouts_hook',

  # Patches
  'redmine_contacts/patches/compatibility/active_record_sanitization_patch.rb',
  'redmine_contacts/patches/compatibility/user_patch.rb',
  'redmine_contacts/patches/compatibility_patch',
  'redmine_contacts/patches/issue_patch',
  'redmine_contacts/patches/project_patch',
  'redmine_contacts/patches/notifiable_patch',
  'redmine_contacts/patches/attachments_controller_patch',
  'redmine_contacts/patches/auto_completes_controller_patch',
  'redmine_contacts/patches/query_patch',
  'redmine_contacts/patches/queries_helper_patch',
  'redmine_contacts/patches/timelog_helper_patch',
  'redmine_contacts/patches/projects_helper_patch',
  'redmine_contacts/wiki_macros/contacts_wiki_macros',
  'redmine_contacts/patches/setting_patch',
  'redmine_contacts/field_format/contact_format',
  'redmine_contacts/field_format/company_format',
  'redmine_contacts/field_format/deal_format',
  'redmine_contacts/patches/users_controller_patch',
  'redmine_contacts/patches/custom_fields_helper_patch',
  'redmine_contacts/patches/time_report_patch',
  'redmine_contacts/patches/issues_controller_patch',
  'redmine_contacts/hooks/views_users_hook',
  'redmine_contacts/hooks/views_custom_fields_hook',
  'redmine_contacts/hooks/controllers_time_entry_reports_hook'
]

if Redmine::VERSION.to_s >= '3.4'
  REDMINE_CONTACTS_REQUIRED_FILES << 'redmine_contacts/patches/query_filter_patch'
  REDMINE_CONTACTS_REQUIRED_FILES << 'redmine_contacts/patches/issues_helper_patch'
end

REDMINE_CONTACTS_REQUIRED_FILES << 'redmine_contacts/liquid/liquid' if Object.const_defined?("Liquid") rescue false

base_url = File.dirname(__FILE__)
REDMINE_CONTACTS_REQUIRED_FILES.each { |file| require(base_url + '/' + file) }
