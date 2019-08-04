//
//  Provider.swift
//  MonoProvider
//
//  Created by Alexander Kravchenko on 03.08.2019.
//

import Vapor

public struct MonoPublicConfig: Service {}

public struct MonoPersonalConfig: Service {
    public let xToken: String
    
    public init(xToken: String) {
        self.xToken = xToken
    }
}

public final class MonoPublicProvider: Provider {
    
    public func register(_ services: inout Services) throws {
        services.register { container -> MonoPublicClient in
            let httpClient = try container.make(Client.self)
            return MonoPublicClient(client: httpClient)
        }
    }
    
    public func didBoot(_ container: Container) throws -> EventLoopFuture<Void> {
        return .done(on: container)
    }
}

public final class MonoPersonalProvider: Provider {
    
    public func register(_ services: inout Services) throws {
        services.register { container -> MonoPersonalClient in
            let httpClient = try container.make(Client.self)
            let config = try container.make(MonoPersonalConfig.self)
            let xToken = config.xToken
            return MonoPersonalClient(xToken: xToken, client: httpClient)
        }
    }
    
    public func didBoot(_ container: Container) throws -> EventLoopFuture<Void> {
        return .done(on: container)
    }
}

public class MonoPublicClient: Service {
    public var currencies: MonoCurrencyRoutes
    
    init(client: Client) {
        let apiRequest = MonoPublicAPIRequest(httpClient: client)
        currencies = MonoCurrencyRoutes(request: apiRequest)
    }
}

public final class MonoPersonalClient: MonoPublicClient {
    public var personal: MonoPersonalRoutes

    init(xToken: String, client: Client) {
        let apiRequest = MonoPersonalAPIRequest(httpClient: client, xToken: xToken)
        personal = MonoPersonalRoutes(request: apiRequest)
        super.init(client: client)
    }
}
