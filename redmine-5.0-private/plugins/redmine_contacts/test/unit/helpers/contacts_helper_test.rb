# encoding: utf-8
#
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

require File.expand_path('../../../test_helper', __FILE__)

class ContactsHelperTest < ActionView::TestCase
  include ApplicationHelper
  include ContactsHelper
  include CustomFieldsHelper
  include Redmine::I18n
  include ERB::Util

  fixtures :projects, :trackers, :issue_statuses, :issues,
           :enumerations, :users, :issue_categories,
           :versions,
           :projects_trackers,
           :member_roles,
           :members,
           :groups_users,
           :enabled_modules

  RedmineContacts::TestCase.create_fixtures(Redmine::Plugin.find(:redmine_contacts).directory + '/test/fixtures/', [:contacts,
                                                                                                                    :contacts_projects,
                                                                                                                    :deals,
                                                                                                                    :notes,
                                                                                                                    :tags,
                                                                                                                    :taggings,
                                                                                                                    :queries])

  def setup
    super
    set_language_if_valid('en')
    User.current = nil
  end

  def test_contacts_to_xls
    User.current = User.find(1)
    xls_result = contacts_to_xls(Contact.all)
    assert_match /First Name/, xls_result
    assert_match /Domoway/, xls_result
  end if RUBY_VERSION < '3'

  def test_contacts_to_xls_with_multivalue_custom_field
    User.current = User.find(1)
    field = ContactCustomField.create!(:name => 'filter', :field_format => 'list',
                                       :is_filter => true, :is_for_all => true,
                                       :possible_values => ['value1', 'value2', 'value3'],
                                       :multiple => true)
    contact = Contact.find(1)
    contact.custom_field_values = { field.id => ['value1', 'value2', 'value3'] }
    contact.save!
    xls_result = contacts_to_xls([contact])
    assert_match /First Name/, xls_result
    assert_match /Domoway/, xls_result
    assert_match /value1, value2, value3/, xls_result
  end if RUBY_VERSION < '3'

  def test_mail_macro
    field = ContactCustomField.create!(:name => 'Custom field', :field_format => 'string')
    contact = Contact.find(1)
    contact.custom_field_values = {field.id => 'test value'}
    contact.save!
    message = "Hello %%NAME%%, %%FULL_NAME%% %%COMPANY%% %%LAST_NAME%% %%MIDDLE_NAME%% %%DATE%% %%Custom field%%"

    result_msg = mail_macro(contact, message)
    assert_equal "Hello Ivan, Ivan Ivanov Domoway Ivanov Ivanovich #{format_date(Date.today)} test value", result_msg
  end
end
