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

require File.expand_path('../../test_helper', __FILE__)

class ContactsMailHandlerTest < ActiveSupport::TestCase
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

  fixtures :email_addresses if ActiveRecord::VERSION::MAJOR >= 4

  RedmineContacts::TestCase.create_fixtures(Redmine::Plugin.find(:redmine_contacts).directory + '/test/fixtures/', [:contacts,
                                                                                                                    :contacts_projects,
                                                                                                                    :deals,
                                                                                                                    :notes,
                                                                                                                    :tags,
                                                                                                                    :taggings,
                                                                                                                    :queries])

  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures/contacts_mail_handler'

  def setup
    RedmineContacts::TestCase.prepare

    ActionMailer::Base.deliveries.clear
    Setting.notified_events = Redmine::Notifiable.all.collect(&:name)
  end

  test 'Should add contact note from to' do
    # This email contains: 'Project: onlinestore'
    note = submit_email('new_note.eml').first
    assert_instance_of ContactNote, note
    assert !note.new_record?
    note.reload
    assert_equal Contact, note.source.class
    assert_equal 'New note from email', note.subject
    assert_equal User.find_by_login('admin'), note.author
    assert_equal Contact.find(1).id, note.source_id
  end

  test 'Should add contact note from ID in to' do
    # This email contains: 'Project: onlinestore'
    note = submit_email('new_note_by_id.eml').first
    assert_instance_of ContactNote, note
    assert !note.new_record?
    note.reload
    assert_equal Contact, note.source.class
    assert_equal 'New note from email', note.subject
    assert_equal User.find_by_login('admin'), note.author
    assert_equal Contact.find(1).id, note.source_id
  end

  test 'Should add contact note from ID in cc' do
    # This email contains: 'Project: onlinestore'
    note = submit_email('new_note_with_cc.eml').first
    assert_instance_of ContactNote, note
    assert !note.new_record?
    note.reload
    assert_equal Contact, note.source.class
    assert_equal 'New note from email by id in cc', note.subject
    assert_equal User.find_by_login('admin'), note.author
    assert_equal Contact.find(1).id, note.source_id
  end

  test 'Should add deal note from ID in to' do
    # This email contains: 'Project: onlinestore'
    note = submit_email('new_deal_note_by_id.eml').first
    assert_instance_of DealNote, note
    assert !note.new_record?
    note.reload
    assert_equal Deal, note.source.class
    assert_equal 'New note from email', note.subject
    assert_equal User.find_by_login('admin'), note.author
    assert_equal Deal.find(1).id, note.source_id
  end

  test 'Should add contact note from forwarded' do
    note = submit_email('fwd_new_note_plain.eml').first
    assert_instance_of ContactNote, note
    assert !note.new_record?
    note.reload
    assert_equal Contact, note.source.class
    assert_equal 'New note from forwarded email', note.subject
    assert_match 'From: "Marat Aminov" marat@mail.ru', note.content
    assert_equal User.find_by_login('admin'), note.author
    assert_equal Contact.find(2).id, note.source_id
  end

  test 'Should add contact note from forwarded html' do
    note = submit_email('fwd_new_note_html.eml').first
    assert_instance_of ContactNote, note
    assert !note.new_record?
    note.reload
    assert_equal Contact, note.source.class
    assert_equal 'New note from forwarded html email', note.subject
    assert_match 'From: Marat Aminov <marat@mail.com>', note.content
    assert_equal User.find_by_login('admin'), note.author
    assert_equal Contact.find(2).id, note.source_id
  end

  test 'Should not add contact note from deny user to' do
    assert !submit_email('new_deny_note.eml')
  end

  private

  def submit_email(filename, options = {})
    raw = IO.read(File.join(FIXTURES_PATH, filename))
    ContactsMailHandler.receive(raw, options)
  end
end
