# Fluent::Plugin::Df

TODO: Write a gem description

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
      df_path /bin/df
      option -k
      interval 3
      tag_prefix df.
      target_mounts /
    </source>

  If you specify more than one `target_mounts`, separated by commas.

## Output Format

    df._dev_disk0s2: {"size":"487546976","used":"52533512","avail":"434757464","capacity":"0.11"}

  Tag name is the concatenation of the name of the `tag_prefix` and file system.
  `/` in the file system is replaced by an `_`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
