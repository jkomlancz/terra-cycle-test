require 'rubygems'
require 'json'
require_relative "githubclient"
require_relative "commitfile"
require_relative "commit"
require_relative "pullrequest"

puts "Welcome!"

# TODO: Be lehetne kerni milyen repon szeretnenk futtatni
ghc = GitHubClient.new "", ""

pulls = ghc.get_pulls

pullrequests = pulls.map { |pu| PullRequest.new(
    pu['url'],
    pu['number'],
    pu['commits_url'],
    # files
    ghc.get_pull_files(pu['url']).map { |f| CommitFile.new(f['filename'], f['patch'], f['blob_url']) }
    ) }


puts pullrequests[0].files[0].patches

commitfile = CommitFile.new "valami", Array.new, Array.new
