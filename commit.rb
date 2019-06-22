class Commit
    attr_reader :url, :sha, :files

    def initialize( url, sha, files )
        @url = url, @sha = sha, @files = files
    end

end
