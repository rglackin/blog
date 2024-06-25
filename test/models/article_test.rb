require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  test "should save article with title and body" do
    article = Article.new
    article.title = "Test"
    article.body = "This is a test"
    assert article.save, "Did not save the article with title and body"
  end
  test "should not save article without title" do
    article = Article.new
    article.body = "This is a test"
    assert_not article.save, "Saved the article without a title"
  end
  test "should not save article without body" do
    article = Article.new
    article.title= "Test"
    assert_not article.save, "Saved the article without a body"
  end
test "should not save article with body lt 10 chars" do
    article = Article.new
    article.title = "Test"
    article.body = "Invalid"
    assert_not article.save, "Saved article with body < 10 chars"
  end
end

