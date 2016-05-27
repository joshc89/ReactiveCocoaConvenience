//
//  Alamofire+RAC.swift
//  TestReactive
//
//  Created by Josh Campion on 19/03/2016.
//  Copyright © 2016 Josh Campion. All rights reserved.
//

import Foundation

import Alamofire
import ReactiveCocoa

/// Extension to `Alamofire.Request` providing ReactiveCocoa signals for each of the `.response...()` methods.
public extension Request {
    
    /**
     
     A `SignalProducer` is returned over a `Request` for use with `ReactiveCococa`. If the response is succesful, the serialized object is sent to the producer as a `.Next(_)` event followed by a `.Completed` event. If the response fails, a `.Failed` event is sent to the producer.
     
     - parameter queue: The queue on which the response completion handler is dispatched.
     - parameter responseSerializer: The response serializer responsible for serializing the request, response, and data.
     
     - returns: A `SignalProducer` that schedules a handler with the given `responseSerializer` on `start()`.
    */
    public func rac_response<T: ResponseSerializerType>(queue: dispatch_queue_t? = nil, responseSerializer:T) -> SignalProducer<T.SerializedObject, NSError> {
        
        return SignalProducer<T.SerializedObject, NSError>.init { (observer, _) in
            
            self.response(queue: queue, responseSerializer: responseSerializer, completionHandler: { (response) in
                switch response.result {
                    
                case .Success(let serialized):
                    observer.sendNext(serialized)
                    observer.sendCompleted()
                case .Failure(let error):
                    observer.sendFailed(error as NSError)
                }
            })
        }
    }
    
    /**
     
     Convenience ReactiveCocoa response using a `dataResponseSerializer()`.
     
     - seealso: `rac_response(_:responseSerializer:)`
    */
    public func rac_responseData(queue: dispatch_queue_t? = nil) -> SignalProducer<NSData, NSError> {
        
        return SignalProducer<NSData, NSError>.init { (observer, _) in
            
            self.response(queue: queue, responseSerializer: Request.dataResponseSerializer()) { (response) -> Void in
                
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
     
     Convenience ReactiveCocoa response using a `stringResponseSerializer()`.
     
     - seealso: `rac_response(_:responseSerializer:)`
     */
    public func rac_responseString(queue: dispatch_queue_t? = nil) -> SignalProducer<String, NSError> {
        
        return SignalProducer<String, NSError>.init { (observer, _) in
            
            self.response(queue: queue, responseSerializer: Request.stringResponseSerializer()) { (response) -> Void in
                
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
     
     Convenience ReactiveCocoa response using a `JSONResponseSerializer()`.
     
     - seealso: `rac_response(_:responseSerializer:)`
     */
    public func rac_responseJSON(queue: dispatch_queue_t? = nil) -> SignalProducer<AnyObject, NSError> {
        
        return SignalProducer<AnyObject, NSError>.init { (observer, _) in
            
            self.response(queue: queue, responseSerializer: Request.JSONResponseSerializer()) { (response) -> Void in
                
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
     
     Convenience ReactiveCocoa response using a `propertyListResponseSerializer()`.
     
     - seealso: `rac_response(_:responseSerializer:)`
     */
    public func rac_responsePropertyList(queue: dispatch_queue_t? = nil) -> SignalProducer<AnyObject, NSError> {
        
        return SignalProducer<AnyObject, NSError>.init { (observer, _) in
            
            self.response(queue: queue, responseSerializer: Request.propertyListResponseSerializer()) { (response) -> Void in
                
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
}

