require "dotenv"
require "discordcr"

Dotenv.load!
client = Discord::Client.new(token: "Bot #{ENV["token"]}")

bot_id = client.get_current_user.id
bot_name = client.get_current_user.username

issue_regex = /#([0-9]+)/
mr_regex = /!([0-9]+)/
help_regex = Regex.new("<@!?#{bot_id}> help")
utw_regex = Regex.new("<@!?#{bot_id}> utw")
help_string = <<-STR
**__TildesAutolinker__**
Use `@#{bot_name} help` to see this message.
`@#{bot_name} UTW` links to the Unofficial Tildes Wiki.
To get other links (see below), mention me anywhere in your message.
`#123` is turned into <https://gitlab.com/tildes/tildes/issues/123>.
Hacked together by `deing#7141`. Code here: https://git.dingenskirchen.systems/deing/TildesAutolinkerBot.
STR

client.on_message_create do |message|
  next if message.author.bot
  next unless message.mentions.any? { |user| user.id == bot_id }
  if message.content.downcase =~ help_regex
    client.create_message(message.channel_id, help_string)
    next
  end
  if message.content.downcase =~ utw_regex
    client.create_message(message.channel_id, "<https://unofficial-tildes-wiki.gitlab.io>")
    next
  end
  issues = message.content.scan issue_regex
  output = ""
  issues.each do |issue|
    output += "**Issue ##{issue[1]}:** <https://gitlab.com/tildes/tildes/issues/#{issue[1]}>\n"
  end
  merges = message.content.scan mr_regex
  merges.each do |mr|
    output += "**Merge Request !#{mr[1]}:** <https://gitlab.com/tildes/tildes/merge_requests/#{mr[1]}>\n"
  end
  if output.size == 0
    client.create_message(message.channel_id, ":exclamation: No matches found.")
  else
    client.create_message(message.channel_id, output)
  end
end

client.run
