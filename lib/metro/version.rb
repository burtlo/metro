module Metro
  VERSION = "0.2.7"
  WEBSITE = "https://github.com/burtlo/metro"
  CONTACT_EMAILS = ["franklin.webber@gmail.com"]
  
  def self.changes_for_version(version)

    change = Struct::Changes.new(nil,[])

    grab_changes = false

    changelog_filename = "#{File.dirname(__FILE__)}/../../changelog.md"

    File.open(changelog_filename,'r') do |file|
      while (line = file.gets) do

        if line =~ /^##\s*#{version.gsub('.','\.')}\s*\/\s*(.+)\s*$/
          grab_changes = true
          change.date = $1.strip
        elsif line =~ /^##\s*.+$/
          grab_changes = false
        elsif grab_changes
          change.changes.push line
        end

      end
    end

    change
  end
  
end
