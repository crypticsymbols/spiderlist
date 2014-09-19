class Ability
  include CanCan::Ability

  def initialize(user)

    if user.admin?
        can :access, :rails_admin   # grant access to rails_admin
        can :dashboard
        can :manage, :all
    else
        # can :manage, user, :user => user.id
        # can :create, Alert
        can :manage, Alert, :user_id => user.id
    end
  end
end
