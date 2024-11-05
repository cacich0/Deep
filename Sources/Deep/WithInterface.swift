import Foundation

/// A structure for registering a dependency that conforms to a specific interface type
/// (e.g., a protocol or base class). Use `WithInterface` when you want to register
/// a dependency under an interface type rather than its concrete type, allowing for more flexible
/// dependency retrieval.
///
/// Example usage:
///
///     Container(\.network) {
///         WithInterface(
///             Networker(),
///             interface: NetworkService.self
///         )
///     }
///
/// - Parameters:
///   - instance: The dependency instance to be registered.
///   - interface: The protocol or base class type that the instance conforms to.
public struct WithInterface {
    
    internal let instance: Any
    internal let interface: Any.Type
    
    /// Initializes a new `WithInterface` instance with the specified dependency instance and interface type.
    ///
    /// - Parameters:
    ///   - instance: The dependency instance for registration.
    ///   - interface: The interface type that the instance conforms to.
    public init(_ instance: Any, interface: Any.Type) {
        self.instance = instance
        self.interface = interface
    }
}
