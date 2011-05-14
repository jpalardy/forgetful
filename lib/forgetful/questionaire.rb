class Questionaire
  attr_reader :source

  def initialize(source)
    @source = source
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
        reminders[id] = reminders.fetch(id).next(q)
      end
      reminders
    end

    def reminders
      source.read
    end
end
