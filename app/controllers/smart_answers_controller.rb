class SmartAnswersController < ApplicationController
  TOTAL_NUMBER_OF_QUESTIONS = 4

  def show
    if response = params[:response]
      redirect_to url_for + '/' + response
      return
    end

    responses = String(params[:responses]).split('/')

    question_to_render = responses.length + 1

    student_type = responses.first

    if (question_to_render <= 2) ||
      (question_to_render <= TOTAL_NUMBER_OF_QUESTIONS && student_type =~ /uk/)
      render "question_#{question_to_render}"
    else
      smart_answer = SmartAnswer.new

      student_type = responses.shift
      case student_type
      when 'uk-student-full-time'
        smart_answer.study_mode = SmartAnswer::Student::FULL_TIME
        smart_answer.student_origin = SmartAnswer::Student::UK
      when 'uk-student-part-time'
        smart_answer.study_mode = SmartAnswer::Student::PART_TIME
        smart_answer.student_origin = SmartAnswer::Student::UK
      when 'eu-student-full-time'
        smart_answer.study_mode = SmartAnswer::Student::FULL_TIME
        smart_answer.student_origin = SmartAnswer::Student::EU
      when 'eu-student-part-time'
        smart_answer.study_mode = SmartAnswer::Student::PART_TIME
        smart_answer.student_origin = SmartAnswer::Student::EU
      end

      tuition_fees = responses.shift
      smart_answer.tuition_fees = Integer(tuition_fees)

      if student_type =~ /uk/
        household_income = responses.shift
        smart_answer.household_income = Integer(household_income)

        additional_benefits = responses.shift
        case additional_benefits
        when 'has-children-under-17'
          smart_answer.has_children = true
        when 'none-of-these'
          smart_answer.has_children = false
        end
      end

      render text: smart_answer.outcome
    end
  end
end
