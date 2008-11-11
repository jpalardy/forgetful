
require 'rubygems'
require 'fastercsv'

class Reminder

  def self.load_csv(filename)
    identity = lambda {|x| x}

    FasterCSV.read(filename, :converters => [identity, identity, :integer, :integer, :date, :float, :integer]).collect do |list|
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

