# Reactive Cocoa Convenience

Core Convenience functionality on top of [ReactiveCocoa].

This is a sub-framework of a [parent project](https://github.com/joshc89/ReactiveCocoaConvenience) of the same name.  There are more sub-frameworks adding extra [ReactiveCocoa] functionality to other 3rd Party libraries.

This project is [fully documented](). 

## ReactiveCocoa 'MutableProperty's

Inspired by [Colin Eberhart's blog post "MVVM With ReactiveCocoa"](http://blog.scottlogic.com/2015/05/15/mvvm-reactive-cocoa-3.html) I wanted to simplify the code to bind variables to and from UIKit components.

Extensions have been to added to UIKit classes to give `MutableProperty` equivalents to UIKit properties that will often change as a result of a `Signal` or `SignalProducer`:

	UIView:
      rac_hidden: MutableProperty<Bool>
      rac_alpha: MutableProperty<CGFloat>

    UIControl:
      rac_enabled: MutableProperty<Bool>
    
    UILabel, UITextField, and UITextView:
      rac_text: MutableProperty<String?>
      rac_attributedText: MutableProperty<NSAttributedString?>
  
## Typed Signals

ReactiveCocoa provides many signals from UIKit components, however these tend to be `RACSignal` classes, not the newer Swift generic `Signal` or `SignalProducer` classes. To use these in Swift projects requires boilerplate mapping and force unwrapping. These mappings have wrapped up in convenience functions:

    UIControl:
      rac_signProducerForEvents(_:) -> SignalProducer<UIControl, NoError>
      
    UITextField and UITextView:
      rac_textSignalProducer() -> SignalProducer<String?, NoError>

[ReactiveCocoa]: https://github.com/ReactiveCocoa/ReactiveCocoa