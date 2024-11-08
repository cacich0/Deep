# Deep

A lightweight dependency injection container for Swift, designed to facilitate clean architecture and easier dependency management in your applications. This library leverages Swift's powerful type system, property wrappers, and a Domain-Specific Language (DSL) to provide a flexible and intuitive API. The DSL allows for seamless and expressive registration of dependencies, making the setup process more natural and readable.

## Features

- Register dependencies using DSL, closures and custom identifiers.
- Resolve dependencies with strong typing and minimal boilerplate.
- Support for nested containers to organize dependencies hierarchically.
- Property wrappers for convenient access to resolvers.
- A DSL for intuitive and expressive dependency registration.

## Getting Started

### Installation

To integrate this library into your project, you can add it via Swift Package Manager. Include the following dependency in your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/cacich0/Deep.git", from: "1.1.0")
],
targets: [
    .target(
        name: "MyProject",
        dependencies: [..., "Deep"]
    )
    ...
]
```

### Usage

#### Creating Deep
Deep is the main thing of the whole library, it represents the entity to which all the containers you need will be added.

`DI.swift`
```swift
import Deep

class DI: Deep {
    override func setup() {}
}

let deep = DI(childrens: \.network, \.others, \.usecase)
```

#### Setting Up the Containers inside Deep
You should override the setup method inside Deep and add the required containers, but before that you should create keys for those containers.

#### Key creation
`ContainerKeys.swift`
```swift
import Deep

extension ContainerKeys {
    var network: ContainerKey { "network" }
    var usecase: ContainerKey { "usecase" }
    var others: ContainerKey { "others" }
}
```

#### Containers creation
Adding simple dependencies.
```swift
Container(\.network) {
    DataLoader()
    NetworkService()
}
```
Adding dependencies with the interface.
```swift
Container(\.network) {
    WithInterface(
        Networker(),
        interface: NetworkService.self
    )
}
```
How to add multiple dependencies with one interface? Need to use an identifier.
```swift
Container(\.network) {
    WithInterface(
        Networker(),
        interface: NetworkService.self
    )
    WithIdentifier(
        identifier: "NetworkerSecond",
        instance: NetworkerSecond(),
        interface: NetworkService.self
    )
}
```
How to use added dependencies to add a new dependency.
So you can call the add method to use `Resolver`. Note, if you want to use other containers inside your container you can do so using the `withDependency` method, in which case the add method **must be called after it**.
```swift
Container(\.usecase)
    .withContainers(\.network)
    .add { resolver in
        GetUserUseCase(network: resolver.get(NetworkService.self)!)
        GetSearchUseCase(network: resolver.get(NetworkService.self)!)
    }
```
You can also use `WithLazy` for lazy registration if you want your object to be initialized while the object is being accessed. `Lazy` does the same thing, but you have to wrap your objects that you use inside `WithInterface` and `WithIdentifier` in it.

_Note_: Use this only if you don't need to initialize the object immediately.
```swift
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
```

#### Property Wrappers
##### @Resolvers
Use the `@Resolvers` property wrapper to inject a resolver for a specific container key:
```swift
@Resolvers(\.network) var networkResolver: Resolver!

networkResolver.get(AccountService.self)?.get()
```
##### @Injection
Use the `@Injection` property wrapper to access the main Deep instance for global dependency resolution:
```swift
@Injection var deep: Deep!

deep.get(GetUserUseCase.self)?.execute()
deep.get(GetSearchUseCase.self)?.execute()
deep.get(AccountService.self)?.get()
deep.get(DataLoader.self)?.execute()
deep.get(Statistics.self)?.execute()
deep.get(NetworkService.self, identifier: "NetworkerSecond")?.execute()
```
