require 'spec_helper'

describe "supermemo" do
  describe "next_i" do
    qs      = [5,4,3,2,1,0]
    results = [4,4,4,0,0,0]

    qs.zip(results).each do |q,result|
      it "-- next_i(#{q}, 3) = #{result}" do
        SuperMemo::next_i(q, 3).should == result
      end
    end
  end

  describe "next_interval (for i = 0)" do
    qs      = [5,4,3,2,1,0]
    results = [1,1,1,1,1,1]

    qs.zip(results).each do |q,result|
      it "-- next_interval(#{q}, 2.5, 0, 0) = #{result}" do
        SuperMemo::next_interval(q, 2.5, 0, 0).should == result
      end
    end
  end

  describe "next_interval (for i = 1)" do
    qs      = [5,4,3,2,1,0]
    results = [6,6,6,1,1,1]

    qs.zip(results).each do |q,result|
      it "-- next_interval(#{q}, 2.5, 1, 1) = #{result}" do
        SuperMemo::next_interval(q, 2.5, 1, 1).should == result
      end
    end
  end

  describe "next_interval (for i > 1)" do
    qs      = [5,4,3,2,1,0]
    results = [16,16,16,1,1,1]

    qs.zip(results).each do |q,result|
      it "-- next_interval(#{q}, 2.7, 2, 6) = #{result}" do
        SuperMemo::next_interval(q, 2.7, 2, 6).should == result
      end
    end
  end

  describe "next_interval (for changing efs)" do
    efs     = [1.3,2.0,2.5,2.6,2.7]
    results = [8,12,15,16,16]

    efs.zip(results).each do |ef,result|
      it "-- next_interval(5, #{ef}, 2, 6) = #{result}" do
        SuperMemo::next_interval(5, ef, 2, 6).should == result
      end
    end
  end

  describe "next_ef (normal)" do
    qs      = [5,4,3,2,1,0]
    results = [2.6,2.5,2.36,2.18,1.96,1.7]

    qs.zip(results).each do |q,result|
      it "-- next_ef(q, 2.5) = #{result}" do
        SuperMemo::next_ef(q, 2.5).should be_within(EPSILON).of(result)
      end
    end
  end

  describe "next_ef (minimum)" do
    qs      = [5,4,3,2,1,0]
    results = [1.4,1.3,1.3,1.3,1.3,1.3]

    qs.zip(results).each do |q,result|
      it "-- next_ef(q, 1.3) = #{result}" do
        SuperMemo::next_ef(q, 1.3).should be_within(EPSILON).of(result)
      end
    end
  end

  describe "traverse" do
    histories = [[], [5], [5,5], [5,5,5], [5,5,5,5]]
    results   = [[2.5,0,0], [2.6,1,1], [2.7,2,6], [2.8,3,16], [2.9,4,45]]

    histories.zip(results).each do |history,result|
      it "-- traverse(#{history.inspect}) = #{result.inspect}" do
        ef, i, interval = SuperMemo::traverse(history)

        ef.should be_within(EPSILON).of(result[0])
        i.should == result[1]
        interval.should == result[2]
      end
    end
  end
end
