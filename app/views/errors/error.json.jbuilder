# json.error do
#   error_objects = []
#   object.errors.details.each do |attribute, details|
#     details.each do |error|
#       error_code = error[:code]
#
#       error_objects << {
#         message: object.errors.full_message(attribute, error[:error]),
#         code: error_code,
#         object: object.class.to_s
#       }.compact
#     end
#   end
#
#   json.array! error_objects
# end

# json.error do
#   json.array! object.errors.details.map do |attribute, details|
#     details.map do |error|
#       error_code = error[:code]
#
#       json.message error[:error]
#       json.object object.class.to_s
#       json.code error_code if error_code.present?
#     end
#   end.flatten
# end
#
# json.error do
#   json.array! object.errors.full_messages.each_with_index.zip(object.errors.details.values).map do |(error, i), details|
#     error_code = details&.first&.dig(:code)
#
#     json.message error
#     json.object object.class.to_s
#     json.code error_code if error_code.present?
#   end
# end
