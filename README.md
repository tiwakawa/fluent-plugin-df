# Fluent::Plugin::Df

Df input plugin for Fluent event collector

## Installation

Add this line to your application's Gemfile:

    gem 'fluent-plugin-df'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-df

## Usage

    <source>
      type df
      option -k
      interval 3
      tag_prefix df
      target_mounts /
    </source>

  If you specify more than one `target_mounts`, separated by spaces.

## Output Format

    df._dev_disk0s2: {"size":"487546976","used":"52533512","available":"434757464","capacity":"11"}

  Tag name is the concatenation of the name of the `tag_prefix` and file system.
  `/` in the file system is replaced by an `_`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
