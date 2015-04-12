//
//  Router.swift
//  Gonawin
//
//  Created by Remy JOURDE on 14/03/2015.
//  Copyright (c) 2015 Taironas. All rights reserved.
//

import Alamofire

enum Router: URLRequestConvertible {
    static let baseURL = "http://www.gonawin.com/j"
    static var authToken: String?
    
    case Auth(accessToken: String, provider: String, id: String, email: String, name: String)
    case User(id: Int)
    case Activities(page: Int, count: Int)
    
    var method: Alamofire.Method {
        switch self {
        case .Auth:
            return .GET
        case .User:
            return .GET
        case .Activities:
            return .GET
        }
    }
    
    var URLRequest: NSURLRequest {
        let (path: String, parameters: [String:AnyObject]?) = {
            switch self {
            case .Auth(let accessToken, let provider, let id, let email, let name):
                return ("/auth/", ["access_token": accessToken, "provider": provider, "id": id, "email": email, "name": name])
            case .User(let id):
                return ("/users/", ["id": id])
            case .Activities(let page, let count):
                return ("/activities/", ["page": page, "count": count])
            }
        }()
        
        let URL = NSURL(string: Router.baseURL)!
        let URLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        URLRequest.HTTPMethod = method.rawValue
        
        if let authToken = Router.authToken
        {
            URLRequest.setValue(authToken, forHTTPHeaderField: "Authorization")
        }
        
        let encoding = Alamofire.ParameterEncoding.URL
        
        return encoding.encode(URLRequest, parameters: parameters).0
    }
}
