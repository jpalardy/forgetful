
require 'test/unit'
require "#{File.dirname(__FILE__)}/../lib/forgetful"


class TestReminderCSV < Test::Unit::TestCase

  def assert_equal_inspect(expected, actual)
    assert_equal expected.inspect, actual.inspect
  end

  #-------------------------------------------------

  def test_parse_csv_bare
    csv = <<END
carbon,6
nitrogen,7
oxygen,8
END

    reminders = Reminder.parse_csv(csv)

    assert_equal 3, reminders.length

    assert_equal_inspect ['carbon',  '6',Date.today, 2.5, 0, 0, nil], reminders[0].to_a
    assert_equal_inspect ['nitrogen','7',Date.today, 2.5, 0, 0, nil], reminders[1].to_a
    assert_equal_inspect ['oxygen',  '8',Date.today, 2.5, 0, 0, nil], reminders[2].to_a
  end

  def test_parse_csv_with_dates
    csv = <<END
carbon,6,2008-11-11
nitrogen,7,2008-11-11
oxygen,8,2008-11-11
END

    reminders = Reminder.parse_csv(csv)

    assert_equal 3, reminders.length

    assert_equal_inspect ['carbon',  '6',Date.parse('2008-11-11'), 2.5, 0, 0, nil], reminders[0].to_a
    assert_equal_inspect ['nitrogen','7',Date.parse('2008-11-11'), 2.5, 0, 0, nil], reminders[1].to_a
    assert_equal_inspect ['oxygen',  '8',Date.parse('2008-11-11'), 2.5, 0, 0, nil], reminders[2].to_a
  end

  def test_parse_csv_full
    csv = <<END
carbon,6,2008-11-11,2.5,0,0,
nitrogen,7,2008-11-11,2.5,0,0,
oxygen,8,2008-11-11,2.5,0,0,
END

    reminders = Reminder.parse_csv(csv)

    assert_equal 3, reminders.length

    assert_equal_inspect ['carbon',  '6',Date.parse('2008-11-11'), 2.5, 0, 0, nil], reminders[0].to_a
    assert_equal_inspect ['nitrogen','7',Date.parse('2008-11-11'), 2.5, 0, 0, nil], reminders[1].to_a
    assert_equal_inspect ['oxygen',  '8',Date.parse('2008-11-11'), 2.5, 0, 0, nil], reminders[2].to_a
  end

  ############################################################

  def test_generate_csv
    reminders = []
    reminders << Reminder.new('carbon','6')
    reminders << Reminder.new('nitrogen','7').next(5).next(5).next(5)
    reminders << Reminder.new('oxygen','8').next(1).next(1).next(1)
    reminders << Reminder.new('fluorine','9').next(1).next(5).next(1).next(5)

    expected =<<END
carbon,6,#{Date.today.to_s},2.5,0,0,
nitrogen,7,#{(Date.today+16).to_s},2.8,3,16,5
oxygen,8,#{(Date.today+1).to_s},1.3,0,1,1
fluorine,9,#{(Date.today+1).to_s},1.62,1,1,5
END

    assert_equal expected, Reminder.generate_csv(reminders)
  end

end
