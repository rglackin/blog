class Api::V1::UsersController < ApplicationController
    def show
        @user = User.find(params[:id])
        
        #comments = policy_scope(Comment).where(user_id: @user.id).includes(:article)
        render json: @user, include: ['articles', 'comments'] 
        
    end
end
