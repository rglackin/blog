class CommentPolicy < ApplicationPolicy
  def is_article_author 
    user == record.article.user
  end
  def is_comment_author
    user == record.user
  end
  def create?
    user!=nil
  end
  def destroy?
    unless user == nil then 
      user ==  is_comment_author || user.admin || is_article_author
    end
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user && user.admin
        scope.all
      elsif user
        scope.where(user_id: user.id).or(scope.where(status: 'public'))
      else
        scope.where(status: 'public')
      end
    end
    private
    def policy
      @policy ||= CommentPolicy.new(user, scope)
    end
  end
end