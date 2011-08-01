require 'spec_helper'
require 'forgetful/questionaire'

describe "questionaire" do
  describe "source" do
    before do
      @source = double("source", :read => [])
      @questionaire = Questionaire.new(@source)
    end

    it "should be pulled" do
      @source.should_receive(:read).once
      @questionaire.questions
    end

    it "should be pushed" do
      @source.should_receive(:read).once
      @source.should_receive(:write).once
      @questionaire.grade([])
    end
  end

  describe "reminders" do
    before do
      @reminder1 = double("reminder1", :due_on => Date.today,       :question => "some question",    :answer => "some answer")
      @reminder2 = double("reminder2", :due_on => (Date.today - 1), :question => "another question", :answer => "another answer")
      @reminder3 = double("reminder3", :due_on => (Date.today + 1), :question => "final question",   :answer => "final answer")
      @source = double("source", :read => [@reminder1, @reminder2, @reminder3])

      @questionaire = Questionaire.new(@source)
    end

    it "should be converted" do
      @questionaire.questions.should == [{:question=>"some question", :answer=>"some answer", :id=>0}, {:question=>"another question", :answer=>"another answer", :id=>1}]
    end

    it "should be adjusted" do
      @reminder2_1 = double("reminder2_1")
      @questionaire.stub(:next_reminder) { @reminder2_1 }

      @source.should_receive(:write).once.with([@reminder1, @reminder2_1, @reminder3])
      @questionaire.grade([[1, 3]])
    end

    it "should raise on unknown indices" do
      expect{ @questionaire.grade([[42, 3]]) }.to raise_error(IndexError)
    end
  end
end
