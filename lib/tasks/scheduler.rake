desc "Daily summary email to all users"
task daily_summary: :environment do
    articles = Article.where("created_at >= ?", 1.day.ago)
    unless articles.empty?
        users = User.all
        users.each do |user|
            other_articles = articles.reject { |article| article.user == user }
            unless other_articles.empty?
                begin
                    NotificationMailer.daily_summary(user, other_articles).deliver
                rescue => Mailgun::CommunicationError

                    Rails.logger.info "Failed to send email to #{user.email}. Email not authorized."
                end
            end
        end
    end
end