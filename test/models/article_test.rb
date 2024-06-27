require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @article = articles(:one)
  end
  test "should save article with valid fields" do
    
    assert @article.save, "Did not save the article with valid fields"
  end
  test "should not save article without title" do
    @article.title = ""
    assert_not @article.save, "Saved the article without a title"
  end
  test "should not save article without body" do
    @article.body = ""
    assert_not @article.save, "Saved the article without a body"
  end
  test "should not save article with body lt 10 chars" do
    @article.body = "123456789"
    assert_not @article.save, "Saved article with body < 10 chars"
  end
  test "should not save article without attached user" do
    @article.user = nil
    assert_not @article.save, "Saved article without attached user"
  end
end

