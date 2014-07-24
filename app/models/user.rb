class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, :omniauth_providers => [:facebook]

  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :avatar, :provider, :uid, :email_favorites

  has_many :posts
  has_many :comments
  has_many :votes, dependent: :destroy
  has_many :favorites, dependent: :destroy
  before_create :set_member
  mount_uploader :avatar, AvatarUploader

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      pass = Devise.friendly_token[0,20]
      user = User.new(name: auth.extra.raw_info.name,
        provider: auth.provider,
        uid: auth.uid,
        email: auth.info.email,
        password: pass,
        password_confirmation: pass
        )
      user.skip_confirmation!
      user.save
    end
    user
  end

  def self.top_rated
    self.select('users.*').
      select('COUNT(DISTINCT comments.id) AS comments_count'). # count comments made by user
      select('COUNT(DISTINCT posts.id) AS posts_count'). # count posts made by user
      select('COUNT(DISTINCT comments.id) + COUNT(DISTINCT posts.id) AS rank'). # Sum comment and post count
      joins(:posts). # Ties posts table to users table, via user_id
      joins(:comments). # Ties comments table to users table, via user_id
      group('users.id'). # Instructs database to group results so that each user will returned in a distinct row
      order('rank DESC') # Instructs datababse to order results in descending order by rankk
  end



  ROLES = %w[member moderator admin]
  
  def role?(base_role)
    role.nil? ? false : ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  def favorited(post)
    self.favorites.where(post_id: post.id).first
  end

  def voted(post)
    self.votes.where(post_id: post.id).first
  end

  def sum_votes
    votes = 0
    self.posts.each do |post|
      votes += post.votes.count
    end
    votes.to_i
  end
  
  private

  def set_member
    self.role = 'member'
  end

end
