class Vote < ActiveRecord::Base
  attr_accessible :value, :post

  belongs_to :user
  belongs_to :post

  validates :value, inclusion: { in: [-1,1], message: "%{value} is not a valid vote."}

  after_save :update_post

  def up_vote?
    value == 1
  end

  def down_vote?
    value == -1
  end

  private

  def update_post
    self.post.update_rank
  end

end
