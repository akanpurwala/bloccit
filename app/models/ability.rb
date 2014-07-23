class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # if a member, they can manage their own posts
    # or create new ones
    if user.role? :member
      can :manage, Favorite, user_id: user.id
      can :create, Vote
      can :manage, Post, user_id: user.id
      can :manage, Comment, user_id:user.id
      can :read, Topic
    end

    # moderators can delete any posts
    if user.role? :moderator
      can :destroy, Post
      can :destroy, Comment
    end

    # Admins can do anything
    if user.role? :admin
      can :manage, :all
    end

    can :read, Topic, public: true
    can :read, Post
    can :read, Comment
  end

end
