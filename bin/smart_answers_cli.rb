$LOAD_PATH.unshift('.')

require 'smart_answer'

smart_answer = SmartAnswer.new

puts "\nWhat type of student are you?"
puts '1. UK student full-time'
puts '2. UK student part-time'
puts '3. EU student full-time'
puts '4. EU student part-time'
student_type = gets.chomp

case student_type
when '1'
  smart_answer.study_mode = SmartAnswer::Student::FULL_TIME
  smart_answer.student_origin = SmartAnswer::Student::UK
when '2'
  smart_answer.study_mode = SmartAnswer::Student::PART_TIME
  smart_answer.student_origin = SmartAnswer::Student::UK
when '3'
  smart_answer.study_mode = SmartAnswer::Student::FULL_TIME
  smart_answer.student_origin = SmartAnswer::Student::EU
when '4'
  smart_answer.study_mode = SmartAnswer::Student::PART_TIME
  smart_answer.student_origin = SmartAnswer::Student::EU
end

puts "\nHow much are your tuition fees per year?"
tuition_fees = gets.chomp

smart_answer.tuition_fees = Integer(tuition_fees)

if smart_answer.student_origin == SmartAnswer::Student::UK
  puts "\nWhat's your annual household income?"
  household_income = gets.chomp

  smart_answer.household_income = Integer(household_income)

  puts "\nDo any of the following apply (you might get extra funding)?"
  puts "1. You've got children under 17"
  puts "2. None of these"
  response = gets.chomp

  case response
  when '1'
    smart_answer.has_children = true
  when '2'
    smart_answer.has_children = false
  end
end

puts
puts smart_answer.outcome
