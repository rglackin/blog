require 'rails_helper'

RSpec.describe Comment, type: :model do
  fixtures [:users,:articles, :comments]
  describe 'validations' do
    it "is valid with valid attributes" do
      comment = Comment.new(body: "Test",user: users(:one), article: articles(:one))
      expect(comment).to be_valid
    end
    it "is not valid without a body" do
      comment = comments(:one)
      comment.body = nil
      expect(comment).to_not be_valid
    end
    it "is not valid without a user" do
      comment = comments(:one)
      comment.user = nil
      expect(comment).to_not be_valid
    end
    it "is not valid without an article" do
      comment = comments(:one)
      comment.article = nil
      expect(comment).to_not be_valid
    end
  end
  describe 'associations' do
    it "belongs to a user" do
      comment = comments(:one)
      user = users(:one)
      expect(comment.user).to eq(user)
    end
    it "belongs to an article" do
      comment = comments(:one)
      article = articles(:one)
      expect(comment.article).to eq(article)
    end
  end
end
