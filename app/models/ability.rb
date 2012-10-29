class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.has_role?(:super_user)
      can :manage, :all
    elsif user.has_role?(:user)
    end
  end
end
