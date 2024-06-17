# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task do
  let(:user) { User.first }

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
end
