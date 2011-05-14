require 'forgetful/extensions/csv/reminder'

class ReminderFile
  attr_reader :filename, :delay

  def initialize(filename, delay=0..0)
    @filename = filename
    @delay    = delay
  end

  def read
    File.open(filename) do |file|
      parse_csv(file)
    end
  end

  def write(reminders)
    data = CSV.generate do |csv|
             reminders.each do |reminder|
               csv << reminder.to_csv
             end
           end

    File.open(filename, "w") do |file|
      file.write(data)
    end
  end

  private
    def parse_csv(io)
      converters = [lambda { |question| question },
                    lambda { |answer|   answer },
                    lambda { |due_on|   Date.parse(due_on) },
                    lambda { |history|  history.scan(/./).map { |x| x.to_i } }]

      CSV.parse(io, :skip_blanks => true).map do |list|
        list = list.zip(converters).map { |col, converter| converter[col] }
        list << Date.today + rand_from_range(delay) if list.length == 2 # missing date
        Reminder.new(*list)
      end
    end

    def rand_from_range(range)
      if RUBY_VERSION < '1.9'
        (range.min + (range.max - range.min + 1) * rand).floor
      else
        Random.new.rand(range)
      end
    end
end
