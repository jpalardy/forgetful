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

    it "should have an ef of 2.5" do
      @reminder.ef.should be_within(EPSILON).of(2.5)
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

    it "should have an ef of 2.8 (based on history)" do
      @reminder.ef.should be_within(EPSILON).of(2.8)
    end
  end

  describe "next" do
    before do
      @quality = 5
      @reminder = Reminder.new(@question, @answer, @due_on, @history)
    end

    it "should create a new reminder scheduled appropriately" do
      @reminder.next(@quality).to_a.should == [@question, @answer, Date.today+45, @history + [@quality]]
    end
  end

  describe "review (w/o history)" do
    subject { Reminder.new(@question, @answer) }

    it { should be_review}
  end

  describe "review (w/ history)" do
    before do
      @reminder = Reminder.new(@question, @answer, @due_on, @history)
    end

    it "should qualify for review if quality < 4" do
      @reminder.next(0).should be_review
      @reminder.next(1).should be_review
      @reminder.next(2).should be_review
      @reminder.next(3).should be_review
      @reminder.next(4).should_not be_review
      @reminder.next(5).should_not be_review
    end
  end
end
