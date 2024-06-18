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
      let(:task_name) { Faker::Lorem.word }
      let!(:matching_task) { create(:task, name: task_name, user:) }
      let(:result) { described_class.search_by_name(task_name) }

      it 'includes tasks matching the name query' do
        expect(result).to include(matching_task)
      end
    end

    context 'when filtering by status' do
      let(:status) { %w[pending in_progress completed].sample }
      let!(:selected_status) { create(:task, user:, status:) }
      let(:result) { described_class.filter_by_status(status) }

      it 'includes tasks with the correct status' do
        expect(result).to include(selected_status)
      end
    end
  end
end
