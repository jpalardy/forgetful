
require 'rubygems'
require 'fastercsv'

class Reminder

  def self.read_csv(filename)
    File.open(filename) do |file|
      self.parse_csv(file)
    end
  end

  def self.parse_csv(io)
    converters = [lambda {|question|   question},
                  lambda {|answer|     answer},
                  lambda {|execute_on| Date.parse(execute_on)},
                  lambda {|ef|         ef.to_f},
                  lambda {|i|          i.to_i},
                  lambda {|interval|   interval.to_i},
                  lambda {|q|          q.nil? ? q : q.to_i}]

    FasterCSV.parse(io).collect do |list|
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
    FasterCSV.generate do |csv|
      reminders.each do |reminder|
        csv << reminder.to_a
      end
    end
  end

end

