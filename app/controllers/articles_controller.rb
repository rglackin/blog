class ArticlesController < ApplicationController
  #http_basic_authenticate_with name: "dhh", password: "secret", except: [:index, :show]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, except: [:index, :show]
  #after_action :verify_policy_scoped, only: [:index, :show]
  def index
    @pagy ,@articles = pagy(policy_scope(Article), items:12)
    @total_articles = @pagy.count
  end

  def show
    @article = policy_scope(Article).find(params[:id])
  end

  def new
    @article = Article.new
    authorize @article
  end

  def create
    
    @article = current_user.articles.create(article_params)
    authorize @article
    if @article.save
      redirect_to @article
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @article
    #@article = Article.find(params[:id])
  end

  def update
    authorize @article
    #@article = Article.find(params[:id])
    if @article.update(article_params)
      redirect_to @article, notice: 'Article updated successfully'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  def destroy
    authorize @article
    #@article = Article.find(params[:id])
    @article.destroy
    redirect_to root_path, status: :see_other
  end
  private
    def article_params
      params.require(:article).permit(:title, :body, :status)
    end
    def set_article
      @article = Article.find(params[:id])
    end
end
