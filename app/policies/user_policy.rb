class UserPolicy
  
  attr_reader :user, :record
  
  def initialize(user, record)
    @user = user
    @record = record
  end
  
  def same_user?
    user == record
  end
  
  def show?
    same_user? || user.admin?
  end
  
  def update?
    same_user? || user.admin?
  end
  
  def edit?
    same_user? || user.admin?
  end
  
  def simulate?
    user.admin? && !same_user?
  end
end