import Foundation

public protocol Resolver {
    /// Retrieves a registered component by its type and identifier.
    /// Use this method if you have registered two dependencies
    /// of the same type. For example, two classes implementing
    /// the same protocol.
    ///
    ///     resolver.get(NetworkService.self)?.execute
    ///     resolver.get(NetworkService.self, identifier: "NetworkerSecond")?.execute()
    ///
    /// - Parameters:
    ///   - type: The type of component to look for.
    ///   - identifier: An optional string identifier for unique components.
    /// - Returns: An object of the specified type, if found; otherwise `nil`.
    func get<T>(_ type: T.Type) -> T?
    
    /// Retrieves a registered component by its type.
    ///
    ///     deep.get(NetworkService.self)?.execute
    ///
    /// - Parameter type: The type of component to look for.
    /// - Returns: An object of the specified type, if found; otherwise `nil`.
    func get<T>(_ type: T.Type, identifier: String?) -> T?
}
