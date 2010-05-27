module SuperMemo
  # D_EF[q] = (0.1 - (5-q) * (0.08 + (5-q) * 0.02))
  D_EF = { 0 => -0.8,
           1 => -0.54,
           2 => -0.32,
           3 => -0.14,
           4 =>  0,
           5 =>  0.1 }

  def self.next_ef(q, ef)
    [ef + D_EF[q], 1.3].max
  end

  def self.next_i(q, i)
    return 0 if q < 3

    i+1
  end

  def self.next_interval(q, ef, i, interval)
    return 1 if q < 3

    case i
    when 0 then 1
    when 1 then 6
    else        (interval * ef).round
    end
  end

  #      [] -> 2.5, 0, 0
  # [5,5,5] -> 2.8, 3, 16
  def self.traverse(qs, ef=2.5, i=0, interval=0)
    return [ef, i, interval] if qs.empty?

    q = qs.first
    return traverse(qs[1..-1], next_ef(q, ef), next_i(q, i), next_interval(q, ef, i, interval))
  end

  def self.next_date(date, qs)
    ef, i, interval = traverse(qs)
    return date + interval
  end
end
