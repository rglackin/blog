require 'rails_helper'

RSpec.describe User, type: :model do
  fixtures [:users,:articles, :comments]
    describe "validations" do
    it "is valid with valid attributes" do
        user = User.new(email:"test@test.com", password: "password", name: "test")
        expect(user).to be_valid
    end
    describe "presence" do
      
      it "is not valid without an email" do
        user = users(:one)
        user.email = nil
        expect(user).to_not be_valid
      end
      it "is not valid without a password" do
        user = User.new(email:"test@example.com", password: nil, name: "test")
        expect(user).to_not be_valid
        expect(user.errors[:password]).to include("can't be blank")
      end
      it "is not valid without a name" do
        user = users(:one)
        user.name = nil
        expect(user).to_not be_valid
      end
    end
    describe "length" do
      it "is not valid with a password less than 6 characters" do
        user = User.new(email:"test@example.com", password: "12345", name: "test")
        expect(user).to_not be_valid
        expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
      end
      it "is not valid with a name less than 3 characters" do
        user = users(:one)
        user.name = "12"
        expect(user).to_not be_valid
        expect(user.errors[:name]).to include("is too short (minimum is 3 characters)")
      end
    end
    it "is not valid with an invalid email" do
      user = users(:one)
      user.email = "test"
      expect(user).to_not be_valid
    end
  end
  describe "assosciations" do
    describe "articles" do
      it "has many articles" do
        user = users(:one)
        article_1 = articles(:one)
        article_2 = articles(:three)
        expect(user.articles.length).to eq(2)
        expect(user.articles).to include(article_1, article_2)
      end
      it "deletes articles on destroy" do
        user = users(:one)
        article_1 = articles(:one)
        article_2 = articles(:three)
        user.destroy
        expect(Article.exists?(article_1.id)).to be_falsey
        expect(Article.exists?(article_2.id)).to be_falsey
      end
    end
    describe "comments" do
      it "has many comments" do
        user = users(:one)
        comment_1 = comments(:one)
        comment_2 = comments(:three)
        expect(user.comments.length).to eq(2)
        expect(user.comments).to include(comment_1, comment_2)
      end
      it "deletes comments on destroy" do
        user = users(:one)
        comment_1 = comments(:one)
        comment_2 = comments(:three)
        user.destroy
        expect(Comment.exists?(comment_1.id)).to be_falsey
        expect(Comment.exists?(comment_2.id)).to be_falsey
      end
    end
  end
  describe "callbacks" do
    context "before create" do
      it "sets first user as admin" do
        User.destroy_all
        user = User.create(email:"email@email.com", password: "password", name: "admin")
        expect(user.admin).to be_truthy
      end
      it "does not set admin if user exists" do
        expect(User.count).to be > 0
        user = User.create(email:"email@email.com", password: "password", name: "member")
        expect(user.admin).to be_falsey
      end
    end
  end
end