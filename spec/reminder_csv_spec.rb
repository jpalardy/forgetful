require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "reminder (csv)" do
  describe "parsing the bare format" do
    before do
      csv = <<END
carbon,6
nitrogen,7
oxygen,8
END
      @reminders = Reminder.parse_csv(csv)
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

  describe "parsing the full format" do
    before do
      csv = <<END
carbon,6,2008-11-11,5
nitrogen,7,2008-11-11,535

oxygen,8,2008-11-11,5042
END
      @reminders = Reminder.parse_csv(csv)
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

  describe "generating csv" do
    before do
      @reminders = []
      @reminders << Reminder.new('carbon','6')
      @reminders << Reminder.new('nitrogen','7').next(5).next(5).next(5)
      @reminders << Reminder.new('oxygen','8').next(1).next(1).next(1)
      @reminders << Reminder.new('fluorine','9').next(1).next(5).next(1).next(5)
      @reminders << Reminder.new('neon','10',Date.today+5)
    end

    it "should generate appropriate csv" do
      Reminder.generate_csv(@reminders).should == <<END
carbon,6,#{Date.today}
nitrogen,7,#{(Date.today+16)},555
oxygen,8,#{(Date.today+1)},111
fluorine,9,#{(Date.today+1)},1515
neon,10,#{(Date.today+5)}
END
    end
  end
end
