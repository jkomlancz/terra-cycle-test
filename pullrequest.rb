class PullRequest
    attr_reader :url, :number, :commits, :files

    def initialize( url, number, commits, files )
        @url = url, @number = number, @commits = commits, @files = files
    end
    
end
