# Qboard
An interactive dismissible keyboard that can be used alongside constraints in the interface builder.

Simply adding the `KeyboardView` to your view in the interface builder will free up having to manage the keyboard. Anything that is anchored to the top of the view will rise and fall with the keyboard with proper animations.

![Alt text](Example.gif?raw=true "Example of Qboard")

## How to use

1) Add a `UIView` from the object library to your xib or storyboard.

2) In the identity inspector use `KeyboardView` as the class.

3) In the attributes inspector select either on or off for the Auto Setup (defaults to on). 

> _Turning this on will attempt to find the `UITextField` in your view and set it to interactively dismiss the keyboard._ 

> _Turning this off will not set the the `UITextField` automatically. This is for if you either do not need interactive dismissal of the keyboard or you would rather set the `UITextField`'s `inputAccessoryView` manually (ex. `keyboardView.setInputAccessoryView(myTextField)`)._

4) Add a bottom, leading, and a trailing constraint snapped to the superview. Then add a height constraint that is set to a height of 0 with priority 250. At this point you can begin building your view on top of the `KeyboardView` with constraints.

If you have any issues implementing this please see the example project. The example project also contains some constraints that aren't explained here regarding constraining your view to the safe area when the keyboard is hidden. 


