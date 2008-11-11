
class Reminder
  attr_reader :question, :answer, :i, :interval, :execute_on, :ef, :q

  def initialize(question, answer, i=0, interval=0, execute_on=Date.today, ef=2.5, q=nil)
    @question = question
    @answer = answer
    @i = i
    @interval = interval
    @execute_on = execute_on
    @ef = ef
    @q = q
  end

  def next(q)
    if q < 3
      i = 0
      interval = 1
    else
      i = self.i + 1
      interval = {0 => 1, 1 => 6}.fetch(self.i, self.interval * self.ef).round
    end

    execute_on = Date.today + interval

    ef = self.ef + (0.1 - (5-q) * (0.08 + (5-q) * 0.02))
    ef = [ef, 1.3].max

    Reminder.new(self.question, self.answer, i, interval, execute_on, ef, q)
  end

  def to_a
    [self.question, self.answer, self.i, self.interval, self.execute_on, self.ef, self.q]
  end

  def <=>(other)
    self.to_a <=> other.to_a
  end

  def review?
    q < 4
  end

end

