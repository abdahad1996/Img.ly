//
//  LeafNodeFactory.swift
//  IMGLY
//
//  Created by macbook abdul on 26/03/2024.
//

import Core
import Foundation

final class LeafFactory {

    static func localLeafNodeLoader() -> LocalLeafNodeLoader {
        let localURL = FileManager.default.urls(
            for: .cachesDirectory, in: .userDomainMask
        ).first!.appendingPathComponent("leaf.store")
        let localStore = CodableFileSystemAdapter(storeURL: localURL)
        let localLeafNodeLoader = LocalLeafNodeLoader(
            store: localStore, currentDate: Date.init)

        return localLeafNodeLoader
    }
    static func remoteLeafNodeLoader(baseURL: URL, id: String)
        -> RemoteLeafNodeLoader
    {
        let session = URLSession(configuration: .ephemeral)
        let httpClient = URLSessionHTTPAdapter(session: session)
        let remoteleafNodeLoader = RemoteLeafNodeLoader(
            url: baseURL, client: httpClient)
        return remoteleafNodeLoader
    }
}
