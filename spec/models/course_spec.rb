# frozen_string_literal: true

# == Schema Information
#
# Table name: courses
#
#  id          :bigint           not null, primary key
#  code        :string
#  description :text
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Course, type: :model do
  context 'when subscribing twice to the same course' do
    let(:student) { create(:student) }
    let(:course) { create(:course) }

    it 'should not create a new course_student' do
      course.students << student
      expect { course.students << student }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
