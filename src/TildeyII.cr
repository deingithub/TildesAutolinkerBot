require "dotenv"
require "discordcr"

Dotenv.load!
client = Discord::Client.new(token: "Bot #{ENV["token"]}")

bot_id = client.get_current_user.id

issue_regex = /#([0-9]+)/

client.on_message_create do |message|
  next unless message.mentions.any? { |user| user.id == bot_id }
  issues = message.content.scan issue_regex
  output = ""
  issues.each do |issue|
    output += "**Issue ##{issue[1]}:** <https://gitlab.com/tildes/tildes/issues/#{issue[1]}>\n"
  end
  if output.size == 0
    client.create_message(message.channel_id, ":exclamation: No matches.")
  else
    client.create_message(message.channel_id, output)
  end
end

client.run
