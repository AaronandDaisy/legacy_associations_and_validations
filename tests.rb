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
    english = Course.create(name: "English", term_id: summer.id)
    assert_equal english.term_id, summer.id
    refute summer.destroy
    assert summer
  end

  def test_dont_destroy_courses_if_students_present
    english = Course.create(name: "English")
    number_four = CourseStudent.create(student_id: 4, course_id: english.id)
    assert_equal english.id, number_four.course_id
    p number_four
    refute english.destroy
  end

end
