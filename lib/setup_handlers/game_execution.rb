module Metro
  module SetupHandlers

    #
    # The GameExecution allows for a game to be executed. This is used by Metro
    # to validate that the code can be loaded and run before actually running
    # it (specifically when reloading live running code)
    #
    class GameExecution

      #
      # Perform a game execution with the specified parameters and return the
      # result of that game execution.
      #
      def self.execute(parameters)
        execution = new(parameters)
        execution.execute!
        execution
      end

      # @return the output generated from the execution of code.
      attr_reader :output

      # @return an array of parameters that will be provided to the execution
      #   of the game.
      attr_reader :parameters

      #
      # @param [Array] parameters an array of the game parameters that are
      #   to be provided to this execution of the game.
      #
      def initialize(parameters)
        @parameters = parameters
      end

      # @return the status code that was returned when the game execution
      #   has completed.
      def status
        @status ||= 0
      end

      # Perform the game execution.
      def execute!
        @output, @status = Open3.capture2e(game_execution_string)
      end

      # @return [TrueClass,FalseClass] true if the execution was successful.
      def valid?
        status == 0
      end

      # @return [TrueClass,FalseClass] true if the execution was a failure.
      def invalid?
        status != 0
      end

      private

      def game_execution_string
        "#{Metro.executable_path} #{parameters.join(" ")}"
      end
    end

  end
end