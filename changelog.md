# Metro

## 0.2.7 / 2012/11-20

* FIX to the new game template
* Updated the game template to give more movement to the hero in the first scene
* Added the fade-in, fade-out helper to show all the instructions

## 0.2.6 / 2012/11-20

* Menus now support vertical and horizontal layout
* Menus now support movement and selection noises
* Menus can now have a default selection
* Menus can be enabled/disabled
* Added Array Property, Boolean Property, and Menu Options Property
* FIX label horizontal center and right alignments
* Generic Models will now show a warning instead of raising an exception
* Removed event chain debug messaging

## 0.2.5 / 2012-11-18

* FIX metro::ui::rectangle calculation
* FIX remaining references to metro::models::* to metro::ui::*
* FIX Models will use their setters over setting raw properties
* Metro::UI::Label now supports horizontal alignment, vertical alignment, and multiple lines

## 0.2.4 / 2012-11-15

* All retrieved models from properties are now cached for better performance
* Animations were re-vamped to accept more parameters
* Metro models names in code are now referred to as "metro::models::*" to "metro::ui::*"

## 0.2.3 / 2012-11-11

* FIX metro generators and templates generating out-of-date formats
* FIX YAML views will now return an empty hash instead of false on empty files
* Added first scene and model to template.
* FIX better error message when a directory is specified
* Added the `g` generator shortcut: `metro g scene NAME`

## 0.2.2 / 2012-11-10

* Song support added (scene methods and model properties)
* Sample support added (model properties)
* Added a missing sample/song
* Implicit Animation easings can now be more easily created and registered.
* Properties can now be defined with a block
* FIX Dimensions parse creation called wrong method
* Removed support for specifying a color in animation

## 0.2.1 / 2012-11-08

* FIX Scene fade transition color changing and implicit animations 
  for colors
* Games creating custom properties will appear in the property list
* Properties now correctly default to numeric properties
* Point objects can be added to other point objects. 

## 0.2.0 / 2012-11-07

* Views now use position instead of `x`, `y`, and `z-order`
* Point, Scale, and Dimensions is available in model and scenes.
* Events are shared from superclasses to subclasses.
* Templates updated to use GameScene and GameModel for each game.
* Models are automatically added to the update loop
* Model properties now make it easier to store/retrieve various
  common numeric, position font, image, and animation properties.


## 0.1.6 / 2012-11-07

* Events are shared from superclasses to subclasses.
* Templates updated to use GameScene and GameModel for each game.
* Models are automatically added to the update loop
* Model properties now make it easier to store/retrieve various
  common numeric, position font, image, and animation properties.

## 0.1.5 / 2012-11-01

* Metro.reload! will reload all game classes
* Scenes can now an editable state where the position of items can be
  updated and saved.
* Event blocks can optionally receive an event object. The event object
  includes modifier key information.


## 0.1.4 / 2012-10-28

* Removed dependency on the sender gem so metro is playable on Windows

## 0.1.3 / 2012-10-28

* Fade Scene Transition support added
* Numeric#seconds and Numeric#ticks helpers added
* Scenes can now define delayed events `after 2.seconds do ; end`
* Labels have more defaults and more font options and size
* Labels and images will default to center of screen
* Able to define game controls within your metro file
* Implicit animations support color change.

## 0.1.2 / 2012-10-26

* Generators for games, scenes, models, and views

## 0.1.1 / 2012-10-25

* FIX: Requiring the sender gem

## 0.1.0 / 2012-10-25

* Better error handling for missing metro file and missing scene
* FIX: Scenes without Scene suffix will work again
* Gosu::Color supports creation with various formats: rgb, rgba, and hex
* Animations can be defined with class level helpers
* Removed Scene#events as Events can be defined at the class level
* Scenes and Models can generate custom notification events