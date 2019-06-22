require 'rubygems'
require 'rest-client'
require 'json'

class GitHubClient
    attr_reader :repo_url

    def initialize( repo_url )
        if repo_url.empty? then
            @repo_url = "https://api.github.com/repos/jkomlancz/ruby-test"
        else
            @repo_url = repo_url
        end
    end

    def get_pulls
        url = repo_url + "/pulls"
        response = RestClient.get url
        return JSON.parse(response)
    end

end
