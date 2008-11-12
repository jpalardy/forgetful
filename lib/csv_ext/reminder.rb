
require 'rubygems'
require 'fastercsv'

class Reminder

  def self.load_csv(filename)
    identity = lambda {|x| x}

    #                                        question  answer    next   ef      i         interval  q
    FasterCSV.read(filename, :converters => [identity, identity, :date, :float, :integer, :integer, :integer]).collect do |list|
      self.new(*list)
    end
  end

  def self.save_csv(filename, reminders)
    FasterCSV.open(filename, "w") do |csv|
      reminders.each do |reminder|
        csv << reminder.to_a
      end
    end
  end

end

