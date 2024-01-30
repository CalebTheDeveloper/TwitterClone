json.array! @tweets do |tweet|
  json.id tweet.id
  json.text tweet.text
  json.created_at tweet.created_at
  json.user do
    json.name tweet.user.name
    json.username tweet.user.username
  end
end
