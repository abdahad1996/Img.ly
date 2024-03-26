//
//  LeafNodeFactory.swift
//  IMGLY
//
//  Created by macbook abdul on 26/03/2024.
//

import Foundation
import Core

final class LeafFactory {
    
    static func remoteLeafNodeLoader(baseURL: URL, id: String) -> RemoteLeafNodeLoader {
        let session = URLSession(configuration: .ephemeral)
        let httpClient = URLSessionHTTPAdapter(session: session)
        let remoteleafNodeLoader = RemoteLeafNodeLoader(url: baseURL, client: httpClient)
        return remoteleafNodeLoader
    }
}
