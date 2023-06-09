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

# encoding: utf-8
require File.expand_path('../../test_helper', __FILE__)

class ContactsVcfControllerTest < ActionController::TestCase
  fixtures :projects,
           :users,
           :roles,
           :members,
           :member_roles,
           :issues,
           :issue_statuses,
           :versions,
           :trackers,
           :projects_trackers,
           :issue_categories,
           :enabled_modules,
           :enumerations,
           :attachments,
           :workflows,
           :custom_fields,
           :custom_values,
           :custom_fields_projects,
           :custom_fields_trackers,
           :time_entries,
           :journals,
           :journal_details,
           :queries

  RedmineContacts::TestCase.create_fixtures(Redmine::Plugin.find(:redmine_contacts).directory + '/test/fixtures/', [:contacts,
                                                                                                                    :contacts_projects,
                                                                                                                    :deals,
                                                                                                                    :notes,
                                                                                                                    :tags,
                                                                                                                    :taggings,
                                                                                                                    :queries])

  def setup
    RedmineContacts::TestCase.prepare
  end

  def test_load_from_vcard
    @request.session[:user_id] = 1
    Setting.default_language = 'en'

    compatible_request :post, :load, {
      :project_id => 1,
      :contact_vcf => Rack::Test::UploadedFile.new(redmine_contacts_fixture_files_path + 'kirill_bezrukov.vcf', 'text/x-vcard')
    }

    assert_redirected_to new_project_contact_path(:project_id => 'ecookbook', :contact => {
      'background' => 'Текстовое описание на Русском',
      'birthday' => '1981-05-12',
      'email' => 'kirill@gmail.com',
      'first_name' => 'Кирилл',
      'job_title' => '',
      'address_attributes' => { 'city' => 'Москва', 'postcode' => '', 'region' => '', 'street1' => 'Миклухи Маклая, 9 к 2, корпус Б' },
      'last_name' => 'Безруков',
      'middle_name' => '',
      'phone' => '+1 (234) 234-11-33'
    })
  end

  def test_load_from_vcard_with_umlauts
    @request.session[:user_id] = 1
    Setting.default_language = 'en'

    compatible_request :post, :load, {
      :project_id => 1,
      :contact_vcf => Rack::Test::UploadedFile.new(redmine_contacts_fixture_files_path + 'umlaut_card.vcf', 'text/x-vcard')
    }

    assert_redirected_to new_project_contact_path(:project_id => 'ecookbook', :contact => {
      'address_attributes' => { 'city' => 'Düsseldorf', 'postcode' => '11111 ', 'region' => 'Nordrhein-Westfalen', 'street1' => 'Bleichstraße' },
      'background' => 'Test note',
      'birthday' => '1980-12-01',
      'company' => 'Geschäftszweig',
      'email' => 't.test@test.com',
      'first_name' => 'Test',
      'job_title' => 'Tester',
      'last_name' => 'Testovish',
      'middle_name' => '',
      'phone' => '+11-111-111111-11111'
    })
  end
end
