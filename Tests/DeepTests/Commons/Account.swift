import Foundation

protocol Account {
    var get: () -> Void { get }
}

class AccountService: Account {
    var get: () -> Void
    
    init(get: @escaping () -> Void) {
        self.get = get
    }
}
