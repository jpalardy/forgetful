require 'spec_helper'
require 'forgetful/extensions/csv/reminder'

describe "reminder_csv" do
  before do
    @question = "some question"
    @answer   = "some answer"
    @date     = Date.today + 1
  end

  it "should handle 2 fields" do
    reminder = Reminder.new(@question, @answer)
    reminder.to_csv.should == [@question, @answer, Date.today.to_s]
  end

  it "should handle 3 fields" do
    reminder = Reminder.new(@question, @answer, @date)
    reminder.to_csv.should == [@question, @answer, @date.to_s]
  end

  it "should handle 4 fields" do
    reminder = Reminder.new(@question, @answer, @date, [1,2,3])
    reminder.to_csv.should == [@question, @answer, @date.to_s, "123"]
  end
end
