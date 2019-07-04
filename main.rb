require 'rubygems'
require 'json'
require 'io/console'
require "awesome_print"
require_relative "logic/githubclient"
require_relative "logic/commitfile"
require_relative "logic/helper"
require_relative "logic/pullrequest"

class GithubCommitChecker
    $all_modified_files = Array.new

    def self.gather_modified_files( pullrequests )
        pullrequests.each do |pull|
            $ghc.get_call(pull.commits).each do |commit|
                files = Helper.convert_to_file($ghc.get_call(commit['url'])['files'], commit["html_url"])
                files.each do |file|
                    exists = false
                    if $all_modified_files.length == 0 then
                        $all_modified_files.push(file)
                    else
                        counter = 0
                        while counter < $all_modified_files.length do
                            rf = $all_modified_files[counter]
                            if rf.equals(file) && !(rf.urls.include? file.urls[0]) then
                                rf.urls.push(file.urls[0])
                                exists = true
                            end
                            counter += 1
                        end
                        if !exists
                            $all_modified_files.push(file)
                        end
                    end
                end
            end
        end
    end

    def self.show_same_row_diff_result
        result = Array.new
        $all_modified_files.each do |file|
            if file.urls.length > 1 then
                result.push(file.to_json)
            end
        end
        print "\nSame line modifier commits number: " + result.length.to_s + "\n"
        ap result
    end

    def self.run
        puts "Welcome!"
        start = Time.new
        use_auth_mode = Helper.use_auth_mode(ARGV)

        if use_auth_mode then
          puts "Enter your Github username: "
          username = STDIN.gets.chomp
          puts "Enter your Github password: "
          password = IO::console.getpass
        else
          username = ""
          password = ""
        end

        $ghc = GitHubClient.new(:user => Helper.get_user_from_arg(ARGV), :repo => Helper.get_repo_from_arg(ARGV), :username => username.to_s, :password => password.to_s, :use_auth => use_auth_mode)

        puts "Getting pulls"
        $pulls = $ghc.get_pulls
        puts "\nCheck commits"
        $pullrequests = Helper.convert_to_pull_request($pulls, $ghc)

        gather_modified_files( $pullrequests )

        show_same_row_diff_result()

        ended = Time.new

        puts "Started: #{start.hour}:#{start.min}:#{start.sec}"
        puts "Ended: #{ended.hour}:#{ended.min}:#{ended.sec}"
        diff = ended - start
        puts "Running: #{diff.round} sec"

    end
end

GithubCommitChecker.run
