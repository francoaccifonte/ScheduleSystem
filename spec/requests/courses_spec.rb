# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Courses', type: :request do
  let!(:course) { create(:course) }
  let!(:courses) { create_list(:course, 3) }
  let!(:other_course) { courses.sample }

  let!(:registered_students) { create_list(:student, 2) }
  let!(:course_students) do
    registered_students.map do |student|
      CourseStudent.create!(course:, student:)
    end
  end

  let!(:unrelated_students) { create_list(:student, 3) }
  let!(:unrelated_course_students) do
    unrelated_students.map do |student|
      CourseStudent.create!(course: other_course, student:)
    end
  end

  describe 'GET /index' do
    subject { get courses_path }

    before { subject }

    it 'has a 200 status code' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns the correct list of courses' do
      expected_response = Course.all.order(id: :asc).map do |course|
        course.attributes.slice('id', 'code', 'description', 'title').symbolize_keys
      end
      response_body.fetch(:courses).each_with_index do |course, index|
        expect(course > expected_response[index]).to be true
      end
    end
  end

  describe 'GET /show' do
    subject { get course_path(course) }

    before { subject }

    it 'has a 200 status code' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns the correct course' do
      expected_response = course.attributes.slice('id', 'code', 'description', 'title').symbolize_keys
      expect(response_body.fetch(:course) > expected_response).to be true
    end
  end

  describe 'POST /create' do
    let(:course_params) { attributes_for(:course) }

    subject { post courses_path, params: { course: course_params } }

    it 'has a 201 status code' do
      subject
      expect(response).to have_http_status(:created)
    end

    it 'creates a new course' do
      expect { subject }.to change { Course.count }.by(1)

      created_course = Course.find(response_body.dig(:course, :id))
      expect(created_course).to be_present
      expect(created_course.attributes.symbolize_keys > course_params).to be_truthy
    end
  end

  describe 'DELETE /destroy' do
    subject { delete course_path(course) }

    it 'has a 204 status code' do
      subject
      expect(response).to have_http_status(:no_content)
    end

    it 'deletes the correct course' do
      expect { subject }.to change { Course.count }.by(-1)
      expect { Course.find(course.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Course.find(other_course.id) }.not_to raise_error
    end

    it 'deletes the correct associations' do
      expect { subject }.to change { CourseStudent.count }.by(-course_students.count)
      expect { CourseStudent.find_by!(course:) }.to raise_error(ActiveRecord::RecordNotFound)
      expect(CourseStudent.where(course: other_course).count).to eq(unrelated_course_students.count)
    end
  end

  describe 'PATCH PUT /update' do
    let(:course_params) { attributes_for(:course) }

    subject { patch course_path(course), params: { course: course_params } }

    it 'has a 200 status code' do
      subject
      expect(response).to have_http_status(:ok)
    end

    it 'updates the correct course' do
      expect { subject }.to change { course.reload.attributes.symbolize_keys > course_params }.from(false).to(true)
    end
  end
end
