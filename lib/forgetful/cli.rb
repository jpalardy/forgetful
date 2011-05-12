
class ReminderFile
  attr_reader :filename, :verbose, :delay

  def initialize(filename, verbose=false, delay=0..0)
    @filename = filename
    @verbose  = verbose
    @delay    = delay
  end

  def reminders
    @reminders ||= Reminder.read_csv(filename, delay)
  end

  def write(reminders)
    Reminder.write_csv(filename, reminders)
  end

  # subtle -- reading and writing back a file will:
  # 1. validate the file
  # 2. add the date column
  def touch
    puts "### TOUCH: #{filename}"
    write(reminders)
  end

  def quiz
    puts "### QUIZ: #{filename}"

    questions = reminders.map.with_index { |reminder, i| [reminder, i] }.
                          select { |reminder, i| reminder.due_on <= Date.today }.
                          map do |reminder,i|
                            { id:       i,
                              question: reminder.question,
                              answer:   reminder.answer }
                          end.
                          sort_by { rand }

    results = grade(questions)
    write(refresh(reminders, results))
  end

  private
    def refresh(reminders, results)
      reminders = reminders.dup
      results.each do |id,q|
        reminders[id] = reminders[id].next(q)
      end
      reminders
    end

    def grade(questions)
      results = []

      begin
        questions.each_with_index do |question, i|
          q = ask(question, i+1, questions.size)
          results << [question[:id], q]
        end
      rescue EOFError
        # tolerate Ctrl-D, skips the rest of the quiz
      end

      results
    end

    def ask(question, i, n)
      width = "#{n}/#{n}. ".size
      padding = " " * width

      print "#{i}/#{n}. ".rjust(width) + "Q: #{question[:question]}"
      readline

      puts padding + "A: #{question[:answer]}"

      while true
        print padding + "? "
        answer = readline.chomp

        if answer =~ /\A[0-5]\Z/
          puts
          return answer.to_i
        end
      end
    end
end
