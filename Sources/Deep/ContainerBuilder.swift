import Foundation

/// A result builder for constructing an array of dependencies in a container.
/// Use `@ContainerBuilder` to build and register multiple components
/// within a container in a concise and readable format.
///
/// Example:
///
///     Container(\.network) {
///         Networker()
///         DataLoader()
///     }
///
@resultBuilder
public struct ContainerBuilder {
    
    /// Combines the given components into an array, which will be
    /// used to register dependencies in the container.
    ///
    /// - Parameter components: The list of components to include in the array.
    /// - Returns: An array of components to be registered.
    public static func buildBlock(_ components: Any...) -> [Any] {
        components
    }
}
