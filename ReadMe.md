# ReactiveCocoaConvenience

Simplifying development with [ReactiveCocoa]

## Features

Functaionality is spread between multiple frameworks based on dependent frameworks.

* [ReactiveCocoaConvenience](ReadMe-ReactiveCocoaConvenience.md)
  * [x] `MutableProperty` UIKit Equivalents
  * [x] Convenience typed `SignalProducer` equivalients for `RACsignal`s
  * [x] [Documentation](http://joshc89.github.io/ReactiveCocoaConvenience/ReactiveCocoaConvenience/index.html)
* [ReactiveCocoaConvenience_Alamofire](ReadMe-ReactiveCocoaConvenience-Alamofire.md)
  * [x] `SignalProducer`s for [Alamofire] Requests
  * [x] [Documentation](http://joshc89.github.io/ReactiveCocoaConvenience/ReactiveCocoaConvenience-Alamofire/index.html)
* [ReactiveCocoaConvenience_Alamofire_SwiftyJSON](ReadMe-ReactiveCocoaConvenience-Alamofire-SwiftyJSON.md)
  * [x] Model Object initialisation from [SwiftyJSON] serialized [Alamofire] requests.
  * [x] Convenience creators for common errors.
  * [x] [Documentation](http://joshc89.github.io/ReactiveCocoaConvenience/ReactiveCocoaConvenience-Alamofire-SwiftyJSON/index.html)

See each section for more details.

## Installation

ReactiveCocoaConvenience is [Carthage] compatible. Add

	github "joshc89/ReactiveCocoaConvenience"

and following the [Carthage] installation instructions. Add the frameworks you will be using and their dependencies, then checkout the Documentation for each to get started.

As there is no official [Cocoapods](https://cocoapods.org) support for ReactiveCocoa, Cocoapods is not officially supported for ReactiveCocoaConvenience either.

[ReactiveCocoa]: https://github.com/ReactiveCocoa/ReactiveCocoa
[Alamofire]: https://github.com/Alamofire/Alamofire
[SwiftyJSON]: https://github.com/SwiftyJSON/SwiftyJSON
[Carthage]: https://github.com/Carthage/Carthage
[Cocoapods]: https://cocoapods.org