
require 'test/unit'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'forgetful'

class TestReminder < Test::Unit::TestCase

  def test_next_i
    qs = [5,4,3,2,1,0]
    results = [4,4,4,0,0,0]

    qs.zip(results).each do |q,result|
      assert_equal result, SuperMemo::next_i(q, 3), "next_i for q=#{q} when i=3"
    end
  end

  def test_next_interval_normal
    qs = [5,4,3,2,1,0]
    results = [16,16,16,1,1,1]

    qs.zip(results).each do |q,result|
      assert_equal result, SuperMemo::next_interval(q, 2.7, 2, 6), "next_interval for q=#{q}"
    end
  end

  def test_next_interval_for_i0
    qs = [5,4,3,2,1,0]
    results = [1,1,1,1,1,1]

    qs.zip(results).each do |q,result|
      assert_equal result, SuperMemo::next_interval(q, 2.5, 0, 0), "next_interval for q=#{q}"
    end
  end

  def test_next_interval_for_i1
    qs = [5,4,3,2,1,0]
    results = [6,6,6,1,1,1]

    qs.zip(results).each do |q,result|
      assert_equal result, SuperMemo::next_interval(q, 2.5, 1, 1), "next_interval for q=#{q}"
    end
  end

  def test_next_interval_for_changing_efs
    efs = [1.3, 2.0, 2.5, 2.6, 2.7]
    results = [8,12,15,16,16]

    efs.zip(results).each do |ef,result|
      assert_equal result, SuperMemo::next_interval(5, ef, 2, 6), "next_interval for ef=#{ef}"
    end
  end

  def test_next_ef_normal
    qs = [5,4,3,2,1,0]
    results = [2.6,2.5,2.36,2.18,1.96,1.7]

    qs.zip(results).each do |q,result|
      assert_in_delta result, SuperMemo::next_ef(q, 2.5), 0.00001, "next_ef for q=#{q}"
    end
  end

  def test_next_ef_minimum
    qs = [5,4,3,2,1,0]
    results = [1.4,1.3,1.3,1.3,1.3,1.3]

    qs.zip(results).each do |q,result|
      assert_in_delta result, SuperMemo::next_ef(q, 1.3), 0.00001, "next_ef for q=#{q}"
    end
  end

  #-------------------------------------------------

  def assert_equal_inspect(expected, actual)
    assert_equal expected.inspect, actual.inspect
  end

  def test_traverse
    assert_equal_inspect [2.5, 0, 0], SuperMemo::traverse([])
    assert_equal_inspect [2.6, 1, 1], SuperMemo::traverse([5])
    assert_equal_inspect [2.7, 2, 6], SuperMemo::traverse([5,5])
    assert_equal_inspect [2.8, 3, 16], SuperMemo::traverse([5,5,5])
    assert_equal_inspect [2.9, 4, 45], SuperMemo::traverse([5,5,5,5])
  end

end

