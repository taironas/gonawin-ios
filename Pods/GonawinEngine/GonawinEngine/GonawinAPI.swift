//
//  GonawinAPI.swift
//  GonawinEngine
//
//  Created by Remy JOURDE on 26/02/2016.
//  Copyright © 2016 Remy Jourde. All rights reserved.
//

import Moya

public protocol GonawinAPIType {
    var addAuthorization: Bool { get }
}

public enum GonawinAPI {
    case Auth(String, String, Int, String, String)
}

public enum GonawinAuthenticatedAPI {
    case User(Int)
    case Activities(Int, Int)
}

extension GonawinAPI: TargetType, GonawinAPIType {
    public var baseURL: NSURL { return NSURL(string: "http://www.gonawin.com/j")! }
    
    public var path: String {
        switch self {
        case .Auth:
            return "/auth"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        default:
            return .GET
        }
    }
    
    public var parameters: [String: AnyObject]? {
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
    
    public var sampleData: NSData {
        switch self {
        case .Auth:
            return stubbedResponse("Auth")
        }
    }
    
    public var addAuthorization: Bool {
        return false
    }
}

extension GonawinAuthenticatedAPI: TargetType, GonawinAPIType {
    public var baseURL: NSURL { return NSURL(string: "http://www.gonawin.com/j")! }
    
    public var path: String {
        switch self {
        case .User(let id):
            return "/users/show/\(id)"
        case .Activities:
            return "/activities"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        default:
            return .GET
        }
    }
    
    public var parameters: [String: AnyObject]? {
        switch self {
        case .Activities(let page, let count):
            return ["page": page, "count": count]
        default:
            return nil
        }
    }
    
    public var sampleData: NSData {
        switch self {
        case .User:
            return stubbedResponse("User")
        case .Activities:
            return stubbedResponse("Activities")
        }
    }
    
    public var addAuthorization: Bool {
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
