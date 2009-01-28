require "find"
require "botabot/bot"
require "botabot/config"
require "botabot/kernel"
require "botabot/exceptions"
require "botabot/logger"
require "botabot/muc"
require "botabot/plugins"

module BotaBot
  VERSION = "0.0.1"
  def self.root
    File.dirname(File.dirname(__FILE__))
  end
  
  def self.logger
    BotaBot::Logger.instance
  end

  def self.config
    BotaBot::Config.instance
  end

  def self.bot
    BotaBot::Bot.instance
  end
  
  def self.init(profile)
    self.register_signals
    config.set_profile(profile)
    bot.init(config)
    bot.join(config.room)
    Plugins.load
    Plugins.setup(config.missing)
    return bot
  end

  def self.register_signals
    trap("INT") do
      if @interrupted_at.nil? || (Time.now - @interrupted_at).to_i > 2
        self.reload
      else
        exit
      end
      @interrupted_at = Time.now
    end
  end
  
  def self.reload
    Find.find("#{BotaBot.root}/lib") do |file|
      begin
        load(file) if file.match(/\.rb$/)
      rescue
        BotaBot.logger.error("Failed to load file #{file}: #{$!}")
        next
      end
    end
    BotaBot.logger.debug("Reloaded library")
    Plugins.load
  end
  
  def self.run(profile)
    self.init(profile)
    loop { sleep 1 }
  end
end
