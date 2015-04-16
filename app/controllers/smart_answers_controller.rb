class SmartAnswersController < ApplicationController
  TOTAL_NUMBER_OF_QUESTIONS = 4

  def show
    if response = params[:response]
      redirect_to url_for + '/' + response
      return
    end

    responses = String(params[:responses]).split('/')

    question_to_render = responses.length + 1
    if question_to_render <= TOTAL_NUMBER_OF_QUESTIONS
      render "question_#{question_to_render}"
    else
      render text: 'All done'
    end
  end
end
