require 'rubygems'
require 'json'
require_relative "githubclient"

puts "Welcome!"

# TODO: Be lehetne kerni milyen repon szeretnenk futtatni
ghc = GitHubClient.new ""

pulls = ghc.get_pulls
