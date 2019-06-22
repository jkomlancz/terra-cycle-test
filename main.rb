require 'rubygems'
require 'json'
require_relative "githubclient"
require_relative "commitfile"
require_relative "pullrequest"

puts "Welcome!"

# TODO: Be lehetne kerni milyen repon szeretnenk futtatni
ghc = GitHubClient.new "", ""

pulls = ghc.get_pulls

# objektumma alakitas
pullrequests = pulls.map { |pull| PullRequest.new(pull['url'], pull['number'], pull['commits'], pull['files'])  }

puts pullrequests

commitfile = CommitFile.new "valami", Array.new, Array.new
