//
//  Alamofire+RAC.swift
//  TestReactive
//
//  Created by Josh Campion on 19/03/2016.
//  Copyright © 2016 Josh Campion. All rights reserved.
//

import Foundation

import Alamofire
import SwiftyJSON

import ReactiveCocoa

public extension Request {
    
    /**
     
     Adds a handler with the given `ResponseSerializer` to be called once the request has finished. 
     
     A `SignalProducer` is returned over a `Request` for use with `ReactiveCococa`. If the response is succesful, the serialized object is sent to the producer as a `.Next` event followed by a `.Completed` event. If the response fails, a `.Failed` event is sent to the producer.
     
     The Request is suspended until the producer starts, allowing typical `SignalProducer` behaviour.
     
     - parameter queue: The queue on which the response completion handler is dispatched.
     - parameter responseSerializer: The response serializer responsible for serializing the request, response, and data.
     
     - returns: A `SignalProducer` that resumes the `Request` on starting and receives the result of the `responseSerializer`.
    */
    public func rac_response<T: ResponseSerializerType>(queue: dispatch_queue_t? = nil, responseSerializer:T) -> SignalProducer<T.SerializedObject, NSError> {
        
        suspend()
        
        let (prod, obs) = SignalProducer<T.SerializedObject, NSError>.buffer(2)
        
        self.response(queue: queue,
            responseSerializer: responseSerializer) { (response) -> Void in
                
                switch response.result {
                    
                case .Success(let serialized):
                    obs.sendNext(serialized)
                    obs.sendCompleted()
                case .Failure(let error):
                    obs.sendFailed(error.copy() as NSError)
                }
        }
        
        return prod.on(started: { [weak self] () -> () in
            self?.resume()
            })
    }
    
    /**
     
     Convenience ReactiveCocoa response using a `dataResponseSerializer()`.
     
     - seealso: `rac_response(_:responseSerializer:)`
    */
    public func rac_responseData(queue: dispatch_queue_t? = nil) -> SignalProducer<NSData, NSError> {
        
        return rac_response(queue, responseSerializer: Request.dataResponseSerializer())
    }
    
    /**
     
     Convenience ReactiveCocoa response using a `stringResponseSerializer()`.
     
     - seealso: `rac_response(_:responseSerializer:)`
     */
    public func rac_responseString(queue: dispatch_queue_t? = nil) -> SignalProducer<String, NSError> {
        
        return rac_response(queue, responseSerializer: Request.stringResponseSerializer())
    }
    
    /**
     
     Convenience ReactiveCocoa response using a `JSONResponseSerializer()`.
     
     - seealso: `rac_response(_:responseSerializer:)`
     */
    public func rac_responseJSON(queue: dispatch_queue_t? = nil) -> SignalProducer<AnyObject, NSError> {
        
        return rac_response(queue, responseSerializer: Request.JSONResponseSerializer())
    }
    
    /**
     
     Convenience ReactiveCocoa response using a `propertyListResponseSerializer()`.
     
     - seealso: `rac_response(_:responseSerializer:)`
     */
    public func rac_responsePropertyList(queue: dispatch_queue_t? = nil) -> SignalProducer<AnyObject, NSError> {
        
        return rac_response(queue, responseSerializer: Request.propertyListResponseSerializer())
    }
}

