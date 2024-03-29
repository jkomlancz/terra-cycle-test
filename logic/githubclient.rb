require 'rubygems'
require 'rest-client'
require 'json'

class GitHubClient
    attr_accessor :user, :repo, :username, :password, :use_auth

    def initialize( params = {})
        if params.fetch(:user).empty? || params.fetch(:repo).empty? then
            # Default repo
            @repo_url = "https://api.github.com/repos/rails/rails"
        else
            # Custom repo
            @repo_url = "https://api.github.com/repos/" + params.fetch(:user) + "/" + params.fetch(:repo)
        end
        @username = params.fetch(:username)
        @password = params.fetch(:password)
        @use_auth = params.fetch(:use_auth)
    end

    def get_pulls
        url = @repo_url + "/pulls?page="
        $pages = 1
        $response = "[]"
        $result = Array.new
        while ($pages < 2) || ($response != "[]") do
          print "."
          if $response != [] then
            $result = $result + JSON.parse($response)
          end
          actual_url = url + $pages.to_s
          $response = get_request(actual_url)
          $pages = $pages + 1
        end
        return $result
    end

    def get_call( url )
        response = get_request(url)
        return JSON.parse(response)
    end

    def get_pull_files( url )
        url = url + "/files"
        response = get_request(url)
        return JSON.parse(response)
    end

    def get_request( url )
      if @use_auth then
        response = RestClient::Request.new({
          method: :get,
          url: url,
          user: @username,
          password: @password,
          headers: { :accept => :json, content_type: :json }
        }).execute do |response, request, result|
          case response.code
          when 403
            fail "Github refused the request"
          when 200
            print "."
            return response.body
          else
            fail "Invalid response #{response.to_str} received."
          end
        end
      else
        print "."
        return RestClient.get url
      end
    end
end
