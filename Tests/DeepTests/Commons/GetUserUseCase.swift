import Foundation

class GetUserUseCase {
    let network: NetworkService
    init(network: NetworkService) {
        self.network = network
    }
    
    func execute() {
        network.execute()
        print("GetUseUseCase execute")
    }
}
