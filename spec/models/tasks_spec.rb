# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task do
  let(:user) { create(:user) }

  describe 'validations' do
    subject { build(:task, user:) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(255) }

    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_length_of(:content).is_at_most(1000) }

    it { is_expected.to validate_presence_of(:start_time) }
    it { is_expected.to validate_presence_of(:end_time) }

    it { is_expected.to validate_comparison_of(:end_time).is_greater_than(:start_time) }

    it { is_expected.to validate_presence_of(:priority) }
    it { is_expected.to validate_presence_of(:status) }

    it { is_expected.to validate_length_of(:label).is_at_most(30) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'scopes and queries' do
    context 'when searching by name' do
      subject(:task) { described_class.where(name: task_name) }

      let(:task_name) { Faker::Lorem.word }
      let!(:matching_task) { create(:task, name: task_name, user:) }
      let!(:non_matching_task) { create(:task, user:) }

      it 'includes tasks matching the name query' do
        expect(task).to include(matching_task)
      end

      it 'excludes tasks not matching the name query' do
        expect(task).not_to include(non_matching_task)
      end
    end

    context 'when filtering by status' do
      subject(:task) { described_class.with_status(selected_status) }

      let(:selected_status) { %w[pending in_progress completed].sample }
      let!(:task_with_selected_status) { create(:task, user:, status: selected_status) }
      let!(:task_with_other_status) do
        create(:task, user:, status: %w[pending in_progress completed].reject do |status|
                                       status == selected_status
                                     end.sample)
      end

      it 'includes tasks with the correct status' do
        expect(task).to include(task_with_selected_status)
      end

      it 'excludes tasks with other statuses' do
        expect(task).not_to include(task_with_other_status)
      end
    end
  end
end
