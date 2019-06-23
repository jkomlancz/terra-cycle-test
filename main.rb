require 'rubygems'
require 'json'
require_relative "logic/githubclient"
require_relative "logic/commitfile"
require_relative "logic/helper"
require_relative "logic/pullrequest"

class GithubCommitChecker
    $all_modified_files = Array.new

    def self.gather_modified_files
        $pullrequests.each do |pull|
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

    def self.show_result
        $all_modified_files.each do |file|
            if file.urls.length > 1 then
                file.print_it
                # puts file.to_json
            end
        end
    end

    def self.run
        puts "Welcome!"
        $ghc = GitHubClient.new Helper.get_user_from_arg(ARGV), Helper.get_repo_from_arg(ARGV)
        $pulls = $ghc.get_pulls
        $pullrequests = Helper.convert_to_pull_request($pulls, $ghc)

        gather_modified_files()

        show_result()

    end
end

GithubCommitChecker.run()
