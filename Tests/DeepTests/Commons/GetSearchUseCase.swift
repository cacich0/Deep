import Foundation

class GetSearchUseCase {
    let network: NetworkService
    init(network: NetworkService) {
        self.network = network
    }
    
    func execute() {
        network.execute()
        print("GetSearchUseCase execute")
    }
}
