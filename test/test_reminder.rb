
require 'test/unit'
require "#{File.dirname(__FILE__)}/../lib/forgetful"


class TestReminder < Test::Unit::TestCase

  def assert_raise_message(error, re)
    exception = assert_raise(error) do
      yield
    end
    assert_match re, exception.message
  end

  #-------------------------------------------------

  def assert_equal_inspect(expected, actual)
    assert_equal expected.inspect, actual.inspect
  end

  def setup
    @carbon_question = Reminder.new 'carbon', '6'
  end

  #-------------------------------------------------

  def test_empty
    assert_raise_message ArgumentError, /wrong number of arguments \(0 for 2\)/ do
      Reminder.new
    end
  end

  def test_just_question
    assert_raise_message ArgumentError, /wrong number of arguments \(1 for 2\)/ do
      Reminder.new 'carbon'
    end
  end

  #-------------------------------------------------

  def test_minimum
    assert_equal 'carbon',   @carbon_question.question
    assert_equal '6',        @carbon_question.answer
    assert_equal Date.today, @carbon_question.execute_on
    assert_equal 2.5,        @carbon_question.ef
    assert_equal 0,          @carbon_question.i
    assert_equal 0,          @carbon_question.interval
    assert_equal nil,        @carbon_question.q
  end

  def test_minium_array
    assert_equal ['carbon', '6', Date.today, 2.5, 0, 0, nil], [@carbon_question.question, @carbon_question.answer, @carbon_question.execute_on, @carbon_question.ef, @carbon_question.i, @carbon_question.interval, @carbon_question.q]
  end

  #-------------------------------------------------

  def test_next
    assert_equal_inspect ['carbon', '6', Date.today+1,  1.7, 0, 1, 0], @carbon_question.next(0).to_a
    assert_equal_inspect ['carbon', '6', Date.today+1, 1.96, 0, 1, 1], @carbon_question.next(1).to_a
    assert_equal_inspect ['carbon', '6', Date.today+1, 2.18, 0, 1, 2], @carbon_question.next(2).to_a
    assert_equal_inspect ['carbon', '6', Date.today+1, 2.36, 1, 1, 3], @carbon_question.next(3).to_a
    assert_equal_inspect ['carbon', '6', Date.today+1,  2.5, 1, 1, 4], @carbon_question.next(4).to_a
    assert_equal_inspect ['carbon', '6', Date.today+1,  2.6, 1, 1, 5], @carbon_question.next(5).to_a
  end

  def test_next_after_0
    assert_equal_inspect ['carbon', '6', Date.today+1,  1.3, 0, 1, 0], @carbon_question.next(0).next(0).to_a
    assert_equal_inspect ['carbon', '6', Date.today+1,  1.3, 0, 1, 1], @carbon_question.next(0).next(1).to_a
    assert_equal_inspect ['carbon', '6', Date.today+1, 1.38, 0, 1, 2], @carbon_question.next(0).next(2).to_a
    assert_equal_inspect ['carbon', '6', Date.today+1, 1.56, 1, 1, 3], @carbon_question.next(0).next(3).to_a
    assert_equal_inspect ['carbon', '6', Date.today+1,  1.7, 1, 1, 4], @carbon_question.next(0).next(4).to_a
    assert_equal_inspect ['carbon', '6', Date.today+1,  1.8, 1, 1, 5], @carbon_question.next(0).next(5).to_a
  end

  def test_next_after_1
    assert_equal_inspect ['carbon', '6', Date.today+1,  1.3, 0, 1, 0], @carbon_question.next(1).next(0).to_a
    assert_equal_inspect ['carbon', '6', Date.today+1, 1.42, 0, 1, 1], @carbon_question.next(1).next(1).to_a
    assert_equal_inspect ['carbon', '6', Date.today+1, 1.64, 0, 1, 2], @carbon_question.next(1).next(2).to_a
    assert_equal_inspect ['carbon', '6', Date.today+1, 1.82, 1, 1, 3], @carbon_question.next(1).next(3).to_a
    assert_equal_inspect ['carbon', '6', Date.today+1, 1.96, 1, 1, 4], @carbon_question.next(1).next(4).to_a
    assert_equal_inspect ['carbon', '6', Date.today+1, 2.06, 1, 1, 5], @carbon_question.next(1).next(5).to_a
  end

  def test_next_after_2
    assert_equal_inspect ['carbon', '6', Date.today+1, 1.38, 0, 1, 0], @carbon_question.next(2).next(0).to_a
    assert_equal_inspect ['carbon', '6', Date.today+1, 1.64, 0, 1, 1], @carbon_question.next(2).next(1).to_a
    assert_equal_inspect ['carbon', '6', Date.today+1, 1.86, 0, 1, 2], @carbon_question.next(2).next(2).to_a
    assert_equal_inspect ['carbon', '6', Date.today+1, 2.04, 1, 1, 3], @carbon_question.next(2).next(3).to_a
    assert_equal_inspect ['carbon', '6', Date.today+1, 2.18, 1, 1, 4], @carbon_question.next(2).next(4).to_a
    assert_equal_inspect ['carbon', '6', Date.today+1, 2.28, 1, 1, 5], @carbon_question.next(2).next(5).to_a
  end

  def test_next_after_3
    assert_equal_inspect ['carbon', '6', Date.today+1, 1.56, 0, 1, 0], @carbon_question.next(3).next(0).to_a
    assert_equal_inspect ['carbon', '6', Date.today+1, 1.82, 0, 1, 1], @carbon_question.next(3).next(1).to_a
    assert_equal_inspect ['carbon', '6', Date.today+1, 2.04, 0, 1, 2], @carbon_question.next(3).next(2).to_a
    assert_equal_inspect ['carbon', '6', Date.today+6, 2.22, 2, 6, 3], @carbon_question.next(3).next(3).to_a
    assert_equal_inspect ['carbon', '6', Date.today+6, 2.36, 2, 6, 4], @carbon_question.next(3).next(4).to_a
    assert_equal_inspect ['carbon', '6', Date.today+6, 2.46, 2, 6, 5], @carbon_question.next(3).next(5).to_a
  end

  def test_next_after_4
    assert_equal_inspect ['carbon', '6', Date.today+1,  1.7, 0, 1, 0], @carbon_question.next(4).next(0).to_a
    assert_equal_inspect ['carbon', '6', Date.today+1, 1.96, 0, 1, 1], @carbon_question.next(4).next(1).to_a
    assert_equal_inspect ['carbon', '6', Date.today+1, 2.18, 0, 1, 2], @carbon_question.next(4).next(2).to_a
    assert_equal_inspect ['carbon', '6', Date.today+6, 2.36, 2, 6, 3], @carbon_question.next(4).next(3).to_a
    assert_equal_inspect ['carbon', '6', Date.today+6,  2.5, 2, 6, 4], @carbon_question.next(4).next(4).to_a
    assert_equal_inspect ['carbon', '6', Date.today+6,  2.6, 2, 6, 5], @carbon_question.next(4).next(5).to_a
  end

  def test_next_after_5
    assert_equal_inspect ['carbon', '6', Date.today+1,  1.8, 0, 1, 0], @carbon_question.next(5).next(0).to_a
    assert_equal_inspect ['carbon', '6', Date.today+1, 2.06, 0, 1, 1], @carbon_question.next(5).next(1).to_a
    assert_equal_inspect ['carbon', '6', Date.today+1, 2.28, 0, 1, 2], @carbon_question.next(5).next(2).to_a
    assert_equal_inspect ['carbon', '6', Date.today+6, 2.46, 2, 6, 3], @carbon_question.next(5).next(3).to_a
    assert_equal_inspect ['carbon', '6', Date.today+6,  2.6, 2, 6, 4], @carbon_question.next(5).next(4).to_a
    assert_equal_inspect ['carbon', '6', Date.today+6,  2.7, 2, 6, 5], @carbon_question.next(5).next(5).to_a
  end

  #-------------------------------------------------

  # will ask tomorrow?
  def test_fail_after_long_interval
    oxygen_question = Reminder.new('oxygen', '8', Date.today, 3.2, 7, 393)
    assert_equal_inspect ['oxygen', '8', Date.today+1,  2.4, 0, 1, 0], oxygen_question.next(0).to_a
  end

end
