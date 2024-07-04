class CommentsController < ApplicationController
    before_action :authenticate_user!, only: [:destroy, :create]
    
    after_action :verify_authorized
    def create

        @article = Article.find(params[:article_id])
        authorize @article
        @comment = @article.comments.new(comment_params)
        @comment.user_id = current_user.id
        if @comment.save

            NotificationMailer.comment_notification(@article.user, @article, @comment).deliver_later
        end
        redirect_to article_path(@article)
    end
    def destroy
        @article = Article.find(params[:article_id])
        @comment = @article.comments.find(params[:id])
        authorize @comment
        @comment.destroy
        redirect_to article_path(@article), status: :see_other
    end
    private
        def comment_params
            params.require(:comment).permit( :body, :status)
        end
       
end
