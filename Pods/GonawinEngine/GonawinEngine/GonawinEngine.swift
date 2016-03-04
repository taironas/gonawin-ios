//
//  GonawinEngine.swift
//  GonawinEngine
//
//  Created by Remy JOURDE on 26/02/2016.
//  Copyright © 2016 Remy Jourde. All rights reserved.
//

import Moya
import RxSwift
import SwiftyUserDefaults

public protocol GonawinEngineType {
    typealias T: TargetType, GonawinAPIType
    var provider: RxMoyaProvider<T> { get }
}

extension GonawinEngineType {
    public static func newGonawinEngine() -> GonawinEngine {
        let provider = RxMoyaProvider<GonawinAPI>(endpointClosure: endpointsClosure())
        return GonawinEngine(provider: provider)
    }
    
    public static func newAuthorizedGonawinEngine() -> AuthorizedGonawinEngine {
        let provider = RxMoyaProvider<GonawinAuthenticatedAPI>(endpointClosure: endpointsClosure())
        return AuthorizedGonawinEngine(provider: provider)
    }
    
    public static func newStubbingGonawinEngine() -> GonawinEngine {
        let provider = RxMoyaProvider<GonawinAPI>(plugins: [NetworkLoggerPlugin(verbose: true)], stubClosure: MoyaProvider.ImmediatelyStub)
        return GonawinEngine(provider: provider)
    }
    
    public static func newStubbingAuthorizedGonawinEngine() -> AuthorizedGonawinEngine {
        let provider = RxMoyaProvider<GonawinAuthenticatedAPI>(plugins: [NetworkLoggerPlugin(verbose: true)], stubClosure: MoyaProvider.ImmediatelyStub)
        return AuthorizedGonawinEngine(provider: provider)
    }
    
    static func endpointsClosure<T where T: TargetType, T: GonawinAPIType>()(target: T) -> Endpoint<T> {
        let endpoint: Endpoint<T> = Endpoint<T>(URL: url(target), sampleResponseClosure: {.NetworkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters)
        
        if target.addAuthorization {
            return endpoint.endpointByAddingHTTPHeaderFields(["Authorization": Defaults[.authorization]])
        } else {
            return endpoint
        }
    }
}

public struct GonawinEngine: GonawinEngineType {
    public let provider: RxMoyaProvider<GonawinAPI>
    
    public func authenticate(authData: AuthData) -> Observable<User> {
        
        let endPoint = GonawinAPI.Auth(authData.accessToken, authData.provider, authData.id, authData.email, authData.name)
        
        return provider.request(endPoint)
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapToObject(User)
    }
}

public struct AuthorizedGonawinEngine: GonawinEngineType {
    public let provider: RxMoyaProvider<GonawinAuthenticatedAPI>
    
    public init(provider: RxMoyaProvider<GonawinAuthenticatedAPI>) {
        self.provider = provider
    }
    
    public func getUser(id: Int) -> Observable<User> {
        
        let endPoint = GonawinAuthenticatedAPI.User(id)
        
        return provider.request(endPoint)
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapToObject(User)
    }
}