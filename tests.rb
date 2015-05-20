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

# Gotta run migrations before we can run tests.  Down will fail the first time,
# so we wrap it in a begin/rescue.
begin ApplicationMigration.migrate(:down); rescue; end
ApplicationMigration.migrate(:up)


# Finally!  Let's test the thing.
class ApplicationTest < Minitest::Test

  def test_truth
    assert true
  end

  def test_associate_lesson_readings
    history = Lesson.new
    history = []
    civil_war = Reading.new
    vietnam = Reading.new
    history << civil_war
    history << vietnam
    assert_equal civil_war, history[0]
    assert_equal vietnam, history[1]

    # department = Department.create(name: "Advertising")
    # don = Employee.create(name: "Don", email: "don@scdp.com", phone_number: "1231231234", salary: 10000)
    # department.assign(don)
    # assert_equal don, department.employees.last
  end

  def test_validate_that_schools_must_have_name
    gallup_hill = School.new(name:"Gallup Hill")
    school = School.new({})
    assert gallup_hill.save
    refute school.save
  end

  #  def test_validate_terms_have_name_starts_on_ends_on_and_school_id
  #    one = Term.new(name: "fall")
  #    assert one.save
  #    refute one.save
  #  end



end
