module Metro
  module SetupHandlers

    #
    # If the user has enabled the dry-run flag, this is the point at which the
    # game will exit.
    #
    # Dry run mode is useful for determine if all dependencies have successfully
    # been met and the source code will load successfully.
    #
    class ExitIfDryRun
      #
      # @param [Metro::Parameters::Options] options the options that the game
      #   was provided when it was launched.
      #
      def setup(options)
        return unless options.dry_run?
        puts TemplateMessage.new message: 'dry_run.success'
        exit
      end
    end
  end

  register_setup_handler SetupHandlers::ExitIfDryRun.new

end