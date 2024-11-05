import Foundation


/// A base class for managing and retrieving dependencies in the "deep" container scope.
/// `Deep` initializes with a list of child containers, allowing for nested dependency
/// management. Extend this class to define custom dependency setups and configurations
/// within the `setup` function.
///
/// Example usage:
///
///     class DI: Deep {
///         override func setup() {
///             setupNetworkContainer()
///             setupUseCaseContainer()
///             setupOthersContainer()
///         }
///
///         private func setupNetworkContainer() {
///             Container(\.network) {
///                 WithInterface(
///                     Networker(),
///                     interface: NetworkService.self
///                 )
///                 DataLoader()
///                 WithIdentifier(
///                     identifier: "NetworkerSecond",
///                     instance: NetworkerSecond(),
///                     interface: NetworkService.self
///                 )
///             }
///         }
///
///         private func setupUseCaseContainer() {
///             Container(\.usecase)
///                 .withContainers(\.network)
///                 .add { resolver in
///                     GetUserUseCase(network: resolver.get(NetworkService.self)!)
///                     GetSearchUseCase(network: resolver.get(NetworkService.self)!)
///                 }
///         }
///
///         private func setupOthersContainer() {
///             Container(\.others) {
///                 AccountService { print("Account Get") }
///             }
///
///             Container(\.others) {
///                 Statistics()
///             }
///         }
///     }
///
/// - Note: The `get` function provides a convenient way to retrieve dependencies by type
///   and optional identifier.
///
/// Features:
/// - Supports initialization with child containers.
/// - Provides an overridable `setup` function for custom dependency setup.
/// - Allows dependency retrieval with `get`.
///
open class Deep {
    
    /// Type alias for dependency identifiers.
    public typealias Identifier = String
    
    private let resolver: Resolver
    
    /// Initializes a `Deep` instance, setting up the container with specified child containers.
    /// The `setup` function is called automatically during initialization to allow custom configurations.
    ///
    /// - Parameter childrens: A variadic list of key paths to additional containers that will
    public init(childrens: KeyPath<ContainerKeys, ContainerKey>...) {
        resolver = Container(\.deep).withContainers(childrens)
        setup()
        register()
    }
    
    /// Override this function to configure custom dependencies.
    /// This function is called during initialization and can be customized in subclasses
    /// to set up any required dependencies within the container.
    open func setup() {}
    
    
    /// Retrieves a dependency by type, with an optional identifier for cases
    /// where multiple instances of the same type are registered.
    ///
    /// - Parameters:
    ///   - type: The type of the dependency to retrieve.
    ///   - identifier: An optional identifier for unique instances of the same type.
    /// - Returns: The dependency of the specified type if available, or `nil` if not found.
    public func get<T>(_ type: T.Type, identifier: Identifier? = nil) -> T? {
        resolver.get(type, identifier: identifier)
    }
    
    
}

extension Deep {
    func register() {
        Storage.default.deep = self
    }
}
