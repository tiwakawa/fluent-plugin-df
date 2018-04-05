require 'bundler'
require 'test/unit'

$LOAD_PATH.unshift(File.join(__dir__, '..', 'lib'))
$LOAD_PATH.unshift(__dir__)

require 'fluent/test'
require 'fluent/test/driver/input'
require 'fluent/plugin/in_df'
