require 'rubygems'
require 'rest-client'
require 'json'

class GitHubClient
    attr_reader :repo_url

    def initialize( user, repo )
        if user.empty? || repo.empty? then
            @repo_url = "https://api.github.com/repos/jkomlancz/terra-cycle-test-repo"
        else
            @repo_url = "https://api.github.com/repos/" + user + "/" + repo
        end
    end

    def get_pulls
        url = repo_url + "/pulls"
        response = RestClient.get url
        return JSON.parse(response)
    end

    def get_call( url )
        response = RestClient.get url
        return JSON.parse(response)
    end

    def get_pull_files( url )
        url = url + "/files"
        response = RestClient.get url
        return JSON.parse(response)
    end
end
