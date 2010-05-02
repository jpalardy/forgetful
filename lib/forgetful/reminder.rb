class Reminder
  attr_reader :question, :answer, :due_on, :history

  def initialize(question, answer, due_on=Date.today, history=[])
    @question = question
    @answer = answer
    @due_on = due_on
    @history = history.dup.freeze
  end

  def next(q)
    Reminder.new(self.question, self.answer, SuperMemo::next_date(Date.today, self.history + [q]), self.history + [q])
  end

  def to_a
    [self.question, self.answer, self.due_on, self.history]
  end

  def <=>(other)
    self.to_a <=> other.to_a
  end

  def review?
    (self.history.last || 0) < 4
  end
end
