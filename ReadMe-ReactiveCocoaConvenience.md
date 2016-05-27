# Reactive Cocoa Convenience

Core Convenience functionality on top of [ReactiveCocoa].

This is a sub-framework of a [parent project](https://github.com/joshc89/ReactiveCocoaConvenience) of the same name.  There are more sub-frameworks adding extra [ReactiveCocoa] functionality to other 3rd Party libraries. This project is [fully documented](http://joshc89.github.io/ReactiveCocoaConvenience/ReactiveCocoaConvenience/index.html). 

## Dependencies

* [ReactiveCocoa]
* Result

## Examples

Examples from the [ReactiveCocoa] ReadMe can be simplified using ReactiveCocoaConvenience:

	let searchStrings = textField.rac_textSignal()
      .toSignalProducer()
      .map { text in text as! String }

becomes

	let searchStrings = tetxField.rac_textSignalProducer()

In order to bind this to a MutableProperty:

	searchProperty <~ textField.rac_textSignal()
      .toSignalProducer()
      .map { text in text as! String }
      .flatMapError { _ in return SignalProducer<String?, NoError>.empty }

becomes

	searchProperty <~ textField.rac_textSignalProducer()
	
Binding the text entered on pressing the return key to a label:

	textField.rac_signalForControlEvents(.EditingDidEndOnExit)
            .toSignalProducer()
            .map({ $0 as! UITextField })
			.startWithNext({ textField in 
			 	self.myLabel.text = textField.text
			})

becomes

	myLabel.rac_text = textField.rac_signalProducerForControlEvents(.EditingDidEndOnExit)
	  .map { $0.text }

Simpler code is easier to understand and maintain. That is the goal of this sub-framework. More extensions will be added over time.

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