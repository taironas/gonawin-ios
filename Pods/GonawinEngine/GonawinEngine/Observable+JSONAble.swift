//
//  Observable+JSONAble.swift
//  GonawinEngine
//
//  Created by Remy JOURDE on 27/02/2016.
//  Copyright © 2016 Remy Jourde. All rights reserved.
//

import RxSwift

extension Observable {
    
    func mapToObject<B: JSONAble>(classType: B.Type) -> Observable<B> {
        return self.map { json in
            guard let dict = json as? JSONDictionary else {
                throw GonawinError.CouldNotParseJSON
            }
            
            return B.fromJSON(dict)
        }
    }
    
    func mapToObjectArray<B: JSONAble>(classType: B.Type) -> Observable<[B]> {
        return self.map { json in
            guard let array = json as? JSONArray else {
                throw GonawinError.CouldNotParseJSON
            }
            
            guard let dicts = array as? [JSONDictionary] else {
                throw GonawinError.CouldNotParseJSON
            }
            
            return dicts.map { B.fromJSON($0) }
        }
    }
}
