//
//  PlaceholderAPI.swift
//  EcoTravel
//
//  Created by iosdev on 16.4.2021.
//

import Foundation
import Apollo

class Network{
    private let endPoint = "https://api.digitransit.fi/routing/v1/routers/hsl/index/graphql"
    static let shared = Network()
    lazy var apollo = ApolloClient(url: URL(string: endPoint)!)
    
}
