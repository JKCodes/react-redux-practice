json.user do
  json.(@user, :id, :email)
end
json.token(Auth.create_token(@user.id))