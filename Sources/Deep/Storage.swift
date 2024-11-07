import Foundation

internal class Storage {
    
    internal static let `default` = Storage()
    
    internal var attachedContainers: [ContainerKey: Container] = [:]
    internal var deep: Deep?
    
    private init() {}
    
}
