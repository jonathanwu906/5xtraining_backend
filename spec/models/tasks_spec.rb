# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task do
  let(:user) { User.first }
  let(:valid_attributes) do
    {
      name: Faker::Lorem.sentence.truncate(255),
      content: Faker::Lorem.paragraph.truncate(1000),
      start_time: DateTime.now,
      end_time: DateTime.now + 1.hour,
      priority: 'medium',
      status: 'pending',
      label: Faker::Lorem.words,
      user_id: user
    }
  end

  describe 'validations' do
    subject { described_class.new(attributes) }

    let(:attributes) { valid_attributes }

    context 'when there is no name' do
      before { attributes.except!(:name) }

      it { is_expected.not_to be_valid }
    end

    context 'when name is longer than 255 characters' do
      before { attributes.merge!(name: Faker::Lorem.characters(number: 256)) }

      it { is_expected.not_to be_valid }
    end

    context 'when there is no content' do
      before { attributes.except!(:content) }

      it { is_expected.not_to be_valid }
    end

    context 'when content is longer than 1000 characters' do
      before { attributes.merge!(content: Faker::Lorem.characters(number: 1001)) }

      it { is_expected.not_to be_valid }
    end

    context 'when there is no start_time' do
      before { attributes.except!(:start_time) }

      it { is_expected.not_to be_valid }
    end

    context 'when there is no end_time' do
      before { attributes.except!(:end_time) }

      it { is_expected.not_to be_valid }
    end

    context 'when end_time is not greater than start_time' do
      before { attributes.merge!(end_time: attributes[:start_time] - 1.hour) }

      it { is_expected.not_to be_valid }
    end

    context 'when there is no priority' do
      before { attributes.except!(:priority) }

      it { is_expected.not_to be_valid }
    end

    context 'when there is no status' do
      before { attributes.except!(:status) }

      it { is_expected.not_to be_valid }
    end

    context 'when label is longer than 30 characters' do
      before { attributes.merge!(label: Faker::Lorem.characters(number: 31)) }

      it { is_expected.not_to be_valid }
    end
  end

  context 'when associations' do
    it 'belongs to a user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end
  end
end
