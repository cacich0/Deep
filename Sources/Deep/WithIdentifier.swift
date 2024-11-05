import Foundation

/// A structure used to register a dependency with a specific identifier,
/// allowing you to differentiate between multiple instances of the same type.
/// Use `WithIdentifier` to assign unique names to dependencies for later retrieval.
///
/// Example usage:
///
///     Container(\.network) {
///         WithIdentifier(
///             identifier: "NetworkerSecond",
///             instance: NetworkerSecond(),
///             interface: NetworkService.self
///         )
///     }
///
/// - Parameters:
///   - identifier: A unique identifier for the dependency, used for precise retrieval.
///   - instance: The instance of the dependency to register.
///   - interface: An optional protocol or base class type that the instance conforms to, if needed.
public struct WithIdentifier {
    
    /// Type alias representing a unique identifier for each dependency instance.
    public typealias Identifier = String
    
    internal let identifier: Identifier
    internal let instance: Any
    internal let interface: Any.Type?
    
    /// Initializes a new `WithIdentifier` instance with a unique identifier, instance, and optional interface type.
    ///
    /// - Parameters:
    ///   - identifier: A unique identifier for the dependency, allowing retrieval by name.
    ///   - instance: The dependency instance to register.
    ///   - interface: An optional type (such as a protocol) that the instance conforms to.
    public init(identifier: Identifier, instance: Any, interface: Any.Type? = nil) {
        self.identifier = identifier
        self.instance = instance
        self.interface = interface
    }
}
