//
//  Flow.swift
//  SwiftHeroes
//
//  Created by macbook abdul on 23/03/2024.
//

import Foundation

final class Flow<Route: Hashable>: ObservableObject {
	@Published var path = [Route]()

	func append(_ value: Route) {
		path.append(value)
	}

	func navigateBack() {
		path.removeLast()
	}
}
