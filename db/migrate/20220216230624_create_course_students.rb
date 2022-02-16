class CreateCourseStudents < ActiveRecord::Migration[7.0]
  def change
    create_join_table :students, :courses
  end
end
