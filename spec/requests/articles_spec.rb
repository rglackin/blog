require 'rails_helper'

RSpec.describe "Articles", type: :request do
  fixtures [:articles,:users]
  describe "GET /articles" do
    describe "GET /articles" do
      before do
        get articles_path
      end
  
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
  
      it "renders the index template" do
        expect(response).to render_template(:index)
      end
  
      it "includes articles in the response body" do
        expect(response.body).to include(articles(:one).title)
      end
    end
  end
  describe "GET /articles/:id" do
    before do
      get article_path(articles(:one))
    end
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "renders the show template" do
      expect(response).to render_template(:show)
    end

    it "includes article in the response body" do
      expect(response.body).to include(articles(:one).title)
      expect(response.body).to include(articles(:one).body)
    end
  end
  describe "GET /articles/new" do
    before do |example|
      unless example.metadata[:skip_before]
        sign_in users(:one)
        get new_article_path
      end
    end
    it "returns http success when logged in" do
      expect(response).to have_http_status(:success)
    end
    it "redirects to the sign-in page when not logged in", skip_before: true do
      get new_article_path
      expect(response).to redirect_to(new_user_session_path)
    end
    it "renders the new template" do
      expect(response).to render_template(:new)
    end
    it "includes the necessary form fields" do
      expect(response.body).to include('input', 'textarea','select') 
    end
  end
  describe "POST /articles" do
    let(:article_attributes){ { title: "New Article", body: "This is the body of the new article", status: "public" }}
    context "with valid parameters" do
      before do
        sign_in users(:one)
      end
      include_examples "article validations", :articles_path
      it "creates a new article" do
        expect{
          post articles_path, params: { article: article_attributes }
      }.to change(Article, :count).by(1)
      end
      it "returns a redirect response" do
        post articles_path, params: { article: article_attributes }
        expect(response).to have_http_status(:redirect)
      end
      it "redirects to article show" do
        post articles_path, params: { article: article_attributes }
        expect(response).to redirect_to(article_path(Article.last))
      end
    end
    context "without authentication" do
      it "does not create a new article" do
        expect{
          post articles_path, params: { article: article_attributes }
      }.to change(Article, :count).by(0)
      end
      it "redirects to login page" do
        post articles_path, params: { article: article_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    context "with invalid parameters" do
      before do
        sign_in users(:one)
      end
      it "does not create a new article without title" do
        expect{
          post articles_path, params: { article: { title: "", body: "This is a test article" , status: "public"}}
      }.to change(Article, :count).by(0)
      end
      it "does not create a new article without body" do
        expect{
          post articles_path, params: { article: { title: "Tite", body: "" , status: "public"}}
      }.to change(Article, :count).by(0)
      end
      
      it "does not create a new article without status" do
        expect{
          post articles_path, params: { article: { title: "Tite", body: "This is a test article" , status: ""}}
      }.to change(Article, :count).by(0)
      end
      it "does not create a new article with body less than 10 chars" do
        expect{
          post articles_path, params: { article: { title: "Tite", body: "" , status: "public"}}
      }.to change(Article, :count).by(0)
      end
    end
  end
  describe "GET /articles/:id/edit" do
    context "with authorization" do
      before do
        sign_in articles(:one).user
        get edit_article_path(articles(:one))
      end
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      it "renders the edit template" do
        expect(response).to render_template(:edit)
      end
      it "includes the necessary form fields" do
        expect(response.body).to include('input', 'textarea','select') 
      end
    end
    context "without authorization" do
      before do
        sign_in users(:two)
        get edit_article_path(articles(:one))
      end
      it "redirects to the root path" do
        expect(response).to redirect_to(root_path)
      end
      it "displays an authorization error message" do
        follow_redirect!
        expect(response.body).to include("You are not authorized to perform this action.")
      end
    end
    context "without authentication" do
      before do
        get edit_article_path(articles(:one))
      end
      it "redirects to the sign in path" do
        expect(response).to redirect_to(new_user_session_path)
      end
      it "displays an authentication error message" do
        follow_redirect!
        expect(response.body).to include("You need to sign in or sign up before continuing.")
      end
    end
  end
  describe "PATCH /articles/:id" do
    let(:article_attributes){ { title: "New Article", body: "This is the body of the new article", status: "public" }}
    context "with authorization" do
      before do
        sign_in articles(:one).user
      end
      it "updates the article" do
        patch article_path(articles(:one)), params: { article: article_attributes }
        articles(:one).reload
        expect(articles(:one).title).to eq("New Article")
        expect(articles(:one).body).to eq("This is the body of the new article")
        expect(articles(:one).status).to eq("public")
      end
      it "redirects to the article show" do
        patch article_path(articles(:one)), params: { article: article_attributes }
        expect(response).to redirect_to(article_path(articles(:one)))
      end
    end
    context "without authorization" do
      before do
        sign_in users(:two)
        patch article_path(articles(:one)), params: { article: article_attributes }
      end
      it "does not update the article" do
        articles(:one).reload
        expect(articles(:one).title).to eq("First Article")
        expect(articles(:one).body).to eq("This is the first article")
        expect(articles(:one).status).to eq("public")
      end
      it "redirects to the root path" do
        expect(response).to redirect_to(root_path)
      end
      it "displays an authorization error message" do
        follow_redirect!
        expect(response.body).to include("You are not authorized to perform this action.")
      end
    end
    context "without authentication" do
      before do
        patch article_path(articles(:one)), params: { article: article_attributes }
      end
      it "redirects to the sign in path" do
        expect(response).to redirect_to(new_user_session_path)
      end
      it "displays an authentication error message" do
        follow_redirect!
        expect(response.body).to include("You need to sign in or sign up before continuing.")
      end
    end
  end
  describe "DELETE /articles/:id" do
    context "with authorization" do
      before do
        sign_in articles(:one).user
      end
      it "deletes the article" do
        expect{
          delete article_path(articles(:one))
      }.to change(Article, :count).by(-1)
      end
      it "redirects to the root path" do
        delete article_path(articles(:one))
        expect(response).to redirect_to(root_path)
      end
    end
    context "without authorization" do
      before do
        sign_in users(:two)
        delete article_path(articles(:one))
      end
      it "does not delete the article" do
        expect{
          delete article_path(articles(:one))
      }.to change(Article, :count).by(0)
      end
      it "redirects to the root path" do
        expect(response).to redirect_to(root_path)
      end
      it "displays an authorization error message" do
        follow_redirect!
        expect(response.body).to include("You are not authorized to perform this action.")
      end
    end
    context "without authentication" do
      before do
        delete article_path(articles(:one))
      end
      it "redirects to the sign in path" do
        expect(response).to redirect_to(new_user_session_path)
      end
      it "displays an authentication error message" do
        follow_redirect!
        expect(response.body).to include("You need to sign in or sign up before continuing.")
      end
    end
  end
end
