//
//  GonawinEngine.swift
//  GonawinEngine
//
//  Created by Remy JOURDE on 26/02/2016.
//  Copyright © 2016 Remy Jourde. All rights reserved.
//

import Moya
import RxSwift

public protocol GonawinEngineType {
    associatedtype T: TargetType, GonawinAPIType
    var provider: RxMoyaProvider<T> { get }
}

extension GonawinEngineType {
    public static func newGonawinEngine() -> GonawinEngine {
        let provider = RxMoyaProvider<GonawinAPI>()
        return GonawinEngine(provider: provider)
    }
    
    public static func newAuthorizedGonawinEngine(_ authorizationToken: String) -> AuthorizedGonawinEngine {
        let provider = RxMoyaProvider<GonawinAuthenticatedAPI>(endpointClosure: endpointsClosure(authorizationToken))
        return AuthorizedGonawinEngine(provider: provider)
    }
    
    public static func newStubbingGonawinEngine() -> GonawinEngine {
        let provider = RxMoyaProvider<GonawinAPI>(stubClosure: MoyaProvider.ImmediatelyStub, plugins: [NetworkLoggerPlugin(verbose: true)])
        return GonawinEngine(provider: provider)
    }
    
    public static func newStubbingAuthorizedGonawinEngine() -> AuthorizedGonawinEngine {
        let provider = RxMoyaProvider<GonawinAuthenticatedAPI>(endpointClosure: endpointsClosure("testToken"), stubClosure: MoyaProvider.ImmediatelyStub, plugins: [NetworkLoggerPlugin(verbose: true)])
        return AuthorizedGonawinEngine(provider: provider)
    }
    
    static func endpointsClosure<T>(_ authorizationToken: String) -> (_ target: T) -> Endpoint<T> where T: TargetType, T: GonawinAPIType {
        return { target in
            let endpoint: Endpoint<T> = Endpoint<T>(URL: url(target), sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters)
        
            if target.addAuthorization {
                return endpoint.endpointByAddingHTTPHeaderFields(["Authorization": authorizationToken])
            } else {
                return endpoint
            }
        }
    }
}

public struct GonawinEngine: GonawinEngineType {
    public let provider: RxMoyaProvider<GonawinAPI>
    
    public func authenticate(_ authData: AuthData) -> Observable<User> {
        
        let endPoint = GonawinAPI.auth(authData.accessToken, authData.provider, authData.id, authData.email, authData.name)
        
        return provider.request(endPoint)
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapToObject(User.self)
    }
}

public struct AuthorizedGonawinEngine: GonawinEngineType {
    public let provider: RxMoyaProvider<GonawinAuthenticatedAPI>
    
    public init(provider: RxMoyaProvider<GonawinAuthenticatedAPI>) {
        self.provider = provider
    }
    
    public func getUser(_ id: Int) -> Observable<User> {
        
        let endPoint = GonawinAuthenticatedAPI.user(id)
        
        return provider.request(endPoint)
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapToObject(User.self)
    }
    
    public func getActivities(_ page: Int, count: Int) -> Observable<[Activity]>
    {
        let endPoint = GonawinAuthenticatedAPI.activities(page, count)
        
        return provider.request(endPoint)
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapToObject(ActivityResults.self)
            .map{ $0.activities }
    }
    
    public func getTeams(_ page: Int, count: Int) -> Observable<[Team]>
    {
        let endPoint = GonawinAuthenticatedAPI.teams(page, count)
        
        return provider.request(endPoint)
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapToObjectArray(Team.self)
    }
    
    public func getTeam(_ id: Int) -> Observable<Team> {
        
        let endPoint = GonawinAuthenticatedAPI.team(id)
        
        return provider.request(endPoint)
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapToObject(Team.self)
    }
    
    public func getTournaments(_ page: Int, count: Int) -> Observable<[Tournament]>
    {
        let endPoint = GonawinAuthenticatedAPI.tournaments(page, count)
        
        return provider.request(endPoint)
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapToObjectArray(Tournament.self)
    }
    
    public func getTournament(_ id: Int) -> Observable<Tournament> {
        
        let endPoint = GonawinAuthenticatedAPI.tournament(id)
        
        return provider.request(endPoint)
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapToObject(Tournament.self)
    }
    
    public func getTournamentCalendar(_ id: Int) -> Observable<TournamentCalendar> {
        
        let endPoint = GonawinAuthenticatedAPI.tournamentCalendar(id)
        
        return provider.request(endPoint)
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapToObject(TournamentCalendar.self)
    }
    
    public func getTournamentMatchPredict(_ id: Int, matchId: Int, homeTeamScore: Int, awayTeamScore: Int) -> Observable<Predict> {
        
        let endPoint = GonawinAuthenticatedAPI.tournamentMatchPredict(id, matchId, homeTeamScore, awayTeamScore)
        
        return provider.request(endPoint)
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapToObject(Predict.self)
    }
}
