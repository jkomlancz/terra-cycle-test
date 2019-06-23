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
end
