module Doubler
  def self.days(i)
    case i
    when 0 then 1
    when 1 then 1
    when 2 then 2
    when 3 then 4
    when 4 then 7 # we cheat, exactly a week -- should be 8
    else
      (2 ** (i - 4)) * 7 # specific number of week
    end
  end

  def self.determine_i(qs)
    i = 0
    qs.reverse_each do |q|
      if q >= 3
        i += 1
      else
        break
      end
    end
    i
  end

  def self.next_date(date, qs)
    i = determine_i(qs)
    date + days(i)
  end
end
