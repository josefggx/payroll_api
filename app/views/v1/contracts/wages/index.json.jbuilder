json.data @wages do |wage|
  json.partial! 'shared/wage', wage: wage
end
