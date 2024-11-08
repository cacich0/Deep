import XCTest
@testable import Deep

final class DeepTests: XCTestCase {
    
    private let di = DI(childrens: \.network, \.others, \.usecase)
    
    @Injection var deep: Deep?
    @Resolvers(\.others) var otherResolver: Resolver?
    @Resolvers(\.usecase) var usecaseResolver: Resolver?
    
    func testDeepExist() throws {
        XCTAssertNotNil(deep)
    }
    
    func testOtherResolverExist() throws {
        XCTAssertNotNil(otherResolver)
    }
    
    func testSimpleRegister() throws {
        let instance = deep?.get(DataLoader.self)
        XCTAssertNotNil(instance)
    }
    
    func testSimpleRegisterNotLazy() throws {
        var isLoaded = false
        Container(\.network) {
            LazyClassLoad(initCompletion: { isLoaded = true })
        }
        XCTAssertTrue(isLoaded)
    }
    
    func testInterfaceRegister() throws {
        let instance = deep?.get(NetworkService.self)
        XCTAssertNotNil(instance)
        let isNetworker = instance is Networker
        XCTAssertTrue(isNetworker)
    }
    
    func testCustomIdentifier() throws {
        let instance = deep?.get(NetworkService.self, identifier: "NetworkerSecond")
        XCTAssertNotNil(instance)
        let isNetworkerSecond = instance is NetworkerSecond
        XCTAssertTrue(isNetworkerSecond)
    }
    
    func testResolverMultiInit() throws {
        let statistics = otherResolver?.get(Statistics.self)
        let account = otherResolver?.get(AccountService.self)
        XCTAssertNotNil(statistics)
        XCTAssertNotNil(account)
    }
    
    func testResolverHaveNotOtherContainer() throws {
        let statistics = usecaseResolver?.get(Statistics.self)
        XCTAssertNil(statistics)
    }
    
    func testLazyRegister() throws {
        var isLoaded = false
        Container(\.others) {
            WithLazy(LazyClassLoad(initCompletion: {
                isLoaded = true
            }), type: LazyClassLoad.self)
        }
        XCTAssertFalse(isLoaded)
        let _ = otherResolver?.get(LazyClassLoad.self)
        XCTAssertTrue(isLoaded)
    }
}
