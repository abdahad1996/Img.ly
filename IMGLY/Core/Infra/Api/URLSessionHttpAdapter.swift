//
//  URLSessionHttpAdapter.swift
//  Core
//
//  Created by macbook abdul on 25/03/2024.
//

import Foundation

public class URLSessionHTTPAdapter: HTTPClient {
    private let session: URLSession

    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    struct UnexpectedRepresentation: Error {}

    public func get(from url: URL) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await session.data(from: url)
        guard let response = response as? HTTPURLResponse else {
            throw UnexpectedRepresentation()
        }

        return (data, response)
    }
}
