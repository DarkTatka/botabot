require "botabot/kernel"
require "botabot/role"
require "botabot/roles"

module BotaBot
  class Plugin
    attr_writer :roles
    def initialize(client, name, block)
      @client = client
      @name   = name
      @block  = block
    end
    
    #def roles
    #  @roles or Roles.all
    #end
    
    def run(muc, *args)
      BotaBot.logger.debug("Called plugin #{@name} with args #{args.inspect}")
      @block.call(@client, muc, *args)
    rescue
      BotaBot.logger.error("Exception: #$!")
      BotaBot.logger.error("Details: #{$!.backtrace.join("\n")}")
    end
  end
end
