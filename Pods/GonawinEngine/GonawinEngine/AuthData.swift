//
//  AuthData
//  GonawinEngine
//
//  Created by Remy JOURDE on 26/02/2016.
//  Copyright © 2016 Remy Jourde. All rights reserved.
//

public struct AuthData {
    let accessToken: String
    let provider: String
    let id: Int
    let email: String
    let name: String
    
    public init(accessToken: String, provider: String, id: Int, email: String, name: String) {
        self.accessToken = accessToken
        self.provider = provider
        self.id = id
        self.email = email
        self.name = name
    }
}
