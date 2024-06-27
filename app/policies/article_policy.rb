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
      # allow admin to see all posts
      if user && user.admin
        scope.all
      elsif user
        # users can see all non public posts they own  
        scope.where(status: 'public').or(scope.where(user_id: user.id))
      else
        # other users only see public posts
        scope.where(status: 'public')
      end
    end
    #dont allow anyone unathorized to browse to see non public posts
  end
end
