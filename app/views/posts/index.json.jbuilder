json.array!(@posts) do |post|
  json.extract! post, :id, :title, :storyurl, :votes
  json.url post_url(post, format: :json)
end
