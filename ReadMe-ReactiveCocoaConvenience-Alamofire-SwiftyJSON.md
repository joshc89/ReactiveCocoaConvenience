# ReactiveCocoaConvenience-Alamofire-SwiftyJSON

[ReactiveCocoa] SignalProducers for Alamofire & SwiftyJSON to serialize any model object.

This is a sub-framework of a [ReactiveCocoaConvenience].  There are more sub-frameworks adding extra [ReactiveCocoa] functionality including one adding [SwiftyJSON] support with [ReactiveCocoa] and [Alamofire]. This project is [fully documented](http://joshc89.github.io/ReactiveCocoaConvenience/ReactiveCocoaConvenience-Alamofire-SwiftyJSON/index.html). 

## Features

* [x] Model Object initialisation from [SwiftyJSON] serialized [Alamofire] requests.
* [x] Convenience creators for common errors.
* [x] [Documentation](http://joshc89.github.io/ReactiveCocoaConvenience/ReactiveCocoaConvenience-Alamofire-SwiftyJSON/index.html)

## Dependencies

* [ReactiveCocoa]
* Result
* [Alamofire]
* [SwiftyJSON]


## Examples

[ReactiveCocoaConvenience-Alamofire](http://joshc89.github.io/ReactiveCocoaConvenience/ReactiveCocoaConvenience-Alamofire/index.html) simplified getting a `SignalProducer` from an [Alamofire] request:

    let p: SignalProducer<AnyObject, NSError>
	p = Alamofire.request(.GET, "https://httpbin.org/get", parameters: ["foo": "bar"])
         .validate()
         .rac_responseJSON()
         
This sub-framework adds support for [SwiftyJSON] serialization:

    let p: SignalProducer<JSON, NSError>
	p = Alamofire.request(.GET, "https://httpbin.org/get", parameters: ["foo": "bar"])
         .validate()
         .rac_responseSwiftyJSON()

This is nice for those who like "The better way to deal with JSON data in Swift", but whilst `JSON` objects are nice for dealing with APIs, model objects a much better for the rest of our code. Wouldn't this be nicer:

	let p: SignalProducer<(JSON, [MyClass]), NSError>
	p = Alamofire.request(.GET, "https://httpbin.org/get", parameters: ["foo": "bar"])
         .validate()
         .rac_responseArraySwiftyJSONCreated()

The `JSONCreated` protocol defines a single method for creating a model object from `JSON`:

	init(json:JSON) throws
	
Conformance is straight forward. You will probably be doing this at some point after your request so moving it to an initialiser is trivial:

	class MyClass {
		let name:String
		let age:Int?
	}

	extension MyClass: JSONCreated {
		init(json:JSON) throws {
			guard let name = json["name"].string.nonEmpty else {
				let error = NSError.missingElementErrorForJSON(json)
				throw(error)
			}
			
			self.name = name
			self.age = json["age"].int
		}
	}
	
Any model object conforming to `JSONCreated` can be serialized in the same way as the any other serialized `Alamofire` object.

	let p: SignalProducer<(JSON, MyClass), NSError>
	p = Alamofire.request(.GET, "https://httpbin.org/get", parameters: ["foo": "bar"])
         .validate()
         .rac_responseSwiftyJSONCreated()
         
As `MyClass` conforms to `JSONCreated` and the variable `p` is defined as taking `MyClass` the Swift compiler automatically knows the generic type parameters. If your initialiser were to throw and error, the `SignalProducer` sends a `.Failed(_)` event, otherwise a new `MyClass` object is returned from a `.Next(_)` followed by a `.Completed`.

Handling arrays or dictionaries of objects is just as simple:

	let p: SignalProducer<(JSON, [MyClass]), NSError>
	p = Alamofire.request(.GET, "https://httpbin.org/get", parameters: ["foo": "bar"])
         .validate()
         .rac_responseArraySwiftyJSONCreated()

	let p: SignalProducer<(JSON, [String:MyClass]), NSError>
	p = Alamofire.request(.GET, "https://httpbin.org/get", parameters: ["foo": "bar"])
         .validate()
         .rac_responseDictionarySwiftyJSONCreated()

Simpler, neater code is easier to understand and maintain. Reduce boilerplate and spend more time writing standout features for your app. See [ReactiveCocoaConvenience] for more ways you can speed up development using [ReactiveCocoa].

[ReactiveCocoaConvenience]: https://github.com/joshc89/ReactiveCocoaConvenience
[ReactiveCocoa]: https://github.com/ReactiveCocoa/ReactiveCocoa
[Alamofire]: https://github.com/Alamofire/Alamofire
[SwiftyJSON]: https://github.com/SwiftyJSON/SwiftyJSON