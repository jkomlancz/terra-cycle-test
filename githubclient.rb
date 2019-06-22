require 'rubygems'
require 'rest-client'
require 'json'

class GitHubClient
    def initalize( repo_url )
        if repo_url.empty? then
            @repo_url = "https://api.github.com/repos/jkomlancz/ruby-test"
        else
            @repo_url = repo_url
        end

    def get_pulls
        response = RestClient.get @repo_url + "/pulls"
        return JSON.parse(response)
