import Foundation

/// A container class for managing and retrieving dependencies across different scopes.
/// The `Container` is initialized with a key to identify its scope, and can register
/// or resolve dependencies by their types or identifiers.
/// It supports hierarchical structure by linking with other containers, allowing
/// dependency resolution across multiple containers.
///
/// Example:
///
///     Container(\.network) {
///         WithInterface(
///             Networker(),
///             interface: NetworkService.self
///         )
///         DataLoader()
///         WithIdentifier(
///             identifier: "NetworkerSecond",
///             instance: NetworkerSecond(),
///             interface: NetworkService.self
///         )
///     }
///
///     Container(\.usecase)
///         .withContainers(\.network)
///         .add { resolver in
///             GetUserUseCase(network: resolver.get(NetworkService.self)!)
///             GetSearchUseCase(network: resolver.get(NetworkService.self)!)
///         }
///
/// Use:
///
///     @Injection var deep: Deep!
///     @Resolvers(\.network) var networkResolver: Resolver!
///
///     deep.get(DataLoader.self)?.execute()
///     networkResolver?.get(NetworkService.self)?.get()
///
/// Features:
/// - Registers instances and retrieves dependencies by type or identifier.
/// - Supports adding dependencies with `@ContainerBuilder` or later via the `add` method.
/// - Can reference other containers to form a dependency chain for resolution.
///
/// Note: Use `Resolver` methods like `get` to fetch instances by type, or add unique
/// identifiers for cases with multiple instances of the same type.
///
public class Container {
    
    typealias Identifier = String
    
    private var services: [Identifier: Any] = [:]
    private var factories: [Identifier: () -> Any] = [:]
    private var childContainers: Set<ContainerKey> = []
    
    /// Initializes a container that creates dependencies
    /// based on a key and components passed in the builder block.
    ///
    /// Use `@ContainerBuilder` in cases where you don't need
    /// to inject additional dependencies using `Resolver`.
    /// When a `Resolver` is needed, use the `add` method.
    ///
    ///     Container(\.network) {
    ///         WithInterface(
    ///             Networker(),
    ///             interface: NetworkService.self
    ///         )
    ///         DataLoader()
    ///         WithIdentifier(
    ///             identifier: "NetworkerSecond",
    ///             instance: NetworkerSecond(),
    ///             interface: NetworkService.self
    ///         )
    ///     }
    ///
    /// - Parameters:
    ///   - key: A key for identifying the container. This is a `KeyPath` associated with `ContainerKey`.
    ///   - builder: A closure that defines the dependencies to register within the container.
    @discardableResult
    public init(
        _ key: KeyPath<ContainerKeys, ContainerKey>,
        @ContainerBuilder _ builder: () -> [Any]
    ) {
        if let existingContainer = Storage.default.attachedContainers[ContainerKeys()[keyPath: key]] {
            self.services = existingContainer.services
            self.childContainers = existingContainer.childContainers
        }
        registerComponents(builder())
        attached(ContainerKeys()[keyPath: key])
    }
    
    /// A simplified initializer for a container without any registered components.
    /// Use it when you don't want to use `@ContainerBuilder` during initialization.
    ///
    /// Note: You can still use the `add` method with `Resolver`.
    ///
    /// - Parameter key: A key for identifying the container. This is a `KeyPath` associated with `ContainerKey`.
    public convenience init(
        _ key: KeyPath<ContainerKeys, ContainerKey>
    ) {
        self.init(key) {}
    }
    
    /// Adds references to other containers for dependency lookup.
    /// Use this method to add other containers to the container,
    /// allowing this container's `Resolver` to access dependencies
    /// registered in the added containers.
    ///
    ///     Container(\.usecase)
    ///            .withContainers(\.network)
    ///            .add { resolver in
    ///                GetUserUseCase(network: resolver.get(NetworkService.self)!)
    ///                GetSearchUseCase(network: resolver.get(NetworkService.self)!)
    ///            }
    ///
    /// - Parameter containers: A set of `KeyPath`s that point to other containers.
    /// - Returns: Self.
    @discardableResult
    public func withContainers(_ containers: KeyPath<ContainerKeys, ContainerKey>...) -> Self {
        for container in containers {
            childContainers.insert(ContainerKeys()[keyPath: container])
        }
        return self
    }
    
