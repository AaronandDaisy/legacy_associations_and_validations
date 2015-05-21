# Basic test requires
require 'minitest/autorun'
require 'minitest/pride'

# Include both the migration and the app itself
require './migration'
require './application'

# Overwrite the development database connection with a test connection.
ActiveRecord::Base.establish_connection(
  adapter:  'sqlite3',
  database: 'test.sqlite3'
)

ActiveRecord::Migration.verbose = false

# Gotta run migrations before we can run tests.  Down will fail the first time,
# so we wrap it in a begin/rescue.
begin ApplicationMigration.migrate(:down); rescue; end
ApplicationMigration.migrate(:up)


# Finally!  Let's test the thing.
class ApplicationTest < Minitest::Test

  def test_truth
    assert true
  end

  def test_associate_school_with_terms
    school = School.create(name: "Durant")
    term = Term.create(name: "Summer")
    school.terms << term
    assert_equal "Summer", school.terms.last.name
  end

  def test_dont_destroy_terms
    summer = Term.create(name: "Summer")
    english = Course.create(name: "English", term_id: summer.id, course_code: "eng123")
    assert_equal english.term_id, summer.id
    refute summer.destroy
    assert summer
  end

  def test_dont_destroy_courses_if_students_present
    english = Course.create(name: "English", course_code: "eng123" )
    number_four = CourseStudent.create(student_id: 4, course_id: english.id)
    assert_equal english.id, number_four.course_id
    refute english.destroy
  end

  def test_destroy_assignments_in_course
    english = Course.create(name: "English")
    reading = Assignment.create(name: "Reading", course_id: english.id)
    assert_equal english.id, reading.course_id
    assert english.destroy
  end

  def test_associate_lessons_with_pre_class_assignments
    #come back to this one
  end

  def test_school_has_many_courses
    green_school = School.create(name: "Green_School")
    summer = Term.create(name: "Summer", school_id: green_school.id)
    english = Course.create(name: "English", term_id: summer.id, course_code: "eng123")
    math = Course.create(name: "Math", term_id: summer.id, course_code: "mat456")
    science = Course.create(name: "Science", term_id: summer.id, course_code: "sci789")
    green_school.courses
    assert_equal [english, math, science], green_school.courses
  end

  # def test_assert_lessons_have_names
  #   #come back to this one
  #   taxes = Lesson.create(name: "Taxes")
  #   # bills = Lesson.new(description: "how to pay bills to the man")
  #
  #   assert taxes.save
  #   # refute bills.save
  # end

  def test_assert_reading_fields_populated
    edgar_huntley = Reading.new(order_number: 5, lesson_id: 1, url: "http://www.food.com")
    assert edgar_huntley.save
  end

  def test_validates_courses_have_course_code
    english = Course.new(name: "English", course_code: 1)
    math = Course.new(color: "blue")
    assert english.save
    refute math.save
  end

  def test_reading_url_starts_with_http_or_https
    edgar_huntley = Reading.new(order_number: 5, lesson_id: 1, url: "http://www.food.com")
    earnest_hemmingway = Reading.new(order_number: 5, lesson_id: 1)

    assert edgar_huntley.save
    refute earnest_hemmingway.save
  end
end
