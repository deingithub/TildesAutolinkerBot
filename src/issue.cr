require "http/client"
require "json"
require "discordcr"

struct Issue
  JSON.mapping(
    title: String,
    web_url: String,
    iid: Int32,
    state: String,
    author: NamedTuple(username: String, web_url: String)
  )

  def formatify
    output = "[##{self.iid}](#{self.web_url}) "
    output += "[@#{self.author[:username]}](#{self.author[:web_url]}): "
    output += self.title
    output += " **[\\✔]**" if self.state == "closed"
    output
  end
end

def get_issue(issue_id)
  resp = HTTP::Client.get("https://gitlab.com/api/v4/projects/#{ENV["gl_project"]}/issues/#{issue_id}", HTTP::Headers{"PRIVATE-TOKEN" => ENV["gl_token"]})
  raise "Negative API Response: #{resp.body}" unless resp.success?
  Issue.from_json(resp.body)
end