    /// Adds components to the existing container.
    /// Use this method when you want to use `Resolver`,
    /// for example, to access dependencies registered in
    /// this or other added containers within the current one.
    ///
    ///     Container(\.usecase)
    ///            .withContainers(\.network)
    ///            .add { resolver in
    ///                GetUserUseCase(network: resolver.get(NetworkService.self)!)
    ///                GetSearchUseCase(network: resolver.get(NetworkService.self)!)
    ///            }
    ///
    /// - Parameter builder: A closure that accepts `Resolver` and returns an array of components for registration.
    /// - Returns: Self.
    @discardableResult
    public func add(@ContainerBuilder _ builder: (Resolver) -> [Any]) -> Self {
        let components = builder(self)
        registerComponents(components)
        return self
    }
}

extension Container: Resolver {
    
    /// Retrieves a registered component by its type and identifier.
    /// Use this method if you have registered two dependencies
    /// of the same type. For example, two classes implementing
    /// the same protocol.
    ///
    ///     deep.get(NetworkService.self)?.execute
    ///     deep.get(NetworkService.self, identifier: "NetworkerSecond")?.execute()
    ///
    /// - Parameters:
    ///   - type: The type of component to look for.
    ///   - identifier: An optional string identifier for unique components.
    /// - Returns: An object of the specified type, if found; otherwise `nil`.
    public func get<T>(_ type: T.Type, identifier: String?) -> T? {
        if let identifier {
            return get(identifier: identifier, type: type)
        }
        return get(identifier: "\(type.self)", type: type)
    }
    
    /// Retrieves a registered component by its type.
    ///
    ///     deep.get(NetworkService.self)?.execute
    ///
    /// - Parameter type: The type of component to look for.
    /// - Returns: An object of the specified type, if found; otherwise `nil`.
    public func get<T>(_ type: T.Type) -> T? {
        get(type, identifier: nil)
    }
}

extension Container {
    func register(_ type: Any.Type, instance: Any, id: Identifier? = nil) {
        if let lazy = instance as? Lazy {
            factories[id ?? "\(type.self)"] = lazy.block
        } else {
            services[id ?? "\(type.self)"] = instance
        }
    }
    
    func registerComponents(_ components: [Any]) {
        for component in components {
            if let withInterface = component as? WithInterface {
                register(
                    withInterface.interface,
                    instance: withInterface.instance
                )
            } else if let withIdentifier = component as? WithIdentifier {
                let identifier = withIdentifier.identifier
                register(
                    withIdentifier.interface ?? type(of: component),
                    instance: withIdentifier.instance,
                    id: identifier
                )
            } else if let withLazy = component as? WithLazy {
                let type = withLazy.type
                register(
                    type,
                    instance: withLazy.lazy
                )
            } else {
                let objectType = type(of: component)
                register(
                    objectType,
                    instance: component
                )
            }
        }
    }
    
    func attached(_ identifier: ContainerKey) {
        Storage.default.attachedContainers[identifier] = self
    }

    func withContainers(_ containers: [KeyPath<ContainerKeys, ContainerKey>]) -> Self {
        for container in containers {
            childContainers.insert(ContainerKeys()[keyPath: container])
        }
        return self
    }
    
    func get<T>(identifier: Identifier, type: T.Type) -> T? {
        guard let object = services[identifier] as? T else {
            
            if let factory = factories[identifier], let service = factory() as? T {
                services[identifier] = service
                return service
            }
            
            for childContainer in childContainers {
                if let object = Storage.default.attachedContainers[childContainer]?.get(identifier: identifier, type: type) {
                    return object
                }
            }
            return nil
        }
        return object
    }
    
}
