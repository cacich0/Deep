import Foundation

public struct Lazy {
    internal let block: () -> Any
    
    public init(_ block: @escaping @autoclosure () -> Any) {
        self.block = block
    }
}

public struct WithLazy {
    private let block: () -> Any
    internal let type: Any.Type
    internal var lazy: Lazy { .init(block) }
    
    public init(_ block: @escaping @autoclosure () -> Any, type: Any.Type) {
        self.block = block
        self.type = type
    }
}
