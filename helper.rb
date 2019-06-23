require 'rubygems'
require 'json'
require_relative "commitfile"

class Helper
    def self.filter_modified_rows( patch )
        if patch.to_s.empty? then
            return patch.to_s
        end

        patches = Array.new
        new_patch = ""
        is_new_patch = false
        counter = 0

        patch.each_char do |c|
            if c == "@" && patch[counter + 1] == "@" && !is_new_patch then
                is_new_patch = true
                new_patch << c

            elsif c == "@" && patch[counter + 1] == "@" && is_new_patch then
                is_new_patch = false
                new_patch << c
                new_patch << "@"
                patches.push(new_patch)
                new_patch = ""

            elsif is_new_patch then
                new_patch << c
            end
            counter += 1
        end
        return patches
    end

    def self.convert_to_file( json, url )
        return json.map { |f| CommitFile.new(f['sha'], f['filename'], Helper.filter_modified_rows(f['patch']), url) }
    end

    def self.get_user_from_arg( input_array )
        if input_array.include? "-u" then
            return input_array[input_array.index("-u") + 1]
        else
            return ""
        end
    end

    def self.get_repo_from_arg( input_array )
        if input_array.include? "-r" then
            return input_array[input_array.index("-r") + 1]
        else
            return ""
        end
    end
end