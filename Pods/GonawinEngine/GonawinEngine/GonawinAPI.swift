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
    case Teams(Int, Int)
    case Team(Int)
    case Tournaments(Int, Int)
    case Tournament(Int)
    case TournamentCalendar(Int)
    case TournamentMatchPredict(Int, Int, Int, Int)
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
    
    public var multipartBody: [MultipartFormData]? {
        return nil
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
        case .Teams:
            return "/teams"
        case .Team(let id):
            return "/teams/show/\(id)"
        case .Tournaments:
            return "/tournaments"
        case .Tournament(let id):
            return "/tournaments/show/\(id)"
        case .TournamentCalendar(let id):
            return "tournaments/\(id)/calendar"
        case .TournamentMatchPredict(let id, let matchId, _, _):
            return "tournaments/\(id)/matches/\(matchId)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .TournamentMatchPredict:
            return .POST
        default:
            return .GET
        }
    }
    
    public var parameters: [String: AnyObject]? {
        switch self {
        case .Activities(let page, let count):
            return ["page": page, "count": count]
        case .Teams(let page, let count):
            return ["page": page, "count": count]
        case .Tournaments(let page, let count):
            return ["page": page, "count": count]
        case .TournamentMatchPredict(_, _, let homeTeamScore, let awayTeamScore):
            return ["result1": homeTeamScore, "result2": awayTeamScore]
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
        case .Teams:
            return stubbedResponse("Teams")
        case .Team:
            return stubbedResponse("Team")
        case .Tournaments:
            return stubbedResponse("Tournaments")
        case .Tournament:
            return stubbedResponse("Tournament")
        case .TournamentCalendar:
            return stubbedResponse("TournamentCalendar")
        case .TournamentMatchPredict:
            return stubbedResponse("TournamentMatchPredict")
        }
    }
    
    public var multipartBody: [MultipartFormData]? {
        return nil
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
