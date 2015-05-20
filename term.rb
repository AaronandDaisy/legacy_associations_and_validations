class Term < ActiveRecord::Base
 # validates :name, presence true
 # validates :start_on, presence true,
 # validates :ends_on, presence true
 # validates :school_id, presence true
 # validates :name, :start_on, :ends_on, school_id: true

  scope :for_school_id, ->(school_id) { where("school_id = ?", school_id) }

  default_scope { order('ends_on DESC') }



  def school_name
    school ? school.name : "None"
  end
end
