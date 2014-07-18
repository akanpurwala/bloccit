class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # if a member, they can manage their own posts
    # or create new ones
    if user.role? :member
      can :manage, Post, user_id: user.id
      can :manage, Comment, user_id:user.id
    end

    # moderators can delete any posts
    if user.role? :moderator
      can :destroy, Post
      can :destroy, Comment
      can :manage, Topic
    end

    # Admins can do anything
    if user.role? :admin
      can :manage, :all
    end

    can :read, :all
  end

end
