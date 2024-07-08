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
    context 'when sorting by created time' do
      let!(:task_created_first) { travel_to(1.day.from_now) { create(:task) } }
      let!(:task_created_second) { travel_to(2.days.from_now) { create(:task) } }
      let!(:task_created_third) { travel_to(3.days.from_now) { create(:task) } }

      before do
        visit tasks_path
        select I18n.t('tasks.sort_options.created_at'), from: 'sort_order'
      end

      it 'sorts the first created before the second created' do
        task1_index = page.body.index(task_created_first.name)
        task2_index = page.body.index(task_created_second.name)
        expect(task1_index).to be < task2_index
      end

      it 'sorts the second created before the third created' do
        task2_index = page.body.index(task_created_second.name)
        task3_index = page.body.index(task_created_third.name)
        expect(task2_index).to be < task3_index
      end
    end

    context 'when sorting by end time' do
      let!(:task_ended_first) { travel_to(1.day.from_now) { create(:task) } }
      let!(:task_ended_second) { travel_to(2.days.from_now) { create(:task) } }
      let!(:task_ended_third) { travel_to(3.days.from_now) { create(:task) } }

      before do
        visit tasks_path
        select I18n.t('tasks.sort_options.end_time'), from: 'sort_order'
      end

      it 'sorts the first ended before the second ended' do
        task1_index = page.body.index(task_ended_first.name)
        task2_index = page.body.index(task_ended_second.name)
        expect(task1_index).to be < task2_index
      end

      it 'sorts the second ended before the third ended' do
        task2_index = page.body.index(task_ended_second.name)
        task3_index = page.body.index(task_ended_third.name)
        expect(task2_index).to be < task3_index
      end
    end

    context 'when sorting by priority' do
      let!(:task_high_priority) { create(:task, :high_priority) }
      let!(:task_medium_priority) { create(:task, :medium_priority) }
      let!(:task_low_priority) { create(:task, :low_priority) }

      before do
        visit tasks_path
        select I18n.t('tasks.sort_options.priority'), from: 'sort_order'
      end

      it 'sorts high priority before medium priority' do
        high_priority_index = page.body.index(task_high_priority.name)
        medium_priority_index = page.body.index(task_medium_priority.name)
        expect(high_priority_index).to be < medium_priority_index
      end

      it 'sorts medium priority before low priority' do
        medium_priority_index = page.body.index(task_medium_priority.name)
        low_priority_index = page.body.index(task_low_priority.name)
        expect(medium_priority_index).to be < low_priority_index
      end
    end

    context 'when searching by name' do
      let!(:target_task) { create(:task) }
      let!(:other_task) { create(:task) }

      before do
        visit tasks_path
        fill_in I18n.t('tasks.search_by_name'), with: target_task.name
        click_link_or_button I18n.t('tasks.button.search_by_name')
      end

      it { is_expected.to have_css("##{dom_id(target_task)}", text: target_task.name) }
      it { is_expected.to have_no_css("##{dom_id(other_task)}", text: other_task.name) }
    end

    context 'when filtering by status', :js do
      let!(:task_pending) { create(:task, :pending) }
      let!(:task_in_progress) { create(:task, :in_progress) }
      let!(:task_completed) { create(:task, :completed) }

      before do
        visit tasks_path
        select I18n.t('tasks.attributes.status.in_progress'), from: 'status'
      end

      it { is_expected.to have_css("##{dom_id(task_in_progress)}", text: task_in_progress.name) }
      it { is_expected.to have_no_css("##{dom_id(task_pending)}", text: task_pending.name) }
      it { is_expected.to have_no_css("##{dom_id(task_completed)}", text: task_completed.name) }
    end
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
        click_link_or_button I18n.t('tasks.update')
      end

      it { is_expected.to have_text(I18n.t('tasks.updated_successfully')) }
      it { is_expected.to have_text(new_task_name) }
      it { is_expected.to have_text(new_task_content) }
    end

    context 'when update fails' do
      before do
        fill_in I18n.t('tasks.attributes.name'), with: ''
        click_link_or_button I18n.t('tasks.update')
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
