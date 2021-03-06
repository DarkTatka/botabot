require "botabot/plugin"

module BotaBot
  module Plugins
    def self.setup(default)
      @plugins.default = @plugins[default.to_sym]
    end

    def self.[](name)
      @plugins[name]
    end
    
    def self.[]=(name, options)
      @plugins ||= Hash.new
      @plugins[name] = Plugin.new(BotaBot.bot, name, options[:desc], options[:block])
    end

    def self.all
      @plugins
    end
    
    # load and reload plugins
    def self.load
      Dir["#{BotaBot.root}/plugins/*.rb"].each do |plugin|
        begin
          Kernel.load(plugin)
        rescue
          BotaBot.logger.error("Failed to load plugin #{plugin}: #{$!}")
          next
        end
      end
      BotaBot.logger.debug("Available plugins: #{@plugins.keys.inspect}")
    end
  end
end
