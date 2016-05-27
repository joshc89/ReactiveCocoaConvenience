# ReactiveCocoaConvenience-Alamofire

[ReactiveCocoa] SignalProducers for Alamofire.

This is a sub-framework of a [ReactiveCocoaConvenience].  There are more sub-frameworks adding extra [ReactiveCocoa] functionality including one adding [SwiftyJSON] support with [ReactiveCocoa] and [Alamofire]. This project is [fully documented](http://joshc89.github.io/ReactiveCocoaConvenience/ReactiveCocoaConvenience-Alamofire/index.html). 

## Features

* [x] Typed serialized `SignalProducer`s for [Alamofire] Requests
* [x] [Documentation](http://joshc89.github.io/ReactiveCocoaConvenience/ReactiveCocoaConvenience-Alamofire/index.html)

## Dependencies

* [ReactiveCocoa]
* Result
* [Alamofire]

## Examples

Network requests can be done using NSURLSession methods from [ReactiveCocoa]:

	let searchResults = searchStrings
        .flatMap(.Latest) { (query: String) -> SignalProducer<(NSData, NSURLResponse), NSError> in
            let URLRequest = self.searchRequestWithEscapedQuery(query)
            return NSURLSession.sharedSession().rac_dataWithRequest(URLRequest)
        }
        .map { (data, URLResponse) -> String in
            let string = String(data: data, encoding: NSUTF8StringEncoding)!
            return self.parseJSONResultsFromString(string)
        }
        .observeOn(UIScheduler())
        
This is great functionality however 3rd party libraries can offer simplifications to NSURLSession APIs. [Alamofire] "Elegant HTTP Networking in Swift" is a great library. Network requests are made as follows:

	Alamofire.request(.GET, "https://httpbin.org/get", parameters: ["foo": "bar"])
         .validate()
         .responseJSON { response in
             switch response.result {
             case .Success:
                 print("Validation Successful")
             case .Failure(let error):
                 print(error)
             }
         }
         
Completion closure based APIs don't natually fit with ReactiveCocoa and make it hard to chain signals together. Using ReactiveCocoaConvenience-Alamofire, a `SignalProducer` can be created for this request:

	let p: SignalProducer<AnyObject, NSError>
	p = Alamofire.request(.GET, "https://httpbin.org/get", parameters: ["foo": "bar"])
         .validate()
         .rac_responseJSON()
         
[Alamofire] provides Built-in Response Methods:

* `response()`
* `responseData()`
* `responseString(encoding: NSStringEncoding)`
* `responseJSON(options: NSJSONReadingOptions)`
* `responsePropertyList(options: NSPropertyListReadOptions)`

Each of these has a ReactiveCocoa equivalent

* `rac_response()`
* `rac_responseData()`
* `rac_responseString(encoding: NSStringEncoding)`
* `rac_responseJSON(options: NSJSONReadingOptions)`
* `rac_responsePropertyList(options: NSPropertyListReadOptions)`

ReactiveCocoaConvenience-Alamofire-SwiftyJSON takes this a stage further by support for SwiftyJSON `JSON` object serialisation and adding initialisation of any object that can be initialised with a `JSON` object.

Simpler, neater code is easier to understand and maintain. Reduce boilerplate and spend more time writing standout features for your app. See [ReactiveCocoaConvenience] for more ways you can speed up development using [ReactiveCocoa].

[ReactiveCocoaConvenience]: https://github.com/joshc89/ReactiveCocoaConvenience
[ReactiveCocoa]: https://github.com/ReactiveCocoa/ReactiveCocoa
[Alamofire]: https://github.com/Alamofire/Alamofire
[SwiftyJSON]: https://github.com/SwiftyJSON/SwiftyJSON