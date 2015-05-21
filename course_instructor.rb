class CourseInstructor < ActiveRecord::Base
  # has_many :courses, dependent: :restrict_with_exception
  # has_many :students, through: :courses, dependent: :restrict_with_exception
end
