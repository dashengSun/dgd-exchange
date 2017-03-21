require 'logger'

module TwelveFactor

  def self.logger(stream, level = ::Logger::INFO)
    ::Logger.new(stream).tap do |logger|
      logger.level = level
      logger.formatter = proc do |severity, datetime, progname, msg|
        "severity=#{severity} pid=#{Process.pid} -- #{msg}\n"
      end
    end
  end

  # Sets up rack.logger to write to rack.errors stream
  #
  class Logging

    def initialize(app, level = ::Logger::INFO)
      @app, @level = app, level
    end

    def call(env)
      logger = TwelveFactor.logger(STDOUT, @level)
      @app.call(env.merge('rack.logger' => logger))
    end

  end

end
