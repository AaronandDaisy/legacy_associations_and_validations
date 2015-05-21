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

  def test_associate_lessons_with_courses
    course = Course.create(name: "World History", course_code: "SCI40")
    lesson = Lesson.create(name: "History", course_id: world_history.id)
    course.lessons << lesson
    assert_equal "History", course.lessons.last.name
  end

  # def test_associate_course_and_course_instructor
  #   course = Course.create(name: "World History")
  #   course = Course.create(name: "World History II")
  #   course = Course.create(name: "American History")
  #   instructor = CourseInstructor.create
  #   instructor.courses << course
  #   assert_equal "American History", instructor.courses.last.name
  # end

  def test_validate_that_schools_must_have_name
    gallup_hill = School.create(name:"Gallup Hill")
    school = School.create({})
    assert gallup_hill.save
    refute school.save
  end

  # def test_validate_terms_must_have_name_starts_on_ends_on_school_id
  #   summer = Term.create
  # end

  # def test_associate_lessons_with_in_class_assignments
  #   lesson = Lesson.create(name: "Spanish")
  #   assignment = Assignment.create(name: "writing")
  #   lesson.assignments << assignment
  #   assert_equal "writing", lesson.assignments.last.name
  # end

  def test_validate_email_is_unique
    doglover = User.create(email: "doglover@aol.com")
    dalmation_fan = User.create(email: "doglover@aol.com")
    assert doglover.save
  end

  def test_validate_email
    catlady = User.create(email: "crazycatlady.com")
    birdwatcher = User.create(email: "birdwatcher@aol.com")
    assert birdwatcher.save
  end


  def test_validate_assignment_name_unique_in_course
    writing = Assignment.create(name: "writing")
    spelling = Assignment.create(name: "writing")
    assert writing.save
    refute spelling.save
  end



end
