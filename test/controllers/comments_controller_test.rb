require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @article = articles(:one)
    @comment = comments(:one)
  end

  test "should create comment" do
    assert_difference("Comment.count") do
      post article_comments_url(@article), params: { comment: {body:"New comment content",article_id: @article.id  } },headers: authorize_user
    end

    assert_redirected_to article_url(@article)
  end

  test "should destroy comment" do
    assert_difference("Comment.count", -1) do
      delete article_comment_url(@article,@comment), headers: authorize_user
    end

    assert_redirected_to article_url(@article)
  end
end
