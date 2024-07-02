require 'rails_helper'

RSpec.describe Article, type: :model do
  fixtures [:users,:articles, :comments]
  describe 'validations' do
    it "is valid with valid attributes" do
      article = Article.new(title: "Test", body: "Lorem ipsum",user: users(:one))
      expect(article).to be_valid
    end
    it "is not valid without a title" do
      article = articles(:one)
      article.title = nil
      expect(article).to_not be_valid
    end
    it "is not valid without a body" do
      article = articles(:one)
      article.body= nil
      expect(article).to_not be_valid
    end
    it "is not valid without a user" do
      article = articles(:one)
      article.user = nil
      expect(article).to_not be_valid
    end
    it "is not valid with a body less than 10 characters" do
      article = articles(:one)
      article.body = "123456789"
      expect(article).to_not be_valid
    end
  end
  describe 'associations' do
    it 'has many comments' do
      article = articles(:one)
      comment_1 = comments(:one)
      comment_2 = comments(:two)
      expect(article.comments.length).to eq(2)
      expect(article.comments).to include(comment_1, comment_2)
    end
    it 'deletes comments on destroy' do
      article = articles(:one)
      comment_1 = comments(:one)
      comment_2 = comments(:two)
      
      article.destroy
      expect(Comment.exists?(comment_1.id)).to be_falsey
      expect(Comment.exists?(comment_2.id)).to be_falsey
    end
    it 'belongs to a user' do
      article = articles(:one)
      user = users(:one)
      expect(article.user).to eq(user)
    end
  end
end
