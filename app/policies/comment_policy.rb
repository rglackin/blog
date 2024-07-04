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
      base_scope = scope.order(created_at: :desc)
      if user && user.admin
        base_scope.all
      elsif user
        base_scope.where(user_id: user.id).or(base_scope.where(status: 'public'))
      else
        base_scope.where(status: 'public')
      end
    end
    private
    def policy
      @policy ||= CommentPolicy.new(user, scope)
    end
  end
end