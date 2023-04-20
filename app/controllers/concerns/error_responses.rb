module ErrorResponses
  extend ActiveSupport::Concern

  included do
    rescue_from JWT::VerificationError, with: :render_error_not_authenticated
    rescue_from JWT::DecodeError, with: :render_error_not_authenticated
    rescue_from ActiveRecord::RecordNotFound, with: :render_error_not_found
  end

  def render_error_not_authenticated
    render json: { error: { message: "You're not authenticated.", code: '0002', object: 'Authentication' } },
           status: :unauthorized
  end

  def render_error_not_authorized(object)
    render json: { error: { message: 'You are not authorized to perform this action', code: '0003',
                            object: object.capitalize } }, status: :unauthorized
  end

  def render_error_not_found(object)
    render json: { error: { message: 'Record not found.', code: '0004', object: object.model } },
           status: :not_found
  end

  def render_errors(errors)
    error_objects = generate_error_objects(errors)

    { error: error_objects }
  end

  private

  def generate_error_objects(errors)
    error_objects = []

    errors.details.each do |attribute, details|
      details.each do |error|
        error_objects << formatted_error_object(errors, attribute, error)
      end
    end

    error_objects.compact
  end

  def formatted_error_object(errors, attribute, error)
    attribute_name = errors.instance_variable_get('@base').class.human_attribute_name(attribute)
    message = "#{attribute_name} #{errors.generate_message(attribute, error[:error], error.except(:error))}"

    {
      message:,
      object: errors.instance_variable_get('@base').class.to_s,
      code: error[:code]
    }.compact
  end
end
