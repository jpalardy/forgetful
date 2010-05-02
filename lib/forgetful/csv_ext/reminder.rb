
require "csv"
if CSV.const_defined? :Reader
  # Ruby 1.8 compatible
  require 'rubygems'
  require 'fastercsv'
  Object.send(:remove_const, :CSV)
  CSV = FasterCSV
end

class Reminder

  def self.read_csv(filename)
    File.open(filename) do |file|
      self.parse_csv(file)
    end
  end

  def self.parse_csv(io)
    converters = [lambda {|question|   question},
                  lambda {|answer|     answer},
                  lambda {|due_on|     Date.parse(due_on)},
                  lambda {|history|    history.scan(/./).collect {|x| x.to_i}}
                  ]

    CSV.parse(io, :skip_blanks => true).collect do |list|
      list = list.zip(converters).collect {|col, converter| converter[col]}
      self.new(*list)
    end
  end

  ############################################################

  def self.write_csv(filename, reminders)
    File.open(filename, "w") do |file|
      file.write(generate_csv(reminders))
    end
  end

  def self.generate_csv(reminders)
    CSV.generate do |csv|
      reminders.each do |reminder|
        if reminder.history.empty?
          csv << reminder.to_a.first(3)
        else
          csv << reminder.to_a
        end
      end
    end
  end

end

