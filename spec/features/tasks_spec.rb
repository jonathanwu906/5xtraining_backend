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
    let!(:tasks) do
      [
        travel_to(1.day.from_now) { create(:task) },
        travel_to(2.days.from_now) { create(:task) },
        travel_to(3.days.from_now) { create(:task) },
        create(:task, :pending),
        create(:task, :in_progress),
        create(:task, :completed),
        create(:task, :high_priority),
        create(:task, :medium_priority),
        create(:task, :low_priority)
      ]
    end

    before do
      visit tasks_path
    end

    it 'displays all tasks correctly' do
      tasks.each do |task|
        expect(page).to have_css("##{dom_id(task)}", text: task.name)
      end
    end

    context 'when sorting by created time' do
      before do
        select I18n.t('tasks.sort_options.created_at'), from: 'sort_order'
      end

      it 'sorts the first created before the second created' do
        task1_index = page.body.index(tasks[0].name)
        task2_index = page.body.index(tasks[1].name)
        expect(task1_index).to be < task2_index
      end

      it 'sorts the second created before the third created' do
        task2_index = page.body.index(tasks[1].name)
        task3_index = page.body.index(tasks[2].name)
        expect(task2_index).to be < task3_index
      end
    end

    context 'when sorting by end time' do
      before do
        select I18n.t('tasks.sort_options.end_time'), from: 'sort_order'
      end

      it 'sorts the first ending before the second ending' do
        task1_index = page.body.index(tasks[0].name)
        task2_index = page.body.index(tasks[1].name)
        expect(task1_index).to be < task2_index
      end

      it 'sorts the second ending before the third ending' do
        task2_index = page.body.index(tasks[1].name)
        task3_index = page.body.index(tasks[2].name)
        expect(task2_index).to be < task3_index
      end
    end

    context 'when sorting by priority' do
      before do
        select I18n.t('tasks.sort_options.priority'), from: 'sort_order'
      end

      it 'sorts high priority before medium priority' do
        high_priority_index = page.body.index(tasks[6].name)
        medium_priority_index = page.body.index(tasks[7].name)
        expect(high_priority_index).to be < medium_priority_index
      end

      it 'sorts medium priority before low priority' do
        medium_priority_index = page.body.index(tasks[7].name)
        low_priority_index = page.body.index(tasks[8].name)
        expect(medium_priority_index).to be < low_priority_index
      end
    end

    context 'when searching by name' do
      before do
        fill_in I18n.t('tasks.search_by_name'), with: tasks[0].name
      end

      it { is_expected.to have_css("##{dom_id(tasks[0])}", text: tasks[0].name) }
    end

    context 'when filtering by status' do
      before do
        select I18n.t('tasks.attributes.status.in_progress'), from: 'status'
      end

      it { is_expected.to have_css("##{dom_id(tasks[4])}", text: tasks[4].name) }
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
