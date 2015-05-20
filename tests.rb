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
    history = Lesson.create(name: "History")
    civil_war = Reading.create(caption: "War")
    vietnam = Reading.create(caption: "Vietnam")
    history.readings << civil_war
    assert_equal "War", history.readings.last.caption
  end

  # def test_validate_that_schools_must_have_name
  #   gallup_hill = School.new(name:"Gallup Hill")
  #   school = School.new({})
  #   assert gallup_hill.save
  #   refute school.save
  # end

  #  def test_validate_terms_have_name_starts_on_ends_on_and_school_id
  #    one = Term.new(name: "fall")
  #    assert one.save
  #    refute one.save
  #  end



end
