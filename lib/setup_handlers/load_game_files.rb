module Metro
  module SetupHandlers

    class LoadGameFiles
      def setup(options)
        load_game_files!
      end

      def load_game_files!
        EventDictionary.reset!
        prepare_watcher!
        load_game_files
        execute_watcher!
      end

      class GameExecution
        def initialize(command)
          @status = 1
        end

        def execute!
          @output, @status = Open3.capture2e("#{Metro.executable_path} --dry-run")
        end

        def valid?
          status == 0
        end

        def invalid?
          status != 0
        end

        attr_reader :status, :output
      end

      def valid_game_code
        ge = GameExecution.new "the original parameters of execution"
        ge.execute!

        if ge.invalid?
          message = TemplateMessage.new message: 'error.unloadable_source',
            details: { output: ge.output }
          warn message
        end

        ge.valid?
      end

      def reload!
        EventDictionary.reset!
        prepare_watcher!
        load_game_files
        execute_watcher!
      end

      #
      # The watcher should watch the Object Namespace for any changes. Any constants
      # that are added will be tracked from this point forward.
      #
      def prepare_watcher!
        ActiveSupport::Dependencies.clear
        watcher.watch_namespaces([ Object ])
      end

      #
      # The watcher will keep track of all the constants that were added to the Object
      # Namespace after the start of the execution of the game. This will allow for only
      # those objects to be reloaded.
      #
      def watcher
        @watcher ||= ActiveSupport::Dependencies::WatchStack.new
      end

      def load_game_files
        $LOAD_PATH.unshift(Dir.pwd) unless $LOAD_PATH.include?(Dir.pwd)
        load_paths 'lib'
        load_path 'scenes', prioritize: 'game_scene.rb'
        load_path 'models', prioritize: 'game_model.rb'
      end

      def load_paths(*paths)
        paths.flatten.compact.each {|path| load_path path }
      end

      def load_path(path,options = {})
        files = Dir["#{path}/**/*.rb"]
        files.sort! {|file| File.basename(file) == options[:prioritize] ? -1 : 1 }
        files.each {|file| require_or_load file }
      end

      #
      # The watcher will now mark all the constants that it has watched being loaded
      # as unloadable. Doing so exhausts the list of constants found so the watcher
      # will be empty.
      #
      # @note an exception is raised if the watcher is not prepared every time this
      #   is called.
      #
      def execute_watcher!
        watcher.new_constants.each { |constant| unloadable constant }
      end
    end
  end

  register_setup_handler SetupHandlers::LoadGameFiles.new

end