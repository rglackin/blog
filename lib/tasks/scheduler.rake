desc "Daily summary email to all users"
task daily_summary: :environment do
    articles = Article.where("created_at >= ?", 1.day.ago)
    users = User.all
    users.each do |user|
        other_articles = articles.reject { |article| article.user == user }
        NotificationMailer.daily_summary(user, other_articles).deliver
    end
end
