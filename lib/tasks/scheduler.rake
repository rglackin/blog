desc "Daily summary email to all users"
task daily_summary: :environment do
    articles = Article.where("created_at >= ?", 1.day.ago)
    unless articles.empty? do
        users = User.all
        users.each do |user|
            other_articles = articles.reject { |article| article.user == user }
            try:NotificationMailer.daily_summary(user, other_articles).deliver
            catch(Mailgun::CommunicationError)
                puts "Failed to send email to #{user.email}. Email not authorized."
        end
    end
end
end