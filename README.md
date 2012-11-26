```
  ______  ___      _____
  ___   |/  /_____ __  /_______________
  __  /|_/ / _  _ \_  __/__  ___/_  __ \
  _  /  / /  /  __// /_  _  /    / /_/ /
  /_/  /_/   \___/ \__/  /_/     \____/

```

Metro is a framework built around [gosu](https://github.com/jlnr/gosu) (the 2D game development library in Ruby). The goal of Metro is to enforce common conceptual structures and conventions making it easier to quickly generate a game.

[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/burtlo/metro)

[![Build Status](https://travis-ci.org/burtlo/metro.png)](https://travis-ci.org/burtlo/metro)

[![Dependency Status](https://gemnasium.com/burtlo/metro.png)](https://gemnasium.com/burtlo/metro)

## Why Use Metro?

You want to develop games in Ruby.

### Why not just use Gosu?

Gosu does a lot of great work bringing OpenGL to Ruby. However, when you finish the [initial tutorial](https://github.com/jlnr/gosu/wiki/Ruby-Tutorial) you are left with a brittle game that is very resistant to changes or new features.

* Metro provides the concept of a [Scene](https://github.com/burtlo/metro/wiki/Scenes) which is the first abstraction you would likely build after completing the tutorial.

* Sane management of images, animations, fonts, songs, and samples through [model properties](https://github.com/burtlo/metro/wiki/Model-properties).

* [Implicit animations](https://github.com/burtlo/metro/wiki/Animations)

* [Event Handling](https://github.com/burtlo/metro/wiki/Events)

### Why not use Chingu or Gamebox?

Both [Gamebox](https://github.com/shawn42/gamebox) and
[Chingu](https://github.com/ippa/chingu) are much more mature libraries with a
larger set of features.

With Metro the focus is on a smaller set of features with an emphasis on an
implementation that leads to joyful development. An emphasis has been applied to creating elegant solutions which have documentation and examples.

* Active Reloading while building your scenes.

> Make adjustments to your game code while working on a scene. Press **Ctrl+R**
and the scene will automatically be reloaded with all the adjustments you made
to your code.

* Scene Edit Support

> All scenes can have their visual component layout re-adjusted through an edit
mode. The edit mode layout works for all labels, images, and menus.

## Installation

```bash
$ gem install metro
```

## Usage

### Running a Game

By default `metro` will look for a file named 'metro' within the current working directory if no *gamefilename* has been provided.

```bash
$ metro GAMEFILENAME
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

## Resources

### Programming

* [YAML for Ruby](http://www.yaml.org/YAML_for_ruby.html) reference which can help you define views in the game.
* [JSONLint](http://jsonlint.com/) is a JSON Validator

### Art

* [Lost Garden](http://www.lostgarden.com/2007/05/dancs-miraculously-flexible-game.html)
* [TimelieFX](http://www.rigzsoft.co.uk/) particle editor allows you to export animations.
* [Text to ASCII Art Generator](http://patorjk.com/software/taag)
* [Icons](http://css-tricks.com/flat-icons-icon-fonts/)
* [Subtle Patterns](http://subtlepatterns.com/) various backgrounds and textures.

### Sound

* [as3sfxr](http://www.superflashbros.net/as3sfxr/) generates unique sounds.
* [Ableton](https://www.ableton.com/en/) music generation tool.

### Books

* [Rules of Play](http://www.amazon.com/dp/0262240459)
* [Game Programming Gems 8](http://www.amazon.com/dp/1584507020)
* [Game Feel](http://www.amazon.com/dp/0123743281)
* [Game Coding Complete](http://www.amazon.com/dp/1584506806)
* [Game Design Workshop](http://www.amazon.com/dp/0240809742)
* [Challenges For Game Designers](http://www.amazon.com/dp/158450580X)
* [The Art of Game Design: A book of lenses](http://www.amazon.com/dp/0123694965)
* [A Theory of Fun](http://www.theoryoffun.com)
* [Andrew Rollings and Ernest Adams on Game Design](http://www.amazon.com/dp/1592730019)