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

public extension Request {
    
    /**
     
     Convenience ReactiveCocoa response using a `swiftyJSONResponseSerializer()`.
     
     - seealso: `rac_response(_:responseSerializer:)`
     */
    public func rac_responseSwiftyJSON(queue: dispatch_queue_t? = nil) -> SignalProducer<JSON, NSError> {
        
        return rac_response(queue, responseSerializer: Request.swiftyJSONResponseSerializer())
    }
}