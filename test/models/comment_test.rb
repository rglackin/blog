require "test_helper"

class CommentTest < ActiveSupport::TestCase
  def setup
    @article = Article.create(title: "Test Article", body: "This is a test.")
    @comment = Comment.new(body: "Test comment", article: @article)
  end

  test "comment should be valid" do
    assert @comment.valid?
  end

  test "should not save with empty body" do
    @comment.body = ""
    assert_not @comment.save
  end

  test "article should be present" do
    @comment.article = nil
    assert_not @comment.valid?
  end

  test "comment should belong to an article" do
    assert_equal @article, @comment.article
  end
end
