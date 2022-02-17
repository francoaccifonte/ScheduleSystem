class CreateCourseStudents < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!
  
  def change
    create_table :course_students do |t|
      t.timestamps
    end

    add_reference :course_students, :course, null: false, index: {algorithm: :concurrently}
    add_reference :course_students, :student, null: false, index: {algorithm: :concurrently}
    add_index :course_students, [:student_id, :course_id], unique: true, algorithm: :concurrently
  end
end
