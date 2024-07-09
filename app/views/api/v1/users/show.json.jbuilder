json.name @user.name
json.bio @user.bio

json.comments @comments do |comment|
  json.extract! comment, :id, :body, :created_at
  json.article_title comment.article.title
end

json.articles @articles do |article|
  json.extract! article, :id, :title, :body, :created_at
end