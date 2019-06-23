

class CommitFile
    # attr_reader :filename, :patches, :urls

    def initialize( sha, filename, patches, urls )
        @sha = sha,
        @filename = filename,
        @patches = patches,

        if urls.empty? then
            @urls = Array.new
        else
            @urls = [urls]
        end
    end

    def filename
        @filename
    end

    def patches
        @patches
    end

    def urls
        @urls
    end

    def equals( commit_file )
        return @filename == commit_file.filename && exists_patch(commit_file.patches)
    end

    def exists_patch( patches )
        patches.each do |p|
            if @patches.include? p
                return true
            end
        end
        return false
    end

    def print_it
        puts "\nFilename: ", @filename
        puts "URLs: ", @urls
        puts "Patches: ", @patches
    end
end
