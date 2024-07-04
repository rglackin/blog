class NotificationMailer < ApplicationMailer
    def comment_notification(article_author, article, comment)
        @article_author = article_author
        @article = article
        @comment = comment
    
        mail(to: @article_author.email, subject: 'New Comment on Your Article')
    end
end
