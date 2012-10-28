# Metro

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