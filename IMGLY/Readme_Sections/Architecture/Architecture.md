## Architecture

### Overview

For this project, I organized the codebase layers or Horizontal Slicing in which Domain, Api, and Infrastructure Layers are encapsulated in a framework Core but separated internally using Dependency Inversion. Since Everything is Decoupled it's easy to switch between different architectures and implementations.

> ❗️ High-level modules should not depend on lower-level modules and lower-level modules should only communicate and know about the next higher-level layer.

The following diagram shows a high-level structure of the whole app

<img width="696" alt="Screenshot 2024-03-26 at 2 17 10 PM" src="https://github.com/abdahad1996/Img.ly/assets/28492677/76fd094d-76e9-4e13-b9cf-be4811655fda">

A more detailed look into Core would show you 

<img width="864" alt="Screenshot 2024-03-26 at 2 00 15 PM" src="https://github.com/abdahad1996/Img.ly/assets/28492677/71dbf9f4-4695-4b9c-85ca-ec775f89f0d3">

I follow the following subset of UML introduced to me by https://academy.essentialdeveloper.com/.

<img width="338" alt="Screenshot 2024-03-26 at 2 27 52 PM" src="https://github.com/abdahad1996/Img.ly/assets/28492677/2c72760b-1354-407a-861d-5675754ebf0f">

