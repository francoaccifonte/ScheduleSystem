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
FactoryBot.define do
  factory :course do
    code { Faker::Lorem.unique.word }
    description { Faker::Lorem.unique.paragraph }
    title { Faker::Lorem.unique.sentence }
  end
end
