require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
include AuthHelper
  
  setup do
    @article = articles(:one)
    
  end
  teardown do
    Rails.cache.clear
  end

  def authorize_user
    headers = { Authorization: ActionController::HttpAuthentication::Basic.encode_credentials("dhh", "secret") }
    return headers
  end

  test "should get index" do
    get articles_url
    assert_response :success, "failed to get index url"
  end

  test "should get new" do
    get new_article_url,  headers: authorize_user
    assert_response :success, "failed to get new article url"
  end

  test "should create article" do
    assert_difference("Article.count") do
      post articles_url, params: { article: { title:"Created",body:"testing body" } }, headers: authorize_user
    end

    assert_redirected_to article_url(Article.last)
  end

  test "should show article" do
    get article_url(@article)
    assert_response :success
  end

  test "should get edit" do
    get edit_article_url(@article), headers: authorize_user
    assert_response :success
  end

  test "should update article" do
    patch article_url(@article), params: { article: {title:"updated" ,body:"testing body",status:"public"} }, headers: authorize_user
    assert_redirected_to article_url(@article), "failed to redirect to article url after update"

    @article.reload
    assert_equal "updated", @article.title, "failed to update article title"
  end

  test "should destroy article" do
    assert_difference("Article.count", -1) do
      delete article_url(@article), headers: authorize_user
    end

    assert_redirected_to root_path
  end
end
