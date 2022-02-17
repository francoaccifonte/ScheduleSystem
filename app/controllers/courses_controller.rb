# frozen_string_literal: true

class CoursesController < ApplicationController
  before_action :set_course, only: %i[show update destroy]

  def index
    render json: { courses: Course.where(filter_params).map(&:attributes) }
  end

  def show
    render json: { course: @course.attributes.merge!(students: @course.students.map(&:attributes)) }
  end

  def create
    render json: { course: Course.create!(course_params).attributes }, status: :created
  end

  def update
    @course.update!(course_params)
    render json: { course: @course.attributes }
  end

  def destroy
    @course.destroy
    render status: :no_content
  end

  private

  def set_course
    @course = Course.find(params.require(:id))
  end

  def filter_params
    params.permit(:code, :description, :title).to_h
  end

  def course_params
    params.require(:course).permit(:code, :description, :title).to_h
  end
end
