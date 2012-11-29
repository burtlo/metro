```
  ______  ___      _____
  ___   |/  /_____ __  /_______________
  __  /|_/ / _  _ \_  __/__  ___/_  __ \
  _  /  / /  /  __// /_  _  /    / /_/ /
  /_/  /_/   \___/ \__/  /_/     \____/

```

Metro is a framework built around [gosu](https://github.com/jlnr/gosu) (the 2D
game development library in Ruby). The goal of Metro is to enforce common
conceptual structures and conventions making it easier to quickly generate a
game.

[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/burtlo/metro)

[![Build Status](https://travis-ci.org/burtlo/metro.png)](https://travis-ci.org/burtlo/metro)

[![Dependency Status](https://gemnasium.com/burtlo/metro.png)](https://gemnasium.com/burtlo/metro)

## Why Use Metro?

You want to develop games in Ruby.

### Why not just use Gosu?

Gosu does a lot of great work bringing OpenGL to Ruby. However, when you finish
the [initial tutorial](https://github.com/jlnr/gosu/wiki/Ruby-Tutorial) you are
left with a brittle game that is very resistant to changes or new features.

* Metro provides the concept of a
  [Scene](https://github.com/burtlo/metro/wiki/Scenes) which is the first
  abstraction you would likely build after completing the tutorial.

> Developing your game in individual scenes will make it easier to logically
layout your game.

* Sane management of images, animations, fonts, songs, and samples through
  [model properties](https://github.com/burtlo/metro/wiki/Model-properties).

> Having to load and cache fonts and images in every one of your models is
tedious. It is also is wasteful as several of the same fonts are being used all
over the place.

* [Key-frame animations](https://github.com/burtlo/metro/wiki/Animations)

> Metro makes it simple to move an actor from one position to another position.
So simple movements, fades, color changes, and really any property change over
time is defined very simply.

* [Event Handling](https://github.com/burtlo/metro/wiki/Events)

> Delete those huge `if ... elsif ... else` input checking structures for
keyboard, gamepad, and mouse button presses (down,up, and held). Metro makes it
easy to define them and an attach a course of action to take when the event
happens.

### Why not use Chingu or Gamebox?

Both [Gamebox](https://github.com/shawn42/gamebox) and
[Chingu](https://github.com/ippa/chingu) are more mature libraries with a
larger set of features. I encourage you to check out those libraries.

Metro's primary goal is to be a framework of features that make game development
joyful.

* Active Reloading while building your scenes.

> Adjustments to your game code while working on a scene will automatically
reload your game code. The template game sets up a shortcut key (**Ctrl+R**)
that allows you to explicitly reload the game and the current scene.

* Scene Edit Support

> Scenes can enter an edit mode which allows you to re-position actors within
the scene. The changes can then be saved back to the view. This allows you to
fine tune the layout of those scene elements, making it easier to get things
pixel perfect.

Metro's secondary goal is to make it easier for individuals familiar with Rails
get into game development. That is the reason for some of the design choices,
the opinionated structure, and generators that come with Metro.

### Why you shouldn't use Metro?

Metro has some the following limitations:

* Limited to the gems defined within Metro

> At this point in time you are not able to define and package additional
dependencies with your game. This means if you are using a gem that is not
already defined by Metro you will run into trouble when running it on alternate
systems. This will likely be addressed in the future when more demand arises.

* Difficult Deployment

> For individuals to play your game, they will also have to install Metro.
However, work is being made to bring some simple packaging to Metro games to
make them stand-along executables.

## Installation

```bash
$ gem install metro
```

## Usage

### Running a Game

By default `metro` will look for a file named 'metro' within the current working
directory if no *gamefilename* has been provided.

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

This should generate for you a starting game with a branding scene and a title
scene. The game allows the player to start the game.

The game is missing the `first` scene of the game. This can be created with the
scene generator:

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