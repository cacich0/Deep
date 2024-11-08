import Foundation

/// A wrapper for lazy initialization of a dependency.
/// The object is created only when it is accessed for the first time.
///
/// WARNING: You need to use the `Lazy` wrapper
/// exclusively inside `WithInterface` and `WithIdentifier
///
/// Note: Use this only if you don't need to initialize the object immediately.
///
/// Example:
///
///     Container(\.network) {
///         WithInterface(
///             Lazy(Networker()),
///             interface: NetworkService.self
///         )
///         WithIdentifier(
///             identifier: "NetworkerSecond",
///             instance: Lazy(NetworkerSecond()),
///             interface: NetworkService.self
///         )
///     }
///
public struct Lazy {
    internal let block: () -> Any
    
    public init(_ block: @escaping @autoclosure () -> Any) {
        self.block = block
    }
}

/// A structure for lazy initialization of a dependency with a specified interface type.
/// Used to register an object that will only be created upon first access.
///
/// WARNING: You need to use the `WithLazy` wrapper exclusively
/// when you are not using `WithInterface` and `WithIdentifier`
///
/// Note: Use this only if you don't need to initialize the object immediately.
///
/// Example:
///
///     Container(\.network) {
///         WithLazy(DataLoader(), type: DataLoader.self)
///     }
///
public struct WithLazy {
    private let block: () -> Any
    internal let type: Any.Type
    internal var lazy: Lazy { .init(block) }
    
    public init(_ block: @escaping @autoclosure () -> Any, type: Any.Type) {
        self.block = block
        self.type = type
    }
}
