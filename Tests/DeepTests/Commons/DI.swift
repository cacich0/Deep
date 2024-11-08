import Deep

class DI: Deep {
    override func setup() {
        setupNetworkContainer()
        setupUseCaseContainer()
        setupOthersContainer()
    }
    
    private func setupNetworkContainer() {
        Container(\.network) {
            WithInterface(
                Lazy(Networker()),
                interface: NetworkService.self
            )
            WithLazy(DataLoader(), type: DataLoader.self)
            WithIdentifier(
                identifier: "NetworkerSecond",
                instance: Lazy(NetworkerSecond()),
                interface: NetworkService.self
            )
        }
    }
    
    private func setupUseCaseContainer() {
        Container(\.usecase)
            .withContainers(\.network)
            .add { resolver in
                GetUserUseCase(network: resolver.get(NetworkService.self)!)
                WithLazy(GetSearchUseCase(network: resolver.get(NetworkService.self)!), type: GetSearchUseCase.self)
            }
    }
    
    private func setupOthersContainer() {
        Container(\.others) {
            AccountService { print("Account Get") }
        }
        
        Container(\.others) {
            Statistics()
        }
    }
}
