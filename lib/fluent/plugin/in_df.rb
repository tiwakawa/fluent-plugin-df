module Fluent
  class DfInput < Fluent::Input
    Fluent::Plugin.register_input('df', self)

    config_param :command,  :string, default: '/bin/df'
    config_param :tag,      :string, default: 'df'
    config_param :interval, :integer, default: 3

    def configure(conf)
      super
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
      fss.reject! { |x| x =~ /^Filesystem|tmpfs/ }

      fss.map do |fs|
        f = fs.split(/\s+/)
        ret = {}
        ret[:filesystem] = f.shift
        ret[:size]       = f.shift
        ret[:used]       = f.shift
        ret[:avail]      = f.shift
        ret[:capacity]   = f.shift.delete('%')
        ret[:mounted_on] = f.shift
        ret
      end
    end

    def watch
      while true
        Fluent::Engine.emit(@tag, Fluent::Engine.now, df)
        sleep @interval
      end
    end
  end
end
