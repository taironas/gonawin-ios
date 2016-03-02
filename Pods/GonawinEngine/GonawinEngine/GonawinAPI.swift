//
//  GonawinAPI.swift
//  GonawinEngine
//
//  Created by Remy JOURDE on 26/02/2016.
//  Copyright © 2016 Remy Jourde. All rights reserved.
//

import Moya

protocol GonawinAPIType {
    var addAuthorization: Bool { get }
}

enum GonawinAPI {
    case Auth(String, String, Int, String, String)
}

enum GonawinAuthenticatedAPI {
    case User(Int)
}

extension GonawinAPI: TargetType, GonawinAPIType {
    var baseURL: NSURL { return NSURL(string: "http://www.gonawin.com/j")! }
    
    var path: String {
        switch self {
        case .Auth:
            return "/auth"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .GET
        }
    }
    
    var parameters: [String: AnyObject]? {
        switch self {
        case .Auth(let accessToken, let provider, let id, let email, let name):
            return [
                "access_token": accessToken,
                "provider": provider,
                "id": id,
                "email": email,
                "name": name
            ]
        }
    }
    
    var sampleData: NSData {
        switch self {
        case .Auth:
            return stubbedResponse("Auth")
        }
    }
    
    var addAuthorization: Bool {
        return false
    }
}

extension GonawinAuthenticatedAPI: TargetType, GonawinAPIType {
    var baseURL: NSURL { return NSURL(string: "http://www.gonawin.com/j")! }
    
    var path: String {
        switch self {
        case .User:
            return "/user"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .GET
        }
    }
    
    var parameters: [String: AnyObject]? {
        switch self {
        case .User(let id):
            return ["id": id]
        }
    }
    
    var sampleData: NSData {
        switch self {
        case .User:
            return stubbedResponse("User")
        }
    }
    
    var addAuthorization: Bool {
        return true
    }
}

// MARK - Provider support

func stubbedResponse(filename: String) -> NSData! {
    @objc class TestClass: NSObject { }
    
    let bundle = NSBundle(forClass: TestClass.self)
    let path = bundle.pathForResource(filename, ofType: "json")
    return NSData(contentsOfFile: path!)
}

func url(route: TargetType) -> String {
    return route.baseURL.URLByAppendingPathComponent(route.path).absoluteString
}
