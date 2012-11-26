module Metro
  module Parameters

    #
    # The CommandLineArgsParser converts the argument list passed in from the
    # command-line and generates an Metro::Parameters::Options object.
    #
    module CommandLineArgsParser
      extend self

      #
      # Given the array of parameters usually from the Command-Line ARGV and
      # convert that information into various parameters
      #
      def parse(*parameters)
        parameters = parameters.flatten.compact
        options = { execution_parameters: parameters.dup }

        command_flags = extract_command_flags!(parameters)
        filename = extract_game_file!(parameters)

        Options.new options.merge(filename: filename).merge(command_flags)
      end

      private

      #
      # Find all the flags within the array of parameters, extract them and
      # generate a hash. Their presence within the array means that they should
      # have a true value.
      #
      # @return [Hash] a hash that contains all the flags as keys and true as
      #   their values. As the presence of the flag means the value is true.
      #
      def extract_command_flags!(parameters)
        raw_command_flags = parameters.flatten.find_all { |arg| arg.start_with? "--" }
        parameters.delete_if { |param| raw_command_flags.include? param }

        flag_names = raw_command_flags.map { |flag| flag[/--(.+)$/,1].underscore.to_sym }
        flag_values = [ true ] * flag_names.count
        Hash[flag_names.zip(flag_values)]
      end

      #
      # From the current parameters array remove the first element which should
      # be the default game file. When there is no value then use the default
      # game filename
      #
      # @return [String] the game file name to use
      #
      def extract_game_file!(parameters)
        parameters.delete_at(0) || default_game_filename
      end

      #
      # The default for games is to have a game file called 'metro'. So if they
      # do not provide the file parameter we assume that it is this file.
      #
      # @return [String] the default filename that contains the game contents
      #
      def default_game_filename
        'metro'
      end

    end

  end
end