10.times do
  student = Student.create!(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name)
  course = Course.create!(title: Faker::Lorem.unique.sentence, description: Faker::Lorem.unique.paragraph, code: Faker::Lorem.unique.word)
  CourseStudent.create!(course:, student:)
end
