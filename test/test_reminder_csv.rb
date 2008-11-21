
require 'test/unit'
require "#{File.dirname(__FILE__)}/../lib/forgetful"

class TestReminderCSV < Test::Unit::TestCase

  def test_parse_csv_bare
    csv = <<END
carbon,6
nitrogen,7
oxygen,8
END

    reminders = Reminder.parse_csv(csv)

    assert_equal 3, reminders.length

    assert_equal ['carbon',  '6',Date.today, []], reminders[0].to_a
    assert_equal ['nitrogen','7',Date.today, []], reminders[1].to_a
    assert_equal ['oxygen',  '8',Date.today, []], reminders[2].to_a
  end

  def test_parse_csv_with_dates
    csv = <<END
carbon,6,2008-11-11
nitrogen,7,2008-11-11
oxygen,8,2008-11-11
END

    reminders = Reminder.parse_csv(csv)

    assert_equal 3, reminders.length

    assert_equal ['carbon',  '6',Date.parse('2008-11-11'), []], reminders[0].to_a
    assert_equal ['nitrogen','7',Date.parse('2008-11-11'), []], reminders[1].to_a
    assert_equal ['oxygen',  '8',Date.parse('2008-11-11'), []], reminders[2].to_a
  end

  def test_parse_csv_full
    csv = <<END
carbon,6,2008-11-11,5
nitrogen,7,2008-11-11,535
oxygen,8,2008-11-11,5042
END

    reminders = Reminder.parse_csv(csv)

    assert_equal 3, reminders.length

    assert_equal ['carbon',  '6',Date.parse('2008-11-11'), [5]], reminders[0].to_a
    assert_equal ['nitrogen','7',Date.parse('2008-11-11'), [5,3,5]], reminders[1].to_a
    assert_equal ['oxygen',  '8',Date.parse('2008-11-11'), [5,0,4,2]], reminders[2].to_a
  end

  def test_parse_csv_full_with_spaces
    csv = <<END

carbon,6,2008-11-11,035


nitrogen,7,2008-11-11,55555
oxygen,8,2008-11-11,1

END

    reminders = Reminder.parse_csv(csv)

    assert_equal 3, reminders.length

    assert_equal ['carbon',  '6',Date.parse('2008-11-11'), [0,3,5]], reminders[0].to_a
    assert_equal ['nitrogen','7',Date.parse('2008-11-11'), [5,5,5,5,5]], reminders[1].to_a
    assert_equal ['oxygen',  '8',Date.parse('2008-11-11'), [1]], reminders[2].to_a
  end

  ############################################################

  def test_generate_csv
    reminders = []
    reminders << Reminder.new('carbon','6')
    reminders << Reminder.new('nitrogen','7').next(5).next(5).next(5)
    reminders << Reminder.new('oxygen','8').next(1).next(1).next(1)
    reminders << Reminder.new('fluorine','9').next(1).next(5).next(1).next(5)
    reminders << Reminder.new('neon','10',Date.today+5)

    expected =<<END
carbon,6,#{Date.today}
nitrogen,7,#{(Date.today+16)},555
oxygen,8,#{(Date.today+1)},111
fluorine,9,#{(Date.today+1)},1515
neon,10,#{(Date.today+5)}
END

    assert_equal expected, Reminder.generate_csv(reminders)
  end

end

