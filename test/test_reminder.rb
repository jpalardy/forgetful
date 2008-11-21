
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
    assert_equal Date.today, @carbon_question.due_on
    assert_equal [],         @carbon_question.history
  end

  def test_minium_array
    assert_equal ['carbon', '6', Date.today, []], @carbon_question.to_a
  end

  #-------------------------------------------------

  def test_history_cannot_be_changed
    history = [5,4,2]

    reminder = Reminder.new('carbon','6',Date.today, history)

    assert_equal [5,4,2], reminder.history

    assert_raise_message TypeError, /can't modify frozen array/ do
      @carbon_question.history.push(5)
    end

    history.push(5)

    assert_equal [],         @carbon_question.history
  end

  #-------------------------------------------------

  def test_next_clamped
    assert_equal ['carbon', '6', Date.today+1, [1]], @carbon_question.next(1).to_a
    assert_equal ['carbon', '6', Date.today+1, [4]], @carbon_question.next(4).to_a
  end

  def test_next_unclamped
    reminder = Reminder.new('carbon', '6', Date.today, [5,5])

    assert_equal ['carbon', '6',  Date.today+1, [5,5,1]], reminder.next(1).to_a
    assert_equal ['carbon', '6', Date.today+16, [5,5,4]], reminder.next(4).to_a
  end

  #-------------------------------------------------

  def test_review
    assert_equal  true, @carbon_question.review?
    assert_equal  true, @carbon_question.next(0).review?
    assert_equal  true, @carbon_question.next(1).review?
    assert_equal  true, @carbon_question.next(2).review?
    assert_equal  true, @carbon_question.next(3).review?
    assert_equal false, @carbon_question.next(4).review?
    assert_equal false, @carbon_question.next(5).review?

    assert_equal  true, @carbon_question.next(5).next(0).review?
    assert_equal  true, @carbon_question.next(5).next(1).review?
    assert_equal  true, @carbon_question.next(5).next(2).review?
    assert_equal  true, @carbon_question.next(5).next(3).review?
    assert_equal false, @carbon_question.next(5).next(4).review?
    assert_equal false, @carbon_question.next(5).next(5).review?
  end

end

