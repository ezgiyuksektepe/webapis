#reference: https://gist.github.com/gakshay/2771857
require 'singleton'

class Log
  include Singleton

  attr_accessor :level

  ERROR=1
  WARNING=2
  INFO=3

  def initialize
    @log = File.open("log.json", "a")
    @level = WARNING
  end

  def append(data)
    data[:time] = Time.now
    @log.puts(JSON.generate(data))
    @log.flush
  end

  def error(msg)
    if @level >= ERROR
      append({:level => ERROR, :message => msg})
    end
  end

  def warning(msg)
    if @level >= WARNING
      append({:level => WARNING, :message => msg})
    end
  end

  def info(msg)
    if @level >= INFO
      append({:level => INFO, :message => msg})
    end
  end
end
