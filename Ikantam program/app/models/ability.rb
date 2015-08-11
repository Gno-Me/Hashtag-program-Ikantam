class Ability
  include CanCan::Ability

  def initialize(user)
    if user 
      set_role_user(user)
    else
      set_role_guest(user)
    end
  end

  def set_role_guest(user)
    can :manage, :all
  end

  def set_role_user(user)
    if !user.email_verified? 
      cannot :manage, :all
      can :finish_signup, User
    else
      can :manage, :all
    end
  end
end
