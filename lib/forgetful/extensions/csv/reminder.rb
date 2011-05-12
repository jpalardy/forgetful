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
end
