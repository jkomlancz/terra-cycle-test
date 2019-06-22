require 'rubygems'
require 'json'
require_relative "githubclient"
require_relative "commitfile"
require_relative "commit"
require_relative "pullrequest"

puts "Welcome!"

# TODO: Be lehetne kerni milyen repon szeretnenk futtatni
ghc = GitHubClient.new "", ""

$pulls = ghc.get_pulls

$all_modified_files = Array.new

$pullrequests = $pulls.map { |pu| PullRequest.new(
    pu['url'],
    pu['number'],
    pu['commits_url'],
    # files
    ghc.get_pull_files(pu['url']).map { |f| CommitFile.new(f['filename'], f['patch'], f['blob_url']) }
    ) }

def gather_modified_files
    $pullrequests.each do |pull|
        pull.files.each do |file|
            $all_modified_files.push(file)
        end
    end
end

gather_modified_files()

puts $all_modified_files[0].filename
