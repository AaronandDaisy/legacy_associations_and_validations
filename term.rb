class Term < ActiveRecord::Base
  belongs_to :school, class_name: "School", foreign_key: "school_id"
  has_many :courses, dependent: :restrict_with_error
  default_scope { order('ends_on DESC') }

  validates :name, presence: true

  scope :for_school_id, ->(school_id) { where("school_id = ?", school_id) }
 # validates :name, presence true
 # validates :start_on, presence true,
 # validates :ends_on, presence true
 # validates :school_id, presence true
 # validates :name, :start_on, :ends_on, school_id: true

  def school_name
    school ? school.name : "None"
  end
end
