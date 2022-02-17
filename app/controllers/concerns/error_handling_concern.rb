# frozen_string_literal: true

module ErrorHandlingConcern
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActionController::ParameterMissing, with: :parameter_missing
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  end

  def record_not_found
    render json: { error: 'Record not found' }, status: :not_found
  end

  def parameter_missing(error)
    render json: { error: "Missing parameter: #{error.param}" }, status: :bad_request
  end

  def record_invalid(error)
    render json: { error: error.record.errors }, status: :unprocessable_entity
  end
end
