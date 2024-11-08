import Foundation

protocol NetworkService {
    func execute()
}
class Networker: NetworkService {
    func execute() {
        print("Networker execute")
    }
}
class NetworkerSecond: NetworkService {
    func execute() {
        print("NetworkerSecond execute")
    }
}
