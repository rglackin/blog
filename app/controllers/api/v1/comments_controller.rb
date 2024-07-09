class Api::V1::CommentsController < ApplicationController
    before_action :set_article
    before_action :set_comment, only: [:destroy]
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    def create
        authorize @comment
        @comment = @article.comments.new(comment_params)
        @comment.user_id = current_user.id
        if @comment.save

            NotificationMailer.comment_notification(@article.user, @article, @comment).deliver_later
            render json: @comment
        else
            render error: { error: 'Unable to create Comment'}, status: 400
        end
        
    end
    def destroy
        authorize @comment
        if @comment
            @comment.destroy
            render json: {message: 'Comment deleted successfully'}, status: 200
        else
            render json: { error: 'Unable to delete Comment'}, status: 400
        end
    end
    private
        def comment_params
            params.require(:comment).permit( :body, :status)
        end
        def set_article
            @article = Article.find(params[:article_id])
        end
        def set_comment
           
            @comment = @article.comments.find(params[:id])
        end
        def user_not_authorized(exception)
            render json: { error: "You are not authorized to perform this action." }, status: :unauthorized
          end
       
end
