class Api::V1::ArticlesController < ApplicationController
    before_action :set_article, only: [:show, :update, :destroy]
  
    def index
        @articles = Article.all
        render json: @articles
    end
    def search
        
    end
    def show
        render json: @article
    end

    

    def create
        @article = current_user.articles.build(article_params)
        if @article.save
            render json: @article
        else
          render error: { error: 'Unable to create Article'}, status: 400
        end
    end

    

    def update
        if @article.update(article_params)
          render json: { message: 'Article updated successfully'}, status: 200
        else
          render error: { error: 'Unable to update Article'}, status: 400
        end
    end
    def destroy
        if @article
            @article.destroy
            render json: {message: 'Article deleted successfully'}, status: 200
        else
            render error: { error: 'Unable to delete Article'}, status: 400
        end
    end
    private
    def article_params
        params.require(:article).permit(:title, :body, :status)
    end
    def set_article
        @article = Article.find(params[:id])
    end
end
