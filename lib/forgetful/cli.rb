
class ReminderFile
  attr_reader :filename

  def initialize(filename)
    @filename = filename
  end

  def reminders
    @reminders ||= Reminder.read_csv(filename)
  end

  def reminders=(reminders)
    Reminder.write_csv(filename, reminders.sort)
  end

  # subtle -- reading and writing back a file will:
  # 1. validate the file
  # 2. add the date column
  # 3. sort the rows
  def touch
    puts "### TOUCH: #{filename}"
    self.reminders = reminders
  end

  def quiz
    puts "### QUIZ: #{filename}"
    dues, not_dues = reminders.partition { |reminder| reminder.due_on <= Date.today }
    gradeds = quiz_map(dues.sort_by { rand })

    self.reminders = gradeds + not_dues

    faileds = gradeds.select { |reminder| reminder.review? }
    until faileds.empty?
      puts "### REVIEW: #{filename}"
      gradeds = quiz_map(faileds.sort_by { rand })
      faileds = gradeds.select { |reminder| reminder.review? }
    end
  end

  private
    def quiz_map(reminders)
      reminders.zip(1..reminders.length).map do |reminder, i|
        q = ask(reminder, i, reminders.size)
        reminder.next(q)
      end
    end

    def ask(reminder, i, n)
      width = "#{n}/#{n}. ".size
      padding = " " * width

      print "#{i}/#{n}. ".rjust(width) + "Q: #{reminder.question}"
      readline

      puts padding + "A: #{reminder.answer}"

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
