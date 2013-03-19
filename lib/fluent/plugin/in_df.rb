module Fluent
  class DfInput < Fluent::Input
    Fluent::Plugin.register_input('df', self)

    config_param :command,       :string,  default: '/bin/df'
    config_param :option,        :string,  default: '-k'
    config_param :interval,      :integer, default: 3
    config_param :prefix_tag,    :string,  default: 'perf.'
    config_param :ignore_record, :string,  default: '^tmpfs'

    def configure(conf)
      super
      @command = "#{@command} #{@option}"
    end

    def start
      super
      @watcher = Thread.new(&method(:watch))
    end

    def shutdown
      super
      @watcher.terminate
      @watcher.join
    end

    private
    def df
      fss = `#{@command}`.split($/)
      fss.shift # remove header
      fss.reject! { |x| x =~ /#{@ignore_record}/ }
      fss.map do |fs|
        f = fs.split(/\s+/)
        { 'fs'       => f[0].gsub(/\//, '_'),
          'size'     => f[1],
          'used'     => f[2],
          'avail'    => f[3],
          'capacity' => f[4].delete('%').to_f / 100
        }
      end
    end

    def watch
      while true
        df.each do |result|
          fs = result.delete('fs')
          Fluent::Engine.emit("#{@prefix_tag}#{fs}", Fluent::Engine.now, result)
        end
        sleep @interval
      end
    end
  end
end
