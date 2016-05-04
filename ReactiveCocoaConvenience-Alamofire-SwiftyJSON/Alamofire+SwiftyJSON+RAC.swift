//
//  Alamofire+SwiftyJSON+RAC.swift
//  TestReactive
//
//  Created by Josh Campion on 19/03/2016.
//  Copyright © 2016 Josh Campion. All rights reserved.
//

import Foundation

import Alamofire
import SwiftyJSON

import ReactiveCocoa

import ReactiveCocoaConvenience_Alamofire

public let JSONResponseErrorDomain = "JSONResponseError"
public let JSONResponseUnexpectedTypeCode = 0
public let JSONResponseMissingElementCode = 0

public extension NSError {
    
    public static func unexpectedTypeErrorForJSON(json:JSON,
        expectedType:Type,
        localizedDescription: String = "Unable to create object.",
        localizedFailureReason: String = "Unexpected JSON format. Expected '%@', got '%@'") -> NSError {
        
            let failureReason = String(format: localizedFailureReason, arguments: ["\(expectedType)", "\(json.type)"])
            
            return NSError(domain: JSONResponseErrorDomain,
                code: JSONResponseUnexpectedTypeCode,
                userInfo: [NSLocalizedDescriptionKey: localizedDescription,
                    NSLocalizedFailureReasonErrorKey: failureReason])
    }
    
    public static func missingElementErrorForJSON(json:JSON,
        localizedDescription: String = "Unable to create object.",
        localizedFailureReason: String = "Missing required elements.") -> NSError {
            
            return NSError(domain: JSONResponseErrorDomain,
                code: JSONResponseUnexpectedTypeCode,
                userInfo: [NSLocalizedDescriptionKey: localizedDescription,
                    NSLocalizedFailureReasonErrorKey: localizedFailureReason])
    }
}

public extension Request {
    
    /**
     
     Convenience ReactiveCocoa response using a `swiftyJSONResponseSerializer()`.
     
     - seealso: `rac_response(_:responseSerializer:)`
     */
    public func rac_responseSwiftyJSON(queue: dispatch_queue_t? = nil) -> SignalProducer<JSON, NSError> {
        
        return SignalProducer<JSON, NSError>.init { (observer, _) in
            
            self.response(queue: queue, responseSerializer: Request.swiftyJSONResponseSerializer()) { (response) -> Void in
                
                switch response.result {
                    
                case .Success(let serialized):
                    observer.sendNext(serialized)
                    observer.sendCompleted()
                case .Failure(let error):
                    observer.sendFailed(error as NSError)
                }
                
            }
        }
    }
    
    /**
     
     Convenience ReactiveCocoa response using a `swiftyJSONResponseSerializer()` that transforms the `JSON` to a `JSONCreated` object.
     
     - returns: A `SignalProducer` with either the `JSONCreated` object as its value or the thrown error from `init(json:)`.
     
     - seealso: `rac_responseSwiftyJSON(_:)`
     */
    public func rac_responseSwiftyJSONCreated<T:JSONCreated>(queue: dispatch_queue_t? = nil) -> SignalProducer<(JSON, T), NSError> {
        
        return SignalProducer<JSON, NSError>.init { (observer, _) in
            
            self.response(queue: queue, responseSerializer: Request.swiftyJSONResponseSerializer()) { (response) -> Void in
                
                switch response.result {
                    
                case .Success(let serialized):
                    observer.sendNext(serialized)
                    observer.sendCompleted()
                case .Failure(let error):
                    observer.sendFailed(error as NSError)
                }
                
            }
            }
            .flatMap(.Latest) { (json) -> SignalProducer<(JSON, T), NSError> in
                
                do {
                    let created = try T.init(json: json)
                    return SignalProducer(value: (json, created))
                } catch let error as NSError {
                    return SignalProducer(error: error)
                }
        }
    }
    
    /**
     
     Convenience ReactiveCocoa response using a `swiftyJSONResponseSerializer()` that transforms the `JSON` to an array of `JSONCreated` objects.
     
     - returns: A `SignalProducer` with an array of all the `JSONCreated` objects that didn't throw errors. The original JSON is returned alongside the transformed objects for transparency. This allows the caller to check the JSON count against the transformed count. If the `JSON` returned from the `swiftyJSONResponseSerializer()` is not an `Array` the `SignalProducer` has an error created from `unexpectedTypeErrorForJSON(_:expectedType:)`.
     
     - seealso: `rac_responseSwiftyJSON(_:)`
     */
    public func rac_responseArraySwiftyJSONCreated<T:JSONCreated>(queue: dispatch_queue_t? = nil) -> SignalProducer<(JSON, [T]), NSError> {
        
        return SignalProducer<JSON, NSError>.init { (observer, _) in
            
            self.response(queue: queue, responseSerializer: Request.swiftyJSONResponseSerializer()) { (response) -> Void in
                
                switch response.result {
                    
                case .Success(let serialized):
                    observer.sendNext(serialized)
                    observer.sendCompleted()
                case .Failure(let error):
                    observer.sendFailed(error as NSError)
                }
                
            }
            }
            .flatMap(.Latest) { (json) -> SignalProducer<(JSON, [T]), NSError> in
                
                if let jsonArray = json.array {
                    
                    let created = jsonArray.flatMap({ try? T(json: $0) })
                    return SignalProducer(value: (json, created))
                    
                } else {
                    let error = NSError.unexpectedTypeErrorForJSON(json, expectedType: .Array)
                    return SignalProducer(error: error)
                }
        }
    }
    
    /**
     
     Convenience ReactiveCocoa response using a `swiftyJSONResponseSerializer()` that transforms the `JSON` to a dictionary of `JSONCreated` objects.
     
     - returns: A `SignalProducer` with an dictionary of all the `JSONCreated` objects that didn't throw errors. The original JSON is returned alongside the transformed objects for transparency. This allows the caller to check the JSON count against the transformed count. If the `JSON` returned from the `swiftyJSONResponseSerializer()` is not a `Dictionary` the `SignalProducer` has an error created from `unexpectedTypeErrorForJSON(_:expectedType:)`.
     
     - seealso: `rac_responseSwiftyJSON(_:)`
     */
    public func rac_responseDictionarySwiftyJSONCreated<T:JSONCreated>(queue: dispatch_queue_t? = nil) -> SignalProducer<(JSON, [String:T]), NSError> {
        
        return SignalProducer<JSON, NSError>.init { (observer, _) in
            
            self.response(queue: queue, responseSerializer: Request.swiftyJSONResponseSerializer()) { (response) -> Void in
                
                switch response.result {
                    
                case .Success(let serialized):
                    observer.sendNext(serialized)
                    observer.sendCompleted()
                case .Failure(let error):
                    observer.sendFailed(error as NSError)
                }
                
            }
            }

            .flatMap(.Latest) { (json) -> SignalProducer<(JSON, [String:T]), NSError> in
                
                if let jsonDictionary = json.dictionary {
                    
                    var transformed = [String:T](minimumCapacity: jsonDictionary.count)
                    
                    for (key, elementJSON) in jsonDictionary {
                        if let element = try? T(json: elementJSON) {
                            transformed[key] = element
                        }
                    }
                    
                    return SignalProducer(value: (json, transformed))
                    
                } else {
                    let error = NSError.unexpectedTypeErrorForJSON(json, expectedType: .Dictionary)
                    return SignalProducer(error: error)
                }
        }
    }
    
}