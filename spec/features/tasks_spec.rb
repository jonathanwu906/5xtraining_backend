# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks' do
  subject { page }

  let(:user) { create(:user) }

  describe '#create' do
    before { visit new_task_path }

    context 'when creation is successful' do
      let(:task_name) { Faker::Lorem.sentence }
      let(:task_content) { Faker::Lorem.paragraph }

      before do
        fill_in_task_details(task_name, task_content)
        click_link_or_button 'Create Task'
      end

      it { is_expected.to have_text('成功建立任務！') }
      it { is_expected.to have_text(task_name) }
      it { is_expected.to have_text(task_content) }
    end

    context 'when creation fails' do
      before do
        fill_in 'Name', with: ''
        click_link_or_button 'Create Task'
      end

      it { is_expected.to have_text('任務建立失敗！') }
      it { is_expected.to have_css('.error', text: "can't be blank") }
    end
  end

  describe '#index' do
    let!(:task) { create(:task) }

    before { visit task_path(task) }

    it { is_expected.to have_text(task.name) }
    it { is_expected.to have_text(task.content) }
  end

  describe '#update' do
    let!(:task) { create(:task) }

    before { visit edit_task_path(task) }

    context 'when update is successful' do
      let(:new_task_name) { Faker::Lorem.sentence }
      let(:new_task_content) { Faker::Lorem.paragraph }

      before do
        fill_in 'Name', with: new_task_name
        fill_in 'Content', with: new_task_content
        click_link_or_button 'Update Task'
      end

      it { is_expected.to have_text('成功更新任務！') }
      it { is_expected.to have_text(new_task_name) }
      it { is_expected.to have_text(new_task_content) }
    end

    context 'when update fails' do
      before do
        fill_in 'Name', with: ''
        click_link_or_button 'Update Task'
      end

      it { is_expected.to have_text('任務更新失敗！') }
      it { is_expected.to have_css('.error', text: "can't be blank") }
    end
  end

  describe '#destroy' do
    let!(:task) { create(:task) }

    before do
      visit tasks_path
      within "##{dom_id(task)}" do
        click_link_or_button 'Destroy'
      end
    end

    it { is_expected.to have_text('成功刪除任務！') }
    it { is_expected.to have_no_text(task.name) }
    it { is_expected.to have_no_text(task.content) }
    it { is_expected.to have_no_css("##{dom_id(task)}") }
  end

  def fill_in_task_details(name = Faker::Lorem.sentence, content = Faker::Lorem.paragraph)
    fill_in 'Name', with: name
    fill_in 'Content', with: content
    select '高', from: 'Priority'
    select '未完成', from: 'Status'
    select_date_and_time(Time.zone.now, from: 'task_start_time')
    select_date_and_time(1.hour.from_now, from: 'task_end_time')
  end

  def select_date_and_time(datetime, options = {})
    field = options[:from]
    select datetime.year.to_s, from: "#{field}_1i"
    select datetime.strftime('%B'), from: "#{field}_2i"
    select datetime.day.to_s, from: "#{field}_3i"
    select format('%02d', datetime.hour), from: "#{field}_4i"
    select format('%02d', datetime.min), from: "#{field}_5i"
  end
end
