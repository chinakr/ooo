json.array!(@groups) do |group|
  json.extract! group, :code_name, :name, :note
  json.url group_url(group, format: :json)
end
