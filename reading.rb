class Reading < ActiveRecord::Base
  validates :order_number, :lesson_id, :presence=>true
  validates :url, presence: true, format: /(^https?:?\/\/www\.\w+\.com)/
  belongs_to :lesson

  default_scope { order('order_number') }

  scope :pre, -> { where("before_lesson = ?", true) }
  scope :post, -> { where("before_lesson != ?", true) }

  def clone
    dup
  end
end
