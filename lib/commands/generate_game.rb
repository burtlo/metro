module Metro

  class GenerateGame < Generator

    argument :name

    def create_metro_file
      directory "game", name
    end

  end

end