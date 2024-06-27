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
    # allow admin to see all posts
    # other users only see public posts
    # users can see all non public posts they own  
    #dont allow anyone unathorized to browse to see non public posts
  end
end
