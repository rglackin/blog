class UsersController < ApplicationController
    def show
        @user = User.find(params[:id])
        @pagy ,@articles = pagy(policy_scope(@user.articles), items:12)
        @total_articles = @pagy.count
    end
end
