# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks' do
  subject { page }

  before { create(:user) }

  describe '#create' do
    before { visit new_task_path }

    context 'when creation is successful' do
      let(:task_name) { Faker::Lorem.sentence }
      let(:task_content) { Faker::Lorem.paragraph }

      before do
        fill_in_task_details(task_name, task_content)
        click_link_or_button I18n.t('tasks.submit')
      end

      it { is_expected.to have_text(I18n.t('tasks.created_successfully')) }
      it { is_expected.to have_text(task_name) }
      it { is_expected.to have_text(task_content) }
    end

    context 'when creation fails' do
      before do
        fill_in I18n.t('tasks.attributes.name'), with: ''
        click_link_or_button I18n.t('tasks.submit')
      end

      it { is_expected.to have_text(I18n.t('errors.messages.blank')) }
      it { is_expected.to have_css('.error', text: I18n.t('errors.messages.blank')) }
    end
  end

  describe '#index' do
    let!(:task_created_one_day_ago) { create(:task, created_at: 1.day.ago) }
    let!(:task_created_two_days_ago) { create(:task, created_at: 2.days.ago) }
    let!(:task_created_three_days_ago) { create(:task, created_at: 3.days.ago) }

    before { visit tasks_path }

    it 'displays the task created three days ago before the task created two days ago' do
      expect(page.body.index(task_created_three_days_ago.name)).to be < page.body.index(task_created_two_days_ago.name)
    end

    it 'displays the task created two days ago before the task created one day ago' do
      expect(page.body.index(task_created_two_days_ago.name)).to be < page.body.index(task_created_one_day_ago.name)
    end

    it { is_expected.to have_text(task_created_one_day_ago.name) }
    it { is_expected.to have_text(task_created_two_days_ago.name) }
    it { is_expected.to have_text(task_created_three_days_ago.name) }
  end

  describe '#update' do
    let!(:task) { create(:task) }

    before { visit edit_task_path(task) }

    context 'when update is successful' do
      let(:new_task_name) { Faker::Lorem.sentence }
      let(:new_task_content) { Faker::Lorem.paragraph }

      before do
        fill_in I18n.t('tasks.attributes.name'), with: new_task_name
        fill_in I18n.t('tasks.attributes.content'), with: new_task_content
        click_link_or_button I18n.t('tasks.submit')
      end

      it { is_expected.to have_text(I18n.t('tasks.updated_successfully')) }
      it { is_expected.to have_text(new_task_name) }
      it { is_expected.to have_text(new_task_content) }
    end

    context 'when update fails' do
      before do
        fill_in I18n.t('tasks.attributes.name'), with: ''
        click_link_or_button I18n.t('tasks.submit')
      end

      it { is_expected.to have_text(I18n.t('errors.messages.blank')) }
      it { is_expected.to have_css('.error', text: I18n.t('errors.messages.blank')) }
    end
  end

  describe '#destroy' do
    let!(:task) { create(:task) }

    before do
      visit tasks_path
      within "##{dom_id(task)}" do
        click_link_or_button I18n.t('tasks.destroy')
      end
    end

    it { is_expected.to have_text(I18n.t('tasks.destroyed_successfully')) }
    it { is_expected.to have_no_text(task.name) }
    it { is_expected.to have_no_text(task.content) }
    it { is_expected.to have_no_css("##{dom_id(task)}") }
  end

  def fill_in_task_details(name = Faker::Lorem.sentence, content = Faker::Lorem.paragraph)
    fill_in I18n.t('tasks.attributes.name'), with: name
    fill_in I18n.t('tasks.attributes.content'), with: content
    select I18n.t('tasks.attributes.priority.high'), from: I18n.t('tasks.attributes.priority_row')
    select I18n.t('tasks.attributes.status.completed'), from: I18n.t('tasks.attributes.status_row')
    select_date_and_time(Time.zone.now, from: 'task_start_time')
    select_date_and_time(1.hour.from_now, from: 'task_end_time')
  end

  def select_date_and_time(datetime, options = {}) # rubocop:disable Metrics/AbcSize
    field = options[:from]
    select datetime.year.to_s, from: "#{field}_1i"
    select I18n.t('date.month_names')[datetime.month], from: "#{field}_2i"
    select datetime.day.to_s, from: "#{field}_3i"
    select format('%02d', datetime.hour), from: "#{field}_4i"
    select format('%02d', datetime.min), from: "#{field}_5i"
  end
end
