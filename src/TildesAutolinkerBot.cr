require "dotenv"
require "discordcr"

require "./issue"
require "./mr"

Dotenv.load!
client = Discord::Client.new(token: "Bot #{ENV["discord_token"]}")

bot_id = client.get_current_user.id
bot_name = client.get_current_user.username

issue_regex = /#([0-9]+)/
mr_regex = /!([0-9]+)/
help_regex = Regex.new("<@!?#{bot_id}> help")

help_string = <<-STR
Accepted formats:
`#1234` Link Tildes Issue.
`!1234` Link Tildes Merge Request.

Hacked together by <@344166495317655562> — [Source](https://git.dingenskirchen.systems/deing/TildesAutolinkerBot) — `@#{bot_name} help` to see this message
STR

client.on_message_create do |message|
  next if message.author.bot
  next unless message.mentions.any? { |user| user.id == bot_id }

  if message.content.downcase =~ help_regex
    client.create_message(message.channel_id, "", Discord::Embed.new(description: help_string, title: "TildesAutolinker"))
    next
  end

  output = ""

  issues = message.content.scan issue_regex
  issues.each do |issue|
    begin
      output += get_issue(issue[1]).formatify + "\n"
    rescue e
      pp e
      output += "##{issue[1]} `#{e}`\n"
    end
  end

  merges = message.content.scan mr_regex
  merges.each do |mr|
    # Avoid reacting to pings with ! in them
    next if mr[2].size > 5
    begin
      output += get_mr(mr[1]).formatify + "\n"
    rescue e
      pp e
      output += "!#{mr[1]} `#{e}`\n"
    end
  end

  output = ":exclamation: No matches found." if output.size == 0

  client.create_message(message.channel_id, "", Discord::Embed.new(description: output))
end

client.run
