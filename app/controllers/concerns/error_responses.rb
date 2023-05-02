module ErrorResponses
  extend ActiveSupport::Concern

  included do
    rescue_from JWT::VerificationError, with: :render_error_not_authenticated
    rescue_from JWT::DecodeError, with: :render_error_not_authenticated
    rescue_from ActiveRecord::RecordNotFound, with: :render_error_not_found
  end

  def render_error_wrong_credentials
    render json: { error: { message: 'Correo electrónico o contraseña incorrectos', code: '400',
                            object: 'Authentication' } }, status: :unauthorized
  end

  def render_error_not_authenticated
    render json: { error: { message: 'No estás autenticado', code: '401', object: 'Authentication' } },
           status: :unauthorized
  end

  def render_error_not_authorized(object)
    render json: { error: { message: 'No estás autorizado para realizar esta acción', code: '403',
                            object: object.capitalize } }, status: :forbidden
  end

  def render_error_not_found(object)
    render json: { error: { message: 'Registro no encontrado', code: '404', object: object.model } },
           status: :not_found
  end

  def render_errors(*errors)
    errors = build_errors_array(errors)

    render json: { error: errors }, status: :unprocessable_entity
  end

  private

  def build_errors_array(errors)
    error_objects = []

    errors.compact.each do |error|
      error_objects.concat(generate_error_objects(error))
    end

    error_objects
  end

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
    object = errors.instance_variable_get('@base').class

    return nil unless object.column_names.include?(attribute.to_s) || attribute == :password

    message = "#{object.human_attribute_name(attribute)} #{errors.generate_message(attribute, error[:error],
                                                                                   count: error[:count])}"
    code = ERROR_CODES.dig(object.name&.underscore, attribute.to_s, error[:error].to_s)

    { message:, object:, code: }.compact
  end
end
