class Api::V1::UsersController < ApplicationController
    def show
        @user = User.find(params[:id])
        @comments = policy_scope(@user.comments)
        @articles = policy_scope(@user.articles)
    end
end
