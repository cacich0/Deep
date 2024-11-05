import Foundation

class CustomObjectIdentifier {
    internal let id: String
    
    init(id: String) {
        self.id = id
    }
    
    var objectIdentifier: ObjectIdentifier {
        ObjectIdentifier(self)
    }
}
