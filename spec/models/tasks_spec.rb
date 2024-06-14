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

  context 'when validations' do
    it 'is not valid without a name' do
      task = described_class.new(valid_attributes.except(:name))
      expect(task).not_to be_valid
    end

    it 'is not valid with a name longer than 255 characters' do
      task = described_class.new(valid_attributes.merge(name: Faker::Lorem.characters(number: 256)))
      expect(task).not_to be_valid
    end

    it 'is not valid without content' do
      task = described_class.new(valid_attributes.except(:content))
      expect(task).not_to be_valid
    end

    it 'is not valid with content longer than 1000 characters' do
      task = described_class.new(valid_attributes.merge(content: Faker::Lorem.characters(number: 1001)))
      expect(task).not_to be_valid
    end

    it 'is not valid without a start_time' do
      task = described_class.new(valid_attributes.except(:start_time))
      expect(task).not_to be_valid
    end

    it 'is not valid without an end_time' do
      task = described_class.new(valid_attributes.except(:end_time))
      expect(task).not_to be_valid
    end

    it 'is not valid if end_time is not greater than start_time' do
      task = described_class.new(valid_attributes.merge(end_time: valid_attributes[:start_time] - 1.hour))
      expect(task).not_to be_valid
    end

    it 'is not valid without a priority' do
      task = described_class.new(valid_attributes.except(:priority))
      expect(task).not_to be_valid
    end

    it 'is not valid without a status' do
      task = described_class.new(valid_attributes.except(:status))
      expect(task).not_to be_valid
    end

    it 'is not valid with a label longer than 30 characters' do
      task = described_class.new(valid_attributes.merge(label: Faker::Lorem.characters(number: 31)))
      expect(task).not_to be_valid
    end
  end

  context 'when associations' do
    it 'belongs to a user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end
  end
end
