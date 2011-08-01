class Questionaire
  attr_reader :source, :algorithm

  def initialize(source, algorithm=SuperMemo)
    @source    = source
    @algorithm = algorithm
  end

  def questions
    i = 0
    reminders.map    { |reminder|    pair = [reminder, i]; i+=1; pair }.
              select { |reminder, i| reminder.due_on <= Date.today }.
              map do   |reminder, i|
                { :id       => i,
                  :question => reminder.question,
                  :answer   => reminder.answer }
              end
  end

  def grade(results)
    source.write(update(reminders, results))
  end

  #-------------------------------------------------
  private
    # results is a list of pairs: [id, q]
    def update(reminders, results)
      reminders = reminders.dup
      results.each do |id,q|
        reminders[id] = next_reminder(reminders.fetch(id), q)
      end
      reminders
    end

    def next_reminder(reminder, q)
      next_history = reminder.history + [q]
      next_date    = @algorithm::next_date(Date.today, next_history)
      Reminder.new(reminder.question, reminder.answer, next_date, next_history)
    end

    def reminders
      source.read
    end
end
