require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @user = users(:one)
    @article = articles(:one)
    @comment = comments(:one)
  end

  test "should create comment" do
    sign_in @user
    assert_difference("Comment.count") do
      post article_comments_url(@article), params: { comment: {body:"New comment content",article_id: @article.id, user_id: @user.id  } }
    end
    assert_redirected_to article_url(@article)
  end

  test "should destroy comment" do
    sign_in @user
    assert_difference("Comment.count", -1) do
      delete article_comment_url(@article,@comment)
    end

    assert_redirected_to article_url(@article)
  end
end
