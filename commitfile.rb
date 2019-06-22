

class CommitFile
    attr_reader :filename, :patches, :urls

    def initialize( filename, patches, urls )
        @filename = filename,
        @patches = patches

        if urls.empty? then
            @urls = Array.new
        end
    end
end
