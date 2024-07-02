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
      subject { described_class.with_name(task_name) }

      let(:task_name) { Faker::Lorem.word }
      let!(:matching_task) { create(:task, name: task_name, user:) }
      let!(:non_matching_task) { create(:task, user:) }

      it { is_expected.to include(matching_task) }
      it { is_expected.not_to include(non_matching_task) }
    end

    context 'when filtering by status' do
      subject { described_class.with_status(selected_status) }

      let(:selected_status) { %w[pending in_progress completed].sample }
      let!(:task_with_selected_status) { create(:task, selected_status, user:) }
      let!(:task_with_other_status) do
        other_statuses = %w[pending in_progress completed] - [selected_status]
        create(:task, other_statuses.sample, user:)
      end

      it { is_expected.to include(task_with_selected_status) }
      it { is_expected.not_to include(task_with_other_status) }
    end
  end
end
