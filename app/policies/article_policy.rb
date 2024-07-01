class ArticlePolicy < ApplicationPolicy
  
  def new?
    user!=nil
  end
  alias_method :create?, :new?  
  def update?
    user == record.user
  end
  alias_method :destroy?, :update?
  alias_method :edit?, :update?

  class Scope < ApplicationPolicy::Scope
    def resolve
      base_scope = scope.order(created_at: :desc)
      if user && user.admin
        # allow admin to see all posts
        base_scope.all
      elsif user
        # users can see all posts they own and all public posts  
        base_scope.where(status: 'public').or(base_scope.where(user_id: user.id))
      else
        # if not logged in only see public posts
        base_scope.where(status: 'public')
      end
    end
  end
end
