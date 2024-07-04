class UsersController < ApplicationController
    def show
        @user = User.find(params[:id])
        @pagy ,@articles = pagy(policy_scope(@user.articles), items:12)
        @total_articles = @pagy.count
        comments = policy_scope(Comment).where(user_id: @user.id).includes(:article)
        @pagy_comment, comments = pagy(comments, items:12, page_param: :page_comment)
        @comments_by_article = comments.group_by(&:article)
    end
end
