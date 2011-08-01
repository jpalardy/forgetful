require 'spec_helper'

describe "reminder" do
  before do
    @question = 'carbon'
    @answer   = '6'
    @due_on   = Date.today - 2
    @history  = [5,5,5]
  end

  describe "with default constructor" do
    before do
      @reminder = Reminder.new(@question, @answer)
    end

    it "should be valid" do
      @reminder.to_a.should == [@question, @answer, Date.today, []]
    end
  end

  describe "with full constructor" do
    before do
      @reminder = Reminder.new(@question, @answer, @due_on, @history)
    end

    it "should be valid" do
      @reminder.to_a.should == [@question, @answer, @due_on, @history]
    end

    it "should not allow its history to be modified" do
      error_type = RUBY_VERSION =~ /^1.8/ ? TypeError : RuntimeError
      lambda {
        @reminder.history.push(5)
      }.should raise_error(error_type, "can't modify frozen array")
    end
  end
end
