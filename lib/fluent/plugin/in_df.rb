module Fluent
  class DfInput < Fluent::Input
    Fluent::Plugin.register_input('df', self)

    config_param :option,        :string,  default: '-k'
    config_param :interval,      :integer, default: 3
    config_param :tag_prefix,    :string,  default: 'df'
    config_param :target_mounts, :string,  default: '/'

    def configure(conf)
      super
      @command = "df #{@option}"
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
      @loop.watchers.each { |x| x.detach }
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
      begin
        fss = `#{@command}`.split($/)
      rescue => e
        $log.error "#{e.class.name} - #{e.message}"
        exit
      end

      fss.shift # remove header

      fss.map do |fs|
        f = fs.split(/\s+/)
        if arrayed_target_mounts.include?(f[5])
          {
            'fs'       => f[0].gsub(/\//, '_'),
            'size'     => f[1],
            'used'     => f[2],
            'avail'    => f[3],
            'capacity' => f[4].delete('%')
          }
        end
      end.compact
    end

    def arrayed_target_mounts
      @target_mounts.gsub(/'/, '').split(',').map(&:strip)
    end

    def watch
      df.each do |result|
        fs = result.delete('fs')
        Fluent::Engine.emit("#{@tag_prefix}.#{fs}", Fluent::Engine.now, result)
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
