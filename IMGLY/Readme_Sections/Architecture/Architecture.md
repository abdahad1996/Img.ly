## Architecture

### Overview

For this project, I organized the codebase into `Vertical Slices or Vertical features` , inside each Vertical Slice I am using `horizontal slicing` to break down the slice into layers, while respecting the dependency rule:

> ❗️ High-level modules should not depend on lower-level modules and lower-level modules should only communicate and know about the next higher-level layer.

In my opinion, it's the best approach for this kind of project since `vertical slicing` is  suitable for larger projects with feature teams and keeping in view of future i thought this was the best way to go forward. I didn't create framework or packages but kept it simple using folder separation but i kept everything decoupled so it won't be hard to switch to packages or framework in the future.

The following diagram shows a high level structure of the whole app

<img width="918" alt="Screenshot 2024-01-16 at 13 02 04" src="https://github.com/abdahad1996/WorldOfPAYBACK/assets/28492677/2edaecc7-8a1e-4577-8059-ccdf73466e33">



In the diagram you see 2 vertical sliced features

The Transaction Detail feature only has a UI layer and a presentation layer since it's dependent on the Transaction Module due to Transaction domain model but it is made in a way that if tomorrow a need arises for Transaction Detail feature to have it's own domain and own abstractions along with its interactors and controllers so it's scalable. but for now simply passing in the Transaction domain model to it is okay.

I'll talk a bit deeply about the Transaction feature as it is the one doing the heavy lifting. For better understanding i separated the Transaction Feature 

<img width="328" alt="Screenshot 2024-01-16 at 13 00 32" src="https://github.com/abdahad1996/WorldOfPAYBACK/assets/28492677/3421f0de-30df-48c2-8f6a-6238e393072d">

