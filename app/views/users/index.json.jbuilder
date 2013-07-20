json.array!(@users) do |user|
  json.extract! user, :username, :hashed_password, :salt, :name, :email, :mobile, :is_staff, :note
  json.url user_url(user, format: :json)
end
