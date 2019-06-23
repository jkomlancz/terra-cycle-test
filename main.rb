require 'rubygems'
require 'json'
require_relative "githubclient"
require_relative "commitfile"
require_relative "helper"
require_relative "pullrequest"

puts "Welcome!"

# TODO: Be lehetne kerni milyen repon szeretnenk futtatni
ghc = GitHubClient.new "jkomlancz", "terra-cycle-test-repo"

$pulls = ghc.get_pulls

$all_modified_files = Array.new
$result = Hash.new

$pullrequests = $pulls.map { |pu| PullRequest.new(
    pu['url'],
    pu['number'],
    pu['commits_url'],
    # files
    ghc.get_pull_files(pu['url']).map { |f| CommitFile.new(f['sha'], f['filename'], Helper.filter_modified_rows(f['patch']), f['blob_url']) }
    ) }

def gather_modified_files
    $pullrequests.each do |pull|
        pull.files.each do |file|
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

gather_modified_files()

$all_modified_files.each do |file|
    if file.urls.length > 1 then
        file.print_it
    end
end
