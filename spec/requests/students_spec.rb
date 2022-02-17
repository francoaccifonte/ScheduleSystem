# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Students', type: :request do
  let!(:student) { create(:student) }
  let!(:registered_courses) { create_list(:course, 2) }
  let!(:course_students) do
    registered_courses.map do |course|
      CourseStudent.create!(course:, student:)
    end
  end

  let!(:students) { create_list(:student, 3) }
  let!(:other_student) { students.sample }
  let!(:unrelated_courses) { create_list(:course, 2) }
  let!(:unrelated_course_students) do
    unrelated_courses.map do |course|
      CourseStudent.create!(course:, student: other_student)
    end
  end

  describe 'GET /index' do
    subject { get students_path }

    before { subject }

    it 'has a 200 status code' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns the correct list of students' do
      expected_response = Student.all.order(id: :asc).map do |course|
        course.attributes.slice('id', 'first_name', 'last_name').symbolize_keys
      end
      response_body.fetch(:students).each_with_index do |student, index|
        expect(student > expected_response[index]).to be true
      end
    end
  end

  describe 'POST /create' do
    let(:student_params) { attributes_for(:student) }

    subject { post students_path, params: { student: student_params } }

    it 'has a 201 status code' do
      subject
      expect(response).to have_http_status(:created)
    end

    it 'creates a new student' do
      expect { subject }.to change { Student.count }.by(1)

      created_student = Student.find(response_body.dig(:student, :id))
      expect(created_student).to be_present
      expect(created_student.attributes.symbolize_keys > student_params).to be_truthy
    end
  end

  describe 'DELETE /destroy' do
    subject { delete student_path(student) }

    it 'has a 204 status code' do
      subject
      expect(response).to have_http_status(:no_content)
    end

    it 'deletes the correct student' do
      expect { subject }.to change { Student.count }.by(-1)
      expect { Student.find(student.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Student.find(other_student.id) }.not_to raise_error
    end

    it 'deletes the correct associations' do
      expect { subject }.to change { CourseStudent.count }.by(-course_students.count)
      expect { CourseStudent.find_by!(student:) }.to raise_error(ActiveRecord::RecordNotFound)
      expect(CourseStudent.where(student: other_student).count).to eq(unrelated_course_students.count)
    end
  end

  describe 'PATCH PUT /update' do
    let(:student_params) { attributes_for(:student) }

    subject { patch student_path(student), params: { student: student_params } }

    it 'has a 200 status code' do
      subject
      expect(response).to have_http_status(:ok)
    end

    it 'updates the correct student' do
      expect { subject }.to change { student.reload.attributes.symbolize_keys > student_params }.from(false).to(true)
    end

    context 'when subscribing to a new course' do
      let!(:params) { student_params.merge(course_ids: [registered_courses.first.id]) }
      subject do
        put student_path(student),
            params: { student: params }
      end

      it 'has a 200 status code' do
        subject
        expect(response).to have_http_status(:ok)
      end

      it 'updates the correct student' do
        expect { subject }.to change { student.reload.attributes.symbolize_keys > student_params }.from(false).to(true)
      end
    end
  end
end
