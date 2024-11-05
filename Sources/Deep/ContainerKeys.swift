import Foundation

/// A type alias representing a unique identifier for each container.
/// `ContainerKey` is used to distinguish different dependency containers within an application.
public typealias ContainerKey = String

/// A structure that holds predefined keys for referencing various containers.
/// Each key represents a different container scope, allowing organized access to
/// dependencies across multiple containers.
///
/// Example usage:
///
///     Container(\.deep)
///         .withContainers(\.network)
///
/// Note: Extend `ContainerKeys` to add more keys if you need to define additional containers.
public struct ContainerKeys {
    internal init() {}
}

extension ContainerKeys {
    var deep: ContainerKey { "deep" }
}
