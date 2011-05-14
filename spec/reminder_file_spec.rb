require 'spec_helper'
require 'forgetful/extensions/csv/reminder_file'

describe "reminder file parsing (csv)" do
  before do
    @filename = "DUMMY"
  end

  describe "parsing the bare format" do
    before do
      csv = <<END
carbon,6
nitrogen,7
oxygen,8
END
      @reminder_file = ReminderFile.new(@filename)
      @reminders = @reminder_file.send(:parse_csv, csv)
    end

    it "should have the right number of lines" do
      @reminders.size.should == 3
    end

    it "should have the right data" do
      @reminders[0].to_a.should == ['carbon',  '6',Date.today, []]
      @reminders[1].to_a.should == ['nitrogen','7',Date.today, []]
      @reminders[2].to_a.should == ['oxygen',  '8',Date.today, []]
    end
  end

  describe "parsing the bare format (with delay)" do
    before do
      @csv = <<END
carbon,6
END
      @reminder_file = ReminderFile.new(@filename, 3..7)
      @date_range = (Date.today + 3)..(Date.today + 7)
    end

    it "should have dates in the given range" do
      100.times do
        reminder = @reminder_file.send(:parse_csv, @csv).first
        @date_range.should include(reminder.due_on)
      end
    end
  end

  describe "parsing the full format" do
    before do
      csv = <<END
carbon,6,2008-11-11,5
nitrogen,7,2008-11-11,535

oxygen,8,2008-11-11,5042
END
      @reminder_file = ReminderFile.new(@filename)
      @reminders = @reminder_file.send(:parse_csv, csv)
    end

    it "should have the right number of lines" do
      @reminders.size.should == 3
    end

    it "should have the right data" do
      @reminders[0].to_a.should == ['carbon',  '6',Date.parse('2008-11-11'), [5]]
      @reminders[1].to_a.should == ['nitrogen','7',Date.parse('2008-11-11'), [5,3,5]]
      @reminders[2].to_a.should == ['oxygen',  '8',Date.parse('2008-11-11'), [5,0,4,2]]
    end
  end
end
