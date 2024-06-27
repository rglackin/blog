require "test_helper"

class CommentTest < ActiveSupport::TestCase
  def setup
    @article = articles(:two)
    @comment = comments(:two)
    @user = users(:two)	
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

  test "user should be present" do
    @comment.user = nil
    assert_not @comment.valid?
  end
  test "comment should belong to a user" do
    assert_equal @user, @comment.user
  end
  
end
