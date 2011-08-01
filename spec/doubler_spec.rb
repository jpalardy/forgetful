require 'spec_helper'
require 'forgetful/algorithms/doubler'

describe "doubler" do
  describe "days" do
    it "corresponds to a doubling of days for an iteration" do
      Doubler::days(0).should == 1
      Doubler::days(1).should == 1
      Doubler::days(2).should == 2
      Doubler::days(3).should == 4
      Doubler::days(4).should == 7    #   1 week
      Doubler::days(5).should == 14   #   2 weeks
      Doubler::days(6).should == 28   #   4 weeks
      Doubler::days(7).should == 56   #   8 weeks
      Doubler::days(8).should == 112  #  16 weeks
      Doubler::days(9).should == 224  #  32 weeks
      Doubler::days(10).should == 448 #  64 weeks
      Doubler::days(11).should == 896 # 128 weeks
    end
  end

  describe "determine_i" do
    it "handles empty runs" do
      Doubler::determine_i([]).should == 0
    end

    it "counts the successes" do
      Doubler::determine_i([4]).should         == 1
      Doubler::determine_i([4,4]).should       == 2
      Doubler::determine_i([4,4,4]).should     == 3
      Doubler::determine_i([4,4,4,4]).should   == 4
      Doubler::determine_i([4,4,4,4,4]).should == 5
    end

    it "doesn't count failures" do
      Doubler::determine_i([2]).should         == 0
      Doubler::determine_i([2,2]).should       == 0
      Doubler::determine_i([2,2,2]).should     == 0
      Doubler::determine_i([2,2,2,2]).should   == 0
      Doubler::determine_i([2,2,2,2,2]).should == 0
    end

    it "counts from the back" do
      Doubler::determine_i([5,4,4,3,2,4,4,5]).should == 3
      Doubler::determine_i([5,4,4,3,2,4,4,0]).should == 0
      Doubler::determine_i([5,4,4,4,4,0,4,3]).should == 2
    end
  end

  describe "next_date" do
    before do
      @today = Date.today
    end

    it "returns a date based iterations" do
      Doubler::next_date(@today, []).should                  == @today + 1
      Doubler::next_date(@today, [4]).should                 == @today + 1
      Doubler::next_date(@today, [5,5,5]).should             == @today + 4
      Doubler::next_date(@today, [5,0,5]).should             == @today + 1
      Doubler::next_date(@today, [0,1,2,3,4,5,5,5,5]).should == @today + 28
    end
  end
end
