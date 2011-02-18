require "csv"
if CSV.const_defined? :Reader
  # Ruby 1.8 compatible
  require 'rubygems'
  require 'fastercsv'
  Object.send(:remove_const, :CSV)
  CSV = FasterCSV
end

class Reminder
  def to_csv
    if history.empty?
      [question, answer, due_on.to_s]
    else
      [question, answer, due_on.to_s, history.join]
    end
  end

  def self.read_csv(filename, delay=0..0)
    File.open(filename) do |file|
      self.parse_csv(file, delay)
    end
  end

  def self.parse_csv(io, delay=0..0)
    converters = [lambda { |question| question },
                  lambda { |answer|   answer },
                  lambda { |due_on|   Date.parse(due_on) },
                  lambda { |history|  history.scan(/./).map { |x| x.to_i } }]

    CSV.parse(io, :skip_blanks => true).map do |list|
      list = list.zip(converters).map { |col, converter| converter[col] }
      list << Date.today + Random.new.rand(delay) if list.length == 2 # missing date
      new(*list)
    end
  end

  def self.write_csv(filename, reminders)
    File.open(filename, "w") do |file|
      file.write(generate_csv(reminders))
    end
  end

  def self.generate_csv(reminders)
    CSV.generate do |csv|
      reminders.each do |reminder|
        csv << reminder.to_csv
      end
    end
  end
end
