# frozen_string_literal: true

# == Schema Information
#
# Table name: course_students
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  course_id  :bigint           not null
#  student_id :bigint           not null
#
# Indexes
#
#  index_course_students_on_course_id                 (course_id)
#  index_course_students_on_student_id                (student_id)
#  index_course_students_on_student_id_and_course_id  (student_id,course_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id) ON DELETE => cascade
#  fk_rails_...  (student_id => students.id) ON DELETE => cascade
#
class CourseStudent < ApplicationRecord
  belongs_to :course
  belongs_to :student

  validates :course, :student, presence: true
  validates :course_id, uniqueness: { scope: :student_id }
end
