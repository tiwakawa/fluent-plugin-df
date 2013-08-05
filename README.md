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
      option -k              # df command options
      interval 3             # execution interval of the df command
      tag_prefix df          # prefix of tag
      target_mounts /        # "Mounted on" to filter the information you want to retrieve
      replace_slash true     # whether to replace '_' by '/' in the file system
      # tag free_disk        # tag (default is nil)
      rm_percent true        # delete the percentage mark of capacity
      hostname true          # add to the record the results of the hostname command
    </source>

  If you specify more than one `target_mounts`, separated by spaces.

## Output Format

    2013-03-01 00:00:00 +0900 df._dev_disk0s2: {"size":"487546976","used":"52533512","available":"434757464","capacity":"11","hostname":"my.local"}

  If `tag` specified, character of `tag` is the Tag name.

  Otherwise, Tag name is the concatenation of the name of the `tag_prefix` and file system.

  `/` in the file system is replaced by an `_`, if `replace_slash` is true.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
