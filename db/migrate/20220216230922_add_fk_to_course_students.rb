class AddFkToCourseStudents < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :courses_students, :students, column: :student_id, on_delete: :cascade, validate: false
    add_foreign_key :courses_students, :courses, column: :course_id, on_delete: :cascade, validate: false
  end
end
