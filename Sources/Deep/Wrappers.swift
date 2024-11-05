import SwiftUI

/// A property wrapper that provides a `Resolver` instance for dependency resolution
/// from a specified container key. Use `@Resolvers` to access a resolver associated
/// with a specific `ContainerKey` at runtime, enabling dependencies retrieval
/// based on the container configuration.
///
/// Example usage:
///
///     @Resolvers(\.network) var resolver: Resolver!
///     resolver.get(NetworkService.self)
///
/// - Parameter key: A `KeyPath` to a specific `ContainerKey` within `ContainerKeys`.
@propertyWrapper
public struct Resolvers {
    
    var key: KeyPath<ContainerKeys, ContainerKey>
    
    /// Provides the resolver instance associated with the specified container key,
    /// or `nil` if no container is found.
    public var wrappedValue: Resolver? {
        Storage.default.attachedContainers[ContainerKeys()[keyPath: key]]
    }
    
    /// Initializes a new `Resolvers` instance with the specified container key.
    ///
    /// - Parameter key: The `KeyPath` to a specific `ContainerKey` within `ContainerKeys`.
    public init(_ key: KeyPath<ContainerKeys, ContainerKey>) {
        self.key = key
    }
}

/// A property wrapper that provides access to a shared `Deep` instance for global
/// dependency resolution. Use `@Injection` to access the main `Deep` resolver, which
/// can retrieve dependencies globally across the application.
///
/// Example usage:
///
///     @Injection var deep: Deep!
///     deep.get(NetworkService.self)
///     
@propertyWrapper
public struct Injection {
    
    /// Provides the main `Deep` resolver instance for dependency injection.
    /// Returns `nil` if no `Deep` instance is available in `Storage`.
    public var wrappedValue: Deep? {
        Storage.default.deep
    }
    
    /// Initializes a new `Injection` instance.
    public init() {}
}
