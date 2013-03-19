require 'helper'

class DfInputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  CONFIG = %[
    df_path       /bin/df
    option        -k
    interval      3
    tag_prefix    df.
    target_mounts /
  ]

  def create_driver(conf=CONFIG)
    Fluent::Test::InputTestDriver.new(Fluent::DfInput).configure(conf)
  end

  def test_configure
    d = create_driver
    assert_equal "/bin/df", d.instance.df_path
    assert_equal "-k",      d.instance.option
    assert_equal "df.",     d.instance.tag_prefix
    assert_equal 3,         d.instance.interval
    assert_equal "/",       d.instance.target_mounts
  end

  def test_emit
    # TODO
  end
end
