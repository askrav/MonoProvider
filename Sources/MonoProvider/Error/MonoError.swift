//
//  MonoError.swift
//  MonoProvider
//
//  Created by Alexander Kravchenko on 03.08.2019.
//

import Vapor

public struct MonoError: MonoModel, Error, Debuggable {
    public var identifier: String {
        // TODO: parse the error code
        return self.error.description
    }
    
    public var reason: String {
        return self.error.description
    }
    
    public var error: String

    public enum CodingKeys: String, CodingKey {
        case error = "errorDescription"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.error = try container.decode(String.self, forKey: .error)
    }
}
