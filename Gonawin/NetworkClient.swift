//
//  NetworkClient.swift
//  Gonawin
//
//  Created by Remy JOURDE on 13/09/2014.
//  Copyright (c) 2014 Taironas. All rights reserved.
//

import Foundation
import Alamofire

func performRequest<A: JSONDecodable>(request: NSURLRequest, callback: (Result<A>) -> ()) {
    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, urlResponse, error in
        callback(parseResult(data, urlResponse, error))
    }
    task.resume()
}

func parseResult<A: JSONDecodable>(data: NSData!, urlResponse: NSURLResponse!, error: NSError!) -> Result<A> {
    let responseResult = Result(error, Response(data: data, urlResponse: urlResponse))
    return responseResult >>> parseResponse
                          >>> decodeJSON
                          >>> decodeObject
}

func parseResponse(response: Response) -> Result<NSData> {
    let successRange = 200..<300
    if !contains(successRange, response.statusCode) {
        return .Error(NSError()) // customize the error message to your liking
    }
    return Result(nil, response.data)
}