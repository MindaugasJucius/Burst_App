//
//  User.swift
//  Burst
//
//  Created by Mindaugas Jucius on 25/06/16.
//  Copyright © 2016 mindaugo.kompanija.limited. All rights reserved.
//

import Unbox

class User: NSObject, Unboxable {

    let id: String
    let name: String
    let portfolioURL: String?
    let username: String
    
    required init(unboxer: Unboxer) {
        self.id = unboxer.unbox("id")
        self.name = unboxer.unbox("name")
        self.portfolioURL = unboxer.unbox("portfolio_url")
        self.username = unboxer.unbox("username")
    }
    
    init(id: String, name: String, portfolioURL: String?, username: String) {
        self.id = id
        self.name = name
        self.portfolioURL = portfolioURL
        self.username = username
        super.init()
    }
}
