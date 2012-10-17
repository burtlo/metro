require 'json'

module SceneView

  class JSONView
    def self.find(view_name)
      File.exists? json_view_name(view_name)
    end

    def self.parse(view_name)
      puts "DEBUG: Loading View From View File: #{json_view_name(view_name)}"
      JSON.parse File.read json_view_name(view_name)
    end

    def self.json_view_name(view_name)
      File.extname(view_name) == "" ? "#{view_name}.json" : view_name
    end
  end

end