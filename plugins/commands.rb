plugin :commands, "dostupné příkazy" do
  commands = Array.new
  BotaBot::Plugins.all.each { |name, plugin| commands.push(name) }
  muc.say("Dostupné příkazy: #{commands.join(", ")}")
end