The following diagram is a provides a top-level view of Transaction Feature with all horizontal modules.
1. [Domain](#domain)
2. [Remote Transaction Loader](#Api)
4. [API Infra](#api-infra)
7. [Presentation](#presentation)
8. [UI](#ui)
9. [Main](#main) (Composition Root)
     
### Domain

The domain represents the innermost layer in the architecture (no dependencies with other layers). It contains only models and abstractions for:
- fetching data by the [Remote Transaction Loader](#networking)
- the [Presentation](#presentation) module to obtain relevant data and convert it to the format required by the [UI](#ui) module

#### 1. Transaction Feature

```swift
public struct TransactionItem:Hashable{
    public let partnerDisplayName: String
    public let bookingDate: Date
    public let description: String?
    public let amount: Int
    public let currency: String
    public let category:Int
    
   public init(partnerDisplayName: String, bookingDate: Date, description: String?, amount: Int, currency: String,category:Int) {
        self.partnerDisplayName = partnerDisplayName
        self.bookingDate = bookingDate
        self.description = description
        self.amount = amount
        self.currency = currency
        self.category = category
    }
}
```

```swift
public protocol TransactionLoader {
    typealias Result = Swift.Result<[TransactionItem], Error>
    
    func load() async throws -> [TransactionItem]
    func load(completion: @escaping (Result) -> Void)
}
```

### #Api
The following diagram showcases the Api layer, which communicates with my backend app. For a better understanding, 
#### 1. RemoteTransactionLoader

this class implements the transaction loader from the domain so we invert the depedency and instead of our domain depending on the api our api depends on domain and our domain can be independent of any dependency.

```swift
public class RemoteTransactionLoader: TransactionLoader {
    
    public typealias Result = TransactionLoader.Result
    
    private let url: URL
    private let client: HTTPClient
...
```

it also takes in http protocol to fetch data so RemoteTransactionLoader doesn't care about the implementaion details of the http protocol so it can be URLSession or Alamofire and in our case we use a mock backend.

#### 2. Api Infra
```swift
public class HTTPClientStub: HTTPClient {}
```
our implementor of httpclient is a mocked backend but we can always replace it with any other implementation . 
   
#### 3. Endpoint Creation
i separated endpoint creation with relation to the feature so i have to edit a file containing related endpoints to the one I want to add (this case still violates the principle, but considering the relatedness of the endpoints I think it's a good trade-off for now).
```swift
public enum TransactionsEndpoint {
    case get
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case .get:
            return baseURL.appendingPathComponent("transactions")
        }
    }
}
```

#### 4. Transaction Mapper

For the mapping from `Data` to `TransactionItem` I preferred to test it directly in the `RemoteStore`, While I could have accomplished this using a stubbed collaborator (e.g. a protocol `DataParser`), I prefered to test it in integration, resulting in lower complexity and coupling of tests with the production code.

#### 5. Parsing JSON Response

To parse the JSON received from the server I had two alternatives:
1. To make domain models conform to `Codable` and use them directly to decode the data
2. Create distinct representation for each domain model that needs to be parsed

I ended up choosing the second approach as I didn't want to leak the details of the concrete implementation outside of the module because it would 


 

#### From Completion Hander to async/await

Since all modules use the `async/await` concurrency module, I needed to switch from the usual Completion handler pattern.


> ❗️ Resuming a continuation must be made exactly once. Otherwise, it results in undefined behaviour, that's why I set it to nil after each resume call, to prevent calling it on the same instance again. Not calling it leaves the task in a suspended state indefinitely. (Apple docs: [CheckedContinuation](https://developer.apple.com/documentation/swift/checkedcontinuation))

```swift
extension TransactionLoader {
    public func load() async throws -> [TransactionItem] {
        return try await withCheckedThrowingContinuation { continuation in
            self.load{ result in
                switch result {
                case .success(let transactionItem):
                    continuation.resume(with: .success(transactionItem))
                case .failure(let err):
                    continuation.resume(throwing: err)
                }
            }
        }
    }
}
```

### Presentation

This layer makes the requests for getting data using a service and it formats the data exactly how the `UI` module requires it.

By decoupling view models from the concrete implementations of the services allowed me to simply add the any behaviour we want later on without changing the view models and shows how the view models conform to the `Open/Closed Principle`. Additionally, since I created separate abstractions for each request, I was able to gradually add functionalities. For this reason, each view model has access to methods it only cares about, thus respecting the `Interface Segregation Principle` and making the concrete implementations depend on the clients' needs as they must conform to the protocol.

This layer is also responsible for localization and any sort of formatting of data before it is presented. It is usally plaform agnostic and you can reuse this logic anywhere.

<img width="274" alt="Screenshot 2024-01-16 at 10 53 51" src="https://github.com/abdahad1996/WorldOfPAYBACK/assets/28492677/860c3631-7ff6-4bb6-914e-019a6a5e6ae9">


Thus, by introducing abstractions, I increased the testability of the view models since mocking their collaborators during testing is a lot easier.

### UI

The following diagram is the tree-like representation of all the screens in the app. To increase the reusability of views, I made the decision to move the responsibility of creating subviews to the layer above, meaning the composition root. Additionally, I decoupled all views from the navigation logic by using closures to trigger transitions between them (More details in the [Main](#main) section).

The best example is the `TransactionView` which is defined as a generic view requiring:
- one closure to signal that the app should navigate to the Transaction details screen (the view being completely agnostic on how the navigation is done)
- one closure that receives a `transactionCell` and returns a `Cell` view to be rendered (the view is not responsible for creating the cell and doesn't care what cell it receives)
- one closure that receives a binding to a `Int` and returns a view for total count of all transactions

Furthermore, I avoid making views to depend on their subviews' dependencies by moving the responsibility of creating its subviews to the composition root. Thus, I keep the views constructors containing only dependencies they use.

```swift

public struct TransactionsView<TransactionCell: View, TransactionFilterView: View, TotalCountView:View>: View {
    @StateObject var viewModel: TransactionViewModel
    let showTransactionDetails: (TransactionItem) -> Void
    let transactionCell: (TransactionItem) -> TransactionCell
    let transactionFilterView: (Binding<Int>,[Int]) -> TransactionFilterView
    let totalCountView:(Binding<Int>) -> TotalCountView

    ...
```

### Main

This module is responsible for instantiation and composing all independent modules in a centralized location which simplifies the management of modules, components and their dependencies, thus removing the need for them to communicate directly, increasing the composability and extensibility of the system (`Open/Closed Principle`).

Moreover, it represents the composition root of the app and handles the following responsiblities:
1. Responsible for the Instantiation and life cycle of all modules.
2. [Adding Sorting Behaviour by intercepting Transaction Loader](#adding-caching-by-intercepting-network-requests) (`Decorator Pattern`)
3. [Handling navigation](#handling-navigation) (hierarchical navigation)




#### Handling navigation

##### Hierarchical Navigation

To implement this kind of navigation, I used the new Coordinators and UIhostingController to port SwiftUI views to UIKit type.

```swift
final class TransactionFlow {
    private let navigationController: UINavigationController
    private let factory: TransactionFactory
    private let makeUserDetailsController: (UINavigationController, TransactionItem) -> Void
    init(
        navigationController: UINavigationController,
        factory: TransactionFactory,
        makeUserDetailsController:@escaping (UINavigationController, TransactionItem) -> Void
    ) {
        self.navigationController = navigationController
        self.factory = factory
        self.makeUserDetailsController = makeUserDetailsController
    }
    
    func start() {
        let vc = factory.makeTransactionListViewController(selection: showTransactionDetail)
        navigationController.setViewControllers([vc], animated: false)
    }
    
    private func showTransactionDetail(with transaction: TransactionItem) {
        self.makeUserDetailsController(navigationController, transaction)
        

    }
}

```

I handled all the hierarchical navigation throughout the app, which allowed me to change the screens order from the composition root without affecting other modules. In addition, it improves the overall flexibility and modularity of the system, as the views don't have knowledge about the navigation implementation.
