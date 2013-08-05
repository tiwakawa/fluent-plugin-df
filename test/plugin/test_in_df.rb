require 'helper'

class DfInputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  CONFIG = %[
    option        -k
    interval      3
    tag_prefix    df
    target_mounts /
    replace_slash true
    tag           free_disk
    rm_percent    true
    hostname      false
  ]

  def create_driver(conf=CONFIG)
    Fluent::Test::InputTestDriver.new(Fluent::DfInput).configure(conf)
  end

  def test_configure
    d = create_driver
    assert_equal "-k",        d.instance.option
    assert_equal "df",        d.instance.tag_prefix
    assert_equal 3,           d.instance.interval
    assert_equal "/",         d.instance.target_mounts
    assert_equal true,        d.instance.replace_slash
    assert_equal "free_disk", d.instance.tag
    assert_equal true,        d.instance.rm_percent
    assert_equal false,       d.instance.hostname
  end

#  def test_emit
#  end
end
