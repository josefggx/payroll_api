json.data @companies do |company|
  json.partial! 'company', company: company
end
