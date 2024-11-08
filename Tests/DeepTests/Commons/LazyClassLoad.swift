import Foundation

class LazyClassLoad {
    let initCompletion: () -> Void
    init(initCompletion: @escaping () -> Void) {
        self.initCompletion = initCompletion
        self.initCompletion()
    }
}
