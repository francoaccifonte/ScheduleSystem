# frozen_string_literal: true

class StudentsController < ApplicationController
  before_action :set_student, only: %i[show update destroy]

  def index
    render json: { students: Student.where(filter_params).map(&:attributes) }
  end

  def show
    render json: { student: @student.attributes }
  end

  def create
    render json: { student: Student.create!(student_params).attributes }, status: :created
  end

  def update
    @student.update!(student_params)
    render json: { student: @student.attributes }
  end

  def destroy
    @student.destroy
    render status: :no_content
  end

  private

  def set_student
    @student = Student.find(params.require(:id))
  end

  def filter_params
    params.permit(:first_name, :last_name).to_h
  end

  def student_params
    params.require(:student).permit(:first_name, :last_name, course_ids: []).to_h
  end
end
