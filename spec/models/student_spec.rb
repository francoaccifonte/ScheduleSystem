# frozen_string_literal: true

# == Schema Information
#
# Table name: students
#
#  id         :bigint           not null, primary key
#  first_name :string
#  last_name  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Student, type: :model do
  context 'when subscribing twice to the same course' do
    let(:student) { create(:student) }
    let(:course) { create(:course) }

    it 'should not create a new course_student' do
      student.courses << course
      expect { student.courses << course }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
