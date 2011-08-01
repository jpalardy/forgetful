class Reminder
  attr_reader :question, :answer, :due_on, :history

  def initialize(question, answer, due_on=Date.today, history=[])
    @question = question
    @answer = answer
    @due_on = due_on
    @history = history.dup.freeze
  end

  def to_a
    [question, answer, due_on, history]
  end
end