let's focus on how Tree View consumes Core to Display the UI.
1. [Domain](#domain)
2. [Api](#api)
3. [Persistence](#persistence)
3. [Presentation](#presentation)
4. [Infrastructure](#infra)
5. [UI](#ui)
6. [Main](#main)(Composition Root)
     
### Domain 
![Screenshot 2025-02-05 at 8 38 42 PM](https://github.com/user-attachments/assets/905224f8-058a-40d5-b804-644daee9761a)

The domain represents the innermost layer in the architecture (no dependencies with other layers). It contains only models and abstractions for:

#### Tree Node
- fetching data [Api](#api)
- the [Presentation](#presentation) module to obtain relevant data and convert it to the format required by the [UI](#ui) module

#### Leaf Node
- fetching data [Api](#api)
- saving and fetching data locally(#persistence)
- the [Presentation](#presentation) module to obtain relevant data and convert it to the format required by the [UI](#ui) module


#### 1. TreeNode Feature

```swift
public struct TreeNode: Identifiable, Equatable {
    public let id: String
    public let label: String
    public var children: [TreeNode]?
    public var parentId: String?
    public var level: Int = 0

    public init(id: String, label: String, children: [TreeNode]? = nil, parentId: String? = nil, level: Int = 0) {
        self.id = id
        self.label = label
        self.children = children
        self.parentId = parentId
        self.level = level
    }   
}
```

```swift
public protocol TreeNodeLoader {
    func load() async throws -> [TreeNode]
}
```
#### 2. LeafNode Feature


```swift
public struct LeafNode: Identifiable, Equatable {
	public let id: String
	public let createdAt: String
	public let createdBy: String
	public let lastModifiedAt: String
	public let lastModifiedBy: String
	public let description: String
	
	public init(id: String, createdAt: String, createdBy: String, lastModifiedAt: String, lastModifiedBy: String, description: String) 	{
           self.id = id
           self.createdAt = createdAt
           self.createdBy = createdBy
           self.lastModifiedAt = lastModifiedAt
           self.lastModifiedBy = lastModifiedBy
           self.description = description
	}
}

```

```swift
public protocol LeafNodeCache {
	func save(id: String, node: LeafNode) async throws
}
public protocol LeafNodeLoader {
  func load(id: String) async throws -> LeafNode
}

```

### Api

The layer showcases the API layer, which communicates with infrastructure layer to communicate with the backend .

#### 1. RemoteTreeNodeLoader

this class implements the transaction loader from the Tree domain so we invert the dependency and instead of our domain depending on the API our API depends on the domain and our domain can be independent of any dependency.

```swift
public class RemoteTreeNodeLoader:TreeNodeLoader {
    
    public let url:URL
    public let client:HTTPClient
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public func load() async throws -> [TreeNode] {
        let url = TreeNodeEndpoint.get.url(baseURL: url)
        guard let (data, response) = try? await self.client.get(from: url) else{
            throw Error.connectivity
        }
        return try RemoteTreeMapper.mapToTreeNodes(from: data, response: response)
    }
    
    
}

...
```

it also takes in HTTPClient protocol to fetch data so RemoteTransactionLoader doesn't care about the implementaion details of the http protocol so it can be URLSession or Alamofire.

#### 2. RemoteLeafNodeLoader
The RemoteLeafNodeLoader does the same as RemoteTreeNodeLoader
```
public final class RemoteLeafNodeLoader: LeafNodeLoader {
	private let url: URL
	private let client: HTTPClient

	public enum Error: Swift.Error {
		case connectivity
		case invalidData
	}

	public init(url: URL, client: HTTPClient) {
		self.url = url
		self.client = client
	}

	public func load(id: String) async throws -> LeafNode {
        let url = LeafNodeEndpoint.get(id).url(baseURL: url)
        guard let (data, response) = try? await self.client.get(from: url) else{
            throw Error.connectivity
        }
		return try RemoteLeafMapper.mapToLeafNode(from: data, response: response)
	}
}

```

#### 3. Endpoint Creation

I separated endpoint creation with relation to the feature instead of having one single end point for all so I have to only edit a file containing related endpoints.(this case still violates the principle, but considering the relatedness of the endpoints I think it's a good trade-off for now).
```swift
public enum TreeNodeEndpoint {
    case get

    public func url(baseURL: URL) -> URL {
        switch self {
        case .get:
            return baseURL.appendingPathComponent("/data.json")
        }
    }
}


public enum LeafNodeEndpoint {
    case get(String)
    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(id):
            return baseURL.appendingPathComponent("/entries/\(id).json")
        }
    }
}
```


#### 4. Mapper

For the mapping from `Data` to `TreeNode` or `LeafNode` I used separate RemoteTreeNodeMapper and RemoteLeafMapper  and used it implicitly in the RemoteTreeNodeLoader and RemoteLeafNodeLoader respectively .I prefer to test it directly in integration instead of injecting it, resulting in lower complexity and coupling of tests with the production code.


#### 5. Parsing JSON Response

To parse the JSON received from the server I had two alternatives:
1. To make domain models conform to `Codable` and use them directly to decode the data
2. Create distinct representation for each domain model that needs to be parsed

I ended up choosing the second approach as I didn't want to leak the details of the concrete implementation outside of the module 

### Persistence

The layer showcases the Cache layer, which communicates with infrastructure layer to communicate with the local Database .


#### 1 LocalLeafNodeLoader
this class implements the loader and cache abstraction from the Leaf domain so we invert the dependency and instead of our domain depending on the Persistence our Persistence layer depends on the domain and our domain can be independent of any dependency.


```
public final class LocalLeafNodeLoader: LeafNodeLoader, LeafNodeCache {
	private let store: LocalStore
	private let currentDate: () -> Date

	private struct CacheMissError: Error {}

	public init(store: LocalStore, currentDate: @escaping () -> Date) {
		self.store = store
		self.currentDate = currentDate
	}

	public func load(id: String) async throws -> LeafNode {
		do {
			let loader = try await store.read(id: id)
			return LocalLeafNodeMapper.toDomain(node: loader)
		} catch {
			throw CacheMissError()
		}
	}

	public func save(id: String, node: LeafNode) async throws {
		try await store.write(id, LocalLeafNodeMapper.toLocal(node: node), timestamp: currentDate())
	}
}

```

#### 2 LocalLeafNodeMapper

```

public enum LocalLeafNodeMapper {
	static func toLocal(node: LeafNode) -> LocalLeafNode {
		return LocalLeafNode(node: node)
	}

	static func toDomain(node: LocalLeafNode) -> LeafNode {
		return LeafNode(id: node.id, createdAt: node.createdAt, createdBy: node.createdAt, lastModifiedAt: node.lastModifiedAt, lastModifiedBy: node.lastModifiedBy, description: node.description)
	}
}


```
In order to save in the local database our domain should conform to type the local db understands in the case of `coredata` it is `nsmanagedobject` , if we go that route then all modules that depend on Domain would depend on an implementation detail of the Persistence module, thus coupling the business logic with a specific framework (leaking framework details). 

Since I wanted to hide all implementation details related to persistence, maintain modularity and decrease the coupling of domain models with a specific framework, I decided to create a separate managed model corresponding to the domain model used in the infrastrucutre module and have a mapper that has functionality that converts from localmodel and to domain and vice versa.


### Presentation

This layer makes the requests for getting data using a service and it formats the data exactly how the UI module requires it.

By decoupling view models from the concrete implementations of the services allowed me to simply add the caching and the fallback features later on without changing the view models and shows how the view models conform to the Open/Closed Principle. Additionally, since I created separate abstractions for each request, I was able to gradually add functionalities. For this reason, each view model has access to methods it only cares about, thus respecting the Interface Segregation Principle and making the concrete implementations depend on the clients' needs as they must conform to the protocol.

On the other side, adding all methods in a single protocol would have resulted in violating the Single Responsibility Principle, making the protocol bloated and forcing the clients to implement methods they don't care about. It's also a violation of the Liskov Substitution Principle if the client crashes the app when it doesn't know how to handle that behaviour or simply don't care about implementing it.

Thus, by introducing abstractions, I increased the testability of the view models since mocking their collaborators during testing is a lot easier.

```swift
import Foundation
import Core
import SwiftUI

public class TreeViewModel: ObservableObject {
	var nodes: [TreeNode] = []
	public enum LoadingTreeError: String, Swift.Error {
		case serverError = "Server connection failed. Please try again!"
	}

    public enum State: Equatable {
		case idle
		case isLoading
		case failure(LoadingTreeError)
		case success([TreeNode])
	}

	@Published public var state: State = .idle

	let loader: TreeNodeLoader

    public init(loader: TreeNodeLoader) {
		self.loader = loader
	}

	@MainActor public func load() async {
		do {
			state = .isLoading
			nodes = try await loader.load()
			state = .success(nodes)
		} catch {
			state = .failure(.serverError)
		}
	}

    public func move(
		fromOffsets source: IndexSet,
		toOffset destination: Int) {
		nodes.move(fromOffsets: source, toOffset: destination)
		state = .success(nodes)
	}

    public func deleteNode(at offsets: IndexSet) {
		nodes.remove(atOffsets: offsets)
		state = .success(nodes)
	}
}


```

### UI

The following diagram is the tree-like representation of all the screens in the app. To increase the reusability of views, I made the decision to move the responsibility of creating subviews to the layer above, meaning the composition root. Additionally, I decoupled all views from the navigation logic by using closures to trigger transitions between them (More details in the [Main](#main) section).

<img width="476" alt="Screenshot 2024-03-26 at 3 02 08 PM" src="https://github.com/abdahad1996/Img.ly/assets/28492677/b1ba58ce-d9c5-4b89-8f42-3715d2df6003">

The best example is the `TreeView` which is defined as a generic view requiring:
- one closure to signal that the app should navigate to the Leaf details screen (the view being completely agnostic on how the navigation is done)
- one closure that receives a `TreeViewCell` and returns a `Cell` view to be rendered (the view is not responsible for creating the cell and doesn't care what cell it receives)

Furthermore, I avoid making views depend on their subviews' dependencies by moving the responsibility of creating its subviews to the composition root. Thus, I keep the views constructors containing only the dependencies they use.

```swift

public struct TreeView<TreeViewCell: View>: View {
    let treeViewCell: (TreeNode) -> TreeViewCell
    let goToDetail: (String) -> Void
    let designLibrary: DesignLibraryProvider
    @StateObject var treeViewModel: TreeViewModel
    @State private var isEditing = false

    ...
```
### Infrastructure
This layer uses the infrastructure class offered by iOS to communicate with external systems.


#### 1. Api Infra
The following diagram contains the concrete implementation of the HTTPClient protocol having URLSession as dependency this way our loaders do not know of implementation details.We can easily replace URLSession with Alamofire in the future. It respects the dependency rule outlined in the overview section. The decision to extract the infrastructure class in a separate module(Virtual) and compose them in the Composition Root was made due to the fact that both TreeNodeFeature and LeafNodeFeature require to make network requests.

```swift
public protocol HTTPClient {
    func get(from url: URL) async throws -> (Data, HTTPURLResponse)
}
```

```swift
public class HTTPClientStub: HTTPClient {}

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
```

#### 2. Cache Infra
The following diagram contains the concrete implementation of the LocalStore protocol having CodableFileSystem as dependency this way our loaders do not know of implementation details.We can easily replace CodableFileSystem with CoreData in the future. It respects the dependency rule outlined in the overview section. We also use LocalModels that correspond to the domain that are used in the infrastucture layer making our domain independent.

```
public class CodableFileSystemAdapter: LocalStore {
	private struct Cache: Codable {
		let codableLeafNode: CodableLeafNode
		let timestamp: Date
		let id: String

		var localLeafNode: LocalLeafNode {
			return codableLeafNode.localLeafNode
		}
	}

	public struct CodableLeafNode: Codable {
		public let id: String
		public let createdAt: String
		public let createdBy: String
		public let lastModifiedAt: String
		public let lastModifiedBy: String
		public let description: String

		init(node: LocalLeafNode) {
			self.id = node.id
			self.createdAt = node.createdAt
			self.createdBy = node.createdBy
			self.lastModifiedAt = node.lastModifiedAt
			self.lastModifiedBy = node.lastModifiedBy
			self.description = node.description
		}

		var localLeafNode: LocalLeafNode {
			return LocalLeafNode(id: id, createdAt: createdAt, createdBy: createdBy, lastModifiedAt: lastModifiedAt, lastModifiedBy: lastModifiedBy, description: description)
		}
	}

	private struct CacheMissError: Error {}

	private let storeURL: URL

	public init(storeURL: URL) {
		self.storeURL = storeURL
	}

	public func read(id: String) async throws -> LocalLeafNode {
		let storeURL = self.storeURL

		guard let data = try? Data(contentsOf: storeURL) else {
			throw CacheMissError()
		}
		do {
			let decoder = JSONDecoder()
			let cacheArr = try decoder.decode([Cache].self, from: data)

			guard let cache = cacheArr.first(where: { $0.id == id }) else {
				throw CacheMissError()
			}

			return cache.localLeafNode
		} catch {
			throw CacheMissError()
		}
	}

    fileprivate func saveFirstTime(_ object: LocalLeafNode, _ timestamp: Date, _ id: String) throws {
        let encoder = JSONEncoder()
        let cache = Cache(codableLeafNode: CodableLeafNode(node: object), timestamp: timestamp, id: id)
        var cacheArr = [Cache]()
        cacheArr.append(cache)
        let encoded = try encoder.encode(cacheArr)
        try encoded.write(to: storeURL)
    }
    
    public func write(_ id: String, _ object: LocalLeafNode, timestamp: Date) async throws {
		do {
			guard let data = try? Data(contentsOf: storeURL) else {
                try saveFirstTime(object, timestamp, id)
				throw CacheMissError()
			}

			let decoder = JSONDecoder()
			var cacheArr = try? decoder.decode([Cache].self, from: data)

			let encoder = JSONEncoder()
			let cache = Cache(codableLeafNode: CodableLeafNode(node: object), timestamp: timestamp, id: id)

			//append and save back
			if var cacheArr = cacheArr {
				cacheArr.append(cache)
				let encoded = try encoder.encode(cacheArr)
				try encoded.write(to: storeURL)
			} else {
				var cacheArr = [Cache]()
				cacheArr.append(cache)
				let encoded = try encoder.encode(cacheArr)
				try encoded.write(to: storeURL)
			}

		} catch {
			throw CacheMissError()
		}
	}
}


```


### Main

This module is responsible for instantiation and composing all independent modules in a centralized location which simplifies the management of modules, components and their dependencies, thus removing the need for them to communicate directly, increasing the composability and extensibility of the system (`Open/Closed Principle`).

Moreover, it represents the composition root of the app and handles the following responsiblities:
1. Responsible for the Instantiation and life cycle of all modules.
2. Interception(#adding-caching-by-intercepting-network-requests) (`Decorator Pattern`)
3. [Handling navigation](#handling-navigation) (hierarchical navigation)




#### Handling navigation

##### Hierarchical Navigation

To implement this kind of navigation, I used the new NavigationStack type introduced in iOS 16. Firstly, I created a generic Flow class that can append or remove a new route.


```swift


final class Flow<Route: Hashable>: ObservableObject {
	@Published var path = [Route]()

	func append(_ value: Route) {
		path.append(value)
	}

	func navigateBack() {
		path.removeLast()
	}
}
```
Secondly, I created enums for each navigation path. For instance, from the TreeView screen, the user can navigate to the Leaf Detail screen . I used the associated value of a case to send additional information between screens. In this case, it's the leaf ID

```swift
public enum TreeRoute: Hashable {
	case leaf(String)
}
```
Furthermore, I used the navigationDestination(for:destination:) modifier to define links between the root view and the destination based on the route. The following example is the instantiation of the TreeView and the definition of its navigation destinations which are encapsulated in the TreeFlowView:
```swift
@ViewBuilder private func makeTreeFlowView(designLibrary: DesignLibraryProvider)
        -> some View {
        NavigationStack(path: $treeflow.path) {
            TreeFlowView(designLibrary: designLibrary).makeTreeView(
                flow: treeflow,
                treeLoader: TreeNodeFactory.treeLoader(baseURL: baseURL)
            )
            .navigationBarItems(leading:
                Toggle(isOn: $isToggled) {
                    Text("Change Theme")
                }.foregroundColor(designLibrary.color.text.standard)
                    .toggleStyle(SwitchToggleStyle(tint: designLibrary.color.background.buttonPrimary))
            )
            .navigationDestination(for: TreeRoute.self) { route in
                switch route {
                case .leaf(let id):
                    makeLeafView(id: id, designLibrary: designLibrary)
                }
            }
        }
    }

```

this allowes me to change the screens order from the composition root without affecting other modules. In addition, it improves the overall flexibility and modularity of the system, as the views don't have knowledge about the navigation implementation.
