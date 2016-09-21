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
    case auth(String, String, Int, String, String)
}

public enum GonawinAuthenticatedAPI {
    case user(Int)
    case activities(Int, Int)
    case teams(Int, Int)
    case team(Int)
    case tournaments(Int, Int)
    case tournament(Int)
    case tournamentCalendar(Int)
    case tournamentMatchPredict(Int, Int, Int, Int)
}

extension GonawinAPI: TargetType, GonawinAPIType {

    public var baseURL: URL { return URL(string: "http://www.gonawin.com/j")! }
    
    public var path: String {
        switch self {
        case .auth:
            return "/auth"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        default:
            return .GET
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .auth(let accessToken, let provider, let id, let email, let name):
            return [
                "access_token": accessToken,
                "provider": provider,
                "id": id,
                "email": email,
                "name": name
            ]
        }
    }
    
    public var task: Task {
        return .request
    }
    
    public var sampleData: Data {
        switch self {
        case .auth:
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
    public var baseURL: URL { return URL(string: "http://www.gonawin.com/j")! }
    
    public var path: String {
        switch self {
        case .user(let id):
            return "/users/show/\(id)"
        case .activities:
            return "/activities"
        case .teams:
            return "/teams"
        case .team(let id):
            return "/teams/show/\(id)"
        case .tournaments:
            return "/tournaments"
        case .tournament(let id):
            return "/tournaments/show/\(id)"
        case .tournamentCalendar(let id):
            return "tournaments/\(id)/calendar"
        case .tournamentMatchPredict(let id, let matchId, _, _):
            return "tournaments/\(id)/matches/\(matchId)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .tournamentMatchPredict:
            return .POST
        default:
            return .GET
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .activities(let page, let count):
            return ["page": page, "count": count]
        case .teams(let page, let count):
            return ["page": page, "count": count]
        case .tournaments(let page, let count):
            return ["page": page, "count": count]
        case .tournamentMatchPredict(_, _, let homeTeamScore, let awayTeamScore):
            return ["result1": homeTeamScore, "result2": awayTeamScore]
        default:
            return nil
        }
    }
    
    public var sampleData: Data {
        switch self {
        case .user:
            return stubbedResponse("User")
        case .activities:
            return stubbedResponse("Activities")
        case .teams:
            return stubbedResponse("Teams")
        case .team:
            return stubbedResponse("Team")
        case .tournaments:
            return stubbedResponse("Tournaments")
        case .tournament:
            return stubbedResponse("Tournament")
        case .tournamentCalendar:
            return stubbedResponse("TournamentCalendar")
        case .tournamentMatchPredict:
            return stubbedResponse("TournamentMatchPredict")
        }
    }
    
    public var task: Task {
        return .request
    }
    
    public var multipartBody: [MultipartFormData]? {
        return nil
    }
    
    public var addAuthorization: Bool {
        return true
    }
}

// MARK - Provider support

func stubbedResponse(_ filename: String) -> Data! {
    @objc class TestClass: NSObject { }
    
    let bundle = Bundle(for: TestClass.self)
    let path = bundle.path(forResource: filename, ofType: "json")
    return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
}

func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}
