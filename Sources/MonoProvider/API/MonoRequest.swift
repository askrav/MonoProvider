//
//  MonoRequest.swift
//  MonoProvider
//
//  Created by Alexander Kravchenko on 03.08.2019.
//

import Vapor
import HTTP

public protocol MonoRequest: class {
    func send<MM: MonoModel>(method: HTTPMethod,
                             path: String,
                             query: String,
                             body: LosslessHTTPBodyRepresentable,
                             headers: HTTPHeaders) throws -> Future<MM>
    func serializedResponse<MM: MonoModel>(response: HTTPResponse,
                                           worker: EventLoop) throws -> Future<MM>
}

public extension MonoRequest {
    func send<MM: MonoModel>(method: HTTPMethod,
                                    path: String,
                                    query: String = "",
                                    body: LosslessHTTPBodyRepresentable = HTTPBody(string: ""),
                                    headers: HTTPHeaders = [:]) throws -> Future<MM> {
        return try send(method: method, path: path, query: query, body: body, headers: headers)
    }
    
    func serializedResponse<MM: MonoModel>(response: HTTPResponse, worker: EventLoop) throws -> Future<MM> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        print(response)
        guard response.status == .ok else {
            return
                try decoder
                .decode(MonoError.self, from: response, maxSize: 65_536, on: worker)
                .map(to: MM.self) { throw $0 }
        }
        return try decoder.decode(MM.self, from: response, maxSize: 65_536, on: worker)
    }
}

extension HTTPHeaders {
    public static var monoDefault: HTTPHeaders {
        var headers: HTTPHeaders = [:]
        headers.replaceOrAdd(name: .contentType, value: "application/json")
        return headers
    }
}

public class MonoPublicAPIRequest: MonoRequest {
    fileprivate let httpClient: Client
    
    init(httpClient: Client) {
        self.httpClient = httpClient
    }
    
    public func send<MM: MonoModel>(method: HTTPMethod,
                                    path: String,
                                    query: String,
                                    body: LosslessHTTPBodyRepresentable,
                                    headers: HTTPHeaders) throws -> Future<MM> {
        var finalHeaders: HTTPHeaders = .monoDefault
        headers.forEach { finalHeaders.replaceOrAdd(name: $0.name, value: $0.value) }

        let finalPath = query.isEmpty ? path : "\(path)?\(query)"

        return httpClient
            .send(method, headers: finalHeaders, to: finalPath) { request in
                request.http.body = body.convertToHTTPBody()
            }
            .flatMap(to: MM.self) { (response) -> Future<MM> in
                return
                    try self
                    .serializedResponse(response: response.http, worker: self.httpClient.container.eventLoop)
        }
    }
}

public class MonoPersonalAPIRequest: MonoPublicAPIRequest {
    private let xToken: String

    init(httpClient: Client, xToken: String) {
        self.xToken = xToken
        super.init(httpClient: httpClient)
    }
    
    public override func send<MM: MonoModel>(method: HTTPMethod,
                                             path: String,
                                             query: String,
                                             body: LosslessHTTPBodyRepresentable,
                                             headers: HTTPHeaders) throws -> Future<MM> {
        var finalHeaders: HTTPHeaders = .monoDefault
        print(path)
        finalHeaders.replaceOrAdd(name: "X-Token", value: xToken)
        headers.forEach { finalHeaders.replaceOrAdd(name: $0.name, value: $0.value) }
        return try super.send(method: method, path: path, query: query, body: body, headers: finalHeaders)
    }
}
