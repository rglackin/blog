require 'rails_helper'

RSpec.describe "Comments", type: :request do
  fixtures [:articles,:users, :comments]
  let(:user) { users(:one) }
  let(:article) { articles(:one) }
  let(:comment_params) {{body: "This is a comment", status: "public"}}
  describe "POST /articles/:article_id/comments" do
    context "with valid parameters and authentication" do    
      before do
        sign_in user
        post article_comments_path(article), params: { comment: comment_params }
      end

      it "creates a comment" do
        expect(article.comments.last.body).to eq(comment_params[:body])
      end
      it "returns a redirect response" do
        expect(response).to have_http_status(:redirect)
      end
      it "redirects to the article" do
        expect(response).to redirect_to(article_path(article))
      end
    end
    context "without valid params" do
      before do
        sign_in user
      end
      it "does not create a comment with invalid body" do
        comment_params[:body] = ""
        expect{
          post article_comments_path(article), params: { article: comment_params }
      }.to change(Comment, :count).by(0)
      end
      it "does not create a comment with invalid status" do
        comment_params[:status] = ""
        expect{
          post article_comments_path(article), params: { article: comment_params }
      }.to change(Comment, :count).by(0)
      end
      
    end
    context "without authentication" do
      it "does not create a comment" do
        expect{
          post article_comments_path(article), params: { article: comment_params }
      }.to change(Comment, :count).by(0)
      end
      it "redirects to login page" do
        post article_comments_path(article), params: { article: comment_params }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
  describe "DELETE /articles/:article_id/comments/:id" do
    context "with authorization" do
      before do
        sign_in user
        
      end
      it "deletes the comment" do
        expect{
          delete article_comment_path(article, comments(:one))
      }.to change(Comment, :count).by(-1)
      end
      it "redirects to the article" do
        delete article_comment_path(article, comments(:one))
        expect(response).to redirect_to(article_path(article))
      end
    end
    context "without authorization" do
      before do
        sign_in users(:two)
      end
      it "does not delete the comment" do
        expect{
          delete article_comment_path(article, comments(:one))
      }.to change(Comment, :count).by(0)
      end
      it "redirects to the root" do
        delete article_comment_path(article, comments(:one))
        expect(response).to redirect_to(root_path)
      end
    end
    context "without authentication" do
      it "does not delete the comment" do
        expect{
          delete article_comment_path(article, comments(:one))
      }.to change(Comment, :count).by(0)
      end
      it "redirects to the login page" do
        delete article_comment_path(article, comments(:one))
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

end
