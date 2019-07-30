require "http/client"
require "json"
require "discordcr"

struct MergeRequest
  JSON.mapping(
    title: String,
    web_url: String,
    iid: Int32,
    state: String,
    author: NamedTuple(username: String, web_url: String)
  )

  def formatify
    project = self.web_url.lchop("https://gitlab.com/").chomp("/merge_requests/#{self.iid}")
    output = "#{project}!#{self.iid} "
    output += "[@#{self.author[:username]}](#{self.author[:web_url]}): "
    output += "[#{self.title}](#{self.web_url}) "
    output += " **[\\✔]**" if self.state == "closed"
    output
  end
end

def get_mr(repo_id, issue_id)
  resp = HTTP::Client.get("https://gitlab.com/api/v4/projects/#{repo_id}/merge_requests/#{issue_id}", HTTP::Headers{"PRIVATE-TOKEN" => ENV["gl_token"]})
  raise "Negative API Response: #{resp.body}" unless resp.success?
  MergeRequest.from_json(resp.body)
end
