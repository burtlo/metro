```
  ______  ___      _____
  ___   |/  /_____ __  /_______________
  __  /|_/ / _  _ \_  __/__  ___/_  __ \
  _  /  / /  /  __// /_  _  /    / /_/ /
  /_/  /_/   \___/ \__/  /_/     \____/

```
# metro

Metro is a framework built around [gosu](https://github.com/jlnr/gosu) (the 2D game development library in Ruby). The goal of Metro is to enforce common conceptual structures and conventions making it easier to quickly generate a game.

> NOTE: This project is very early in development and at this point mostly a prototype to explore more of theses concepts to gain an understanding of core tools necessary to make games.

[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/burtlo/metro)

## Installation

    $ gem install metro

## Usage

### Running a Game

By default `metro` will look for a file named 'metro' within the current working directory if no *gamefilename* has been provided.

```
metro [gamefilename]
```

Please take a look at the [example game project](https://github.com/burtlo/starry-knight) that is being built alongside of 'metro'. It currently showcases all the current features available to the game.

```bash
$ git clone git://github.com/burtlo/starry-knight.git
$ cd starry-knight
$ metro
```

### Creating a Game

Metro contains content generators to assist you.

Creating a Game can be done with a single command.

```bash
$ metro new GAMENAME
```

This should generate for you a starting game with a branding scene and a title scene. The game allows the player to start the game.

The game is missing the `first` scene of the game. This can be created with the scene generator:

```bash
$ metro generate scene first
```

This should generate a scene in the scenes directory. The scene file contains a lot of examples of how to draw, animate and have your scene listen to events.


### Resources

#### Programming

* [YAML for Ruby](http://www.yaml.org/YAML_for_ruby.html) reference which can help you define views in the game.
* [JSONLint](http://jsonlint.com/) is a JSON Validator

#### Art

* [Lost Garden](http://www.lostgarden.com/2007/05/dancs-miraculously-flexible-game.html)
* [TimelieFX](http://www.rigzsoft.co.uk/) particle editor allows you to export animations.
* [Text to ASCII Art Generator](http://patorjk.com/software/taag)
* [Icons](http://css-tricks.com/flat-icons-icon-fonts/)
* [Subtle Patterns](http://subtlepatterns.com/) various backgrounds and textures.

#### Sound

* [as3sfxr](http://www.superflashbros.net/as3sfxr/) generates unique sounds.
* [Ableton](https://www.ableton.com/en/) music generation tool.


#### Books

* [Rules of Play](http://www.amazon.com/dp/0262240459)
* [Game Programming Gems 8](http://www.amazon.com/dp/1584507020)
* [Game Feel](http://www.amazon.com/dp/0123743281)
* [Game Coding Complete](http://www.amazon.com/dp/1584506806)
* [Game Design Workshop](http://www.amazon.com/dp/0240809742)
* [Challenges For Game Designers](http://www.amazon.com/dp/158450580X)
* [The Art of Game Design: A book of lenses](http://www.amazon.com/dp/0123694965)
* [A Theory of Fun](http://www.theoryoffun.com)
* [Andrew Rollings and Ernest Adams on Game Design](http://www.amazon.com/dp/1592730019)