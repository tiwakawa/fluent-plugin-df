module Fluent
  class DfInput < Fluent::Input
    Fluent::Plugin.register_input('df', self)

    config_param :option,        :string,  default: '-k'
    config_param :interval,      :integer, default: 3
    config_param :tag_prefix,    :string,  default: 'df'
    config_param :target_mounts, :string,  default: '/'
    config_param :replace_slash, :bool,    default: true

    def configure(conf)
      super
      @command = "df #{@option} #{@target_mounts} 2> /dev/null"
    end

    def start
      super
      @loop = Coolio::Loop.new
      @timer = DfInputTimerWatcher.new(@interval, true, &method(:watch))
      @loop.attach(@timer)
      @thread = Thread.new(&method(:run))
    end

    def shutdown
      super
      @loop.watchers.each { |w| w.detach }
      @loop.stop
      @thread.terminate
      @thread.join
    end

    def run
      @loop.run
    rescue => e
      $log.error "#{e.class.name} - #{e.message}"
    end

    private
    def df
      fss = `#{@command}`.split($/)
      fss.shift # remove header
      fss.map do |fs|
        f = fs.split(/\s+/)
        {
          'fs'        => replace_slash_in(f[0]),
          'size'      => f[1],
          'used'      => f[2],
          'available' => f[3],
          'capacity'  => f[4].delete('%')
        }
      end
    end

    def replace_slash_in(fs)
      @replace_slash ? fs.gsub(/\//, '_') : fs
    end

    def tag_name(fs)
      @tag_prefix.empty? ? fs : "#{@tag_prefix}.#{fs}"
    end

    def watch
      df.each do |result|
        fs = result.delete('fs')
        Fluent::Engine.emit(tag_name(fs), Fluent::Engine.now, result)
      end
    end
  end

  class DfInputTimerWatcher < Coolio::TimerWatcher
    def initialize(interval, repeat, &callback)
      @callback = callback
      super(interval, repeat)
    end

    def on_timer
      @callback.call
    rescue => e
      $log.error "#{e.class.name} - #{e.message}"
    end
  end
end
