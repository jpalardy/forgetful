class Reminder
  attr_reader :question, :answer, :due_on, :history

  def initialize(question, answer, due_on=Date.today, history=[])
    @question = question
    @answer = answer
    @due_on = due_on
    @history = history.dup.freeze
  end

  def next(q)
    new_history = history + [q]
    Reminder.new(question, answer, SuperMemo::next_date(Date.today, new_history), new_history)
  end

  def to_a
    [question, answer, due_on, history]
  end

  def <=>(other)
    to_a <=> other.to_a
  end

  def review?
    history.empty? || history.last < 4
  end
end
