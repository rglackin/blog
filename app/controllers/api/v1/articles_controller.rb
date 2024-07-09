class Api::V1::ArticlesController < ApplicationController
    #before_action :authenticate_user!, except: [:index, :show, :search]
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    rescue_from NoMethodError, with: :user_not_authorized
    before_action :set_article, only: [:show, :update, :destroy]
    #after_action :verify_authorized, except: [:index, :show, :search]
    skip_before_action :verify_authenticity_token
    def index
        @articles = policy_scope(Article)
        
        render json: @articles
    end
    def search 
        authorized_articles = policy_scope(Article)
        @articles = authorized_articles.search_by_title(params[:search])
        render json: @articles 
    end
    def show
       
        @comments = policy_scope(@article.comments)
        render json: { article: @article, comments: @comments }
    end
    def create
        
        @article = current_user.articles.build(article_params)
        authorize @article
        if @article.save
            render json: @article
        else
          render error: { error: 'Unable to create Article'}, status: 400
        end
    end

    

    def update
        authorize @article
        if @article.update(article_params)
          render json: { message: 'Article updated successfully'}, status: 200
        else
          render error: { error: 'Unable to update Article'}, status: 400
        end
    end
    def destroy
        authorize @article
        if @article
            @article.destroy
            render json: {message: 'Article deleted successfully'}, status: 200
        else
            render error: { error: 'Unable to delete Article'}, status: 400
        end
        byebug
    end
    private
    def article_params
        params.require(:article).permit(:title, :body, :status)
    end
    def set_article
        @article = Article.find(params[:id])
    end
    def user_not_authorized(exception)
        render json: { error: "You are not authorized to perform this action." }, status: :unauthorized
      end
end
