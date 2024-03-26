//
//  RootFactory.swift
//  SwiftHeroes
//
//  Created by macbook abdul on 23/03/2024.
//

import Foundation
import Core

final class TreeNodeFactory {
	static func treeLoader(baseURL: URL) -> RemoteTreeNodeLoader {
		let session = URLSession(configuration: .ephemeral)
		let httpClient = URLSessionHTTPAdapter(session: session)
		let remoteTreeLoader = RemoteTreeNodeLoader(url: baseURL, client: httpClient)
        
		return remoteTreeLoader
	}
}


