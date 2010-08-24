
class ReminderFile
  attr_reader :filename, :verbose

  def initialize(filename, verbose=false)
    @filename = filename
    @verbose  = verbose
  end

  def reminders
    @reminders ||= Reminder.read_csv(filename)
  end

  def write(reminders)
    raise "Writing back a different number of reminders than read from file (#{reminders.size} != #{@reminders.size})" if reminders.size != @reminders.size
    Reminder.write_csv(filename, reminders.sort)
  end

  # subtle -- reading and writing back a file will:
  # 1. validate the file
  # 2. add the date column
  # 3. sort the rows
  def touch
    puts "### TOUCH: #{filename}"
    write(reminders)
  end

  def quiz
    puts "### QUIZ: #{filename}"
    dues, not_dues = reminders.partition { |reminder| reminder.due_on <= Date.today }
    gradeds, ungradeds = quiz_map(dues.sort_by { rand })

    write(gradeds + ungradeds + not_dues)

    faileds = gradeds.select { |reminder| reminder.review? }
    until faileds.empty? || ungradeds.any?
      puts "### REVIEW: #{filename}"
      gradeds, ungradeds = quiz_map(faileds.sort_by { rand })
      faileds = gradeds.select { |reminder| reminder.review? }
    end
  end

  private
    def quiz_map(reminders)
      gradeds = []
      ungradeds = reminders.dup

      reminders.each_with_index do |reminder, i|
        q = ask(reminder, i+1, reminders.size)
        gradeds << ungradeds.shift.next(q)
      end
    rescue EOFError
      # tolerate Ctrl-D, skips the rest of the quiz
    ensure
      return gradeds, ungradeds
    end

    def ask(reminder, i, n)
      width = "#{n}/#{n}. ".size
      padding = " " * width

      print "#{i}/#{n}. ".rjust(width) + "Q: #{reminder.question}"
      readline

      puts padding + "A: #{reminder.answer}"
      puts padding + "   %.2f -> %s" % [reminder.ef, reminder.history.join] if verbose

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
