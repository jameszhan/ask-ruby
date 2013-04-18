module AnswersHelper
  def sloved(question,answers)
    answers.each_index do |i|
      if question.answered_with == answers[i]
        @index = i
      end
    end
    sloved_answer = answers.delete_at(@index)
    answers.unshift(sloved_answer)
  end
end
