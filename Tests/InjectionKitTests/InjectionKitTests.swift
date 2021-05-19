import XCTest
@testable import InjectionKit

private class ClassA {
    var result = ""
    init(result: String) {
        self.result = result
    }
}

private struct StructB {
    var result = ""
}

private class ClassC: P {
    var result = ""
    init(result: String) {
        self.result = result
    }
}

private protocol P {
    var result: String { get }
}

final class InjectionKitTests: XCTestCase {
    /// Test if a registered class can be injected
    func testInjectClass() {
        class InjectableTest {
            @Injectable private var classA = ClassA(result: "A")
        }
        _ = InjectableTest()
        class InjectTest {
            @Inject var injected: ClassA?
        }
        let injectTest = InjectTest()
        XCTAssertEqual(injectTest.injected?.result, "A")
    }

    /// Test if structs can be injected
    func testInjectStruct() {
        class InjectableTest {
            @Injectable var structB = StructB(result: "B")
        }
        _ = InjectableTest()
        class InjectTest {
            @Inject var injected: StructB?
        }
        let injectTest = InjectTest()
        XCTAssertEqual(injectTest.injected?.result, "B")
    }

    /// Test if updating a registered class in the registry also updates the injected references
    func testInjectClassWithUpdatedRegistry() {
        class InjectableTest {
            @Injectable var classA = ClassA(result: "A")
        }
        let injectableTest = InjectableTest()
        class InjectTest {
            @Inject var injected: ClassA?
        }
        let injectTest = InjectTest()
        XCTAssertEqual(injectTest.injected?.result, "A")
        injectableTest.classA = ClassA(result: "UpdatedA")
        XCTAssertEqual(injectTest.injected?.result, "UpdatedA")
    }

    /// Test if updating a registered array in the registry also updates the injected references
    func testInjectArrayWithUpdatedRegistry() {
        class InjectableTest {
            @Injectable(named: "luckynumbers") var numbers = [1, 2, 3, 4]
        }
        let injectableTest = InjectableTest()
        class InjectTest {
            @Inject(named: "luckynumbers") var injected: [Int]?
        }
        let injectTest = InjectTest()
        XCTAssertEqual(injectTest.injected, [1, 2, 3, 4])
        injectableTest.numbers = [5, 6, 7, 8]
        XCTAssertEqual(injectTest.injected, [5, 6, 7, 8])
    }

    /// Test if updating a registered struct in the registry also updates the injected references
    func testInjectStructWithUpdatedRegistry() {
        class InjectableTest {
            @Injectable var structB = StructB(result: "B")
        }
        let injectableTest = InjectableTest()
        class InjectTest {
            @Inject var injected: StructB?
        }
        let injectTest = InjectTest()
        XCTAssertEqual(injectTest.injected?.result, "B")
        injectableTest.structB = StructB(result: "UpdatedB")
        XCTAssertEqual(injectTest.injected?.result, "UpdatedB")
    }

    /// Test if named instances can be injected
    func testInjectNamedClass() {
        class InjectableTest {
            @Injectable(named: "C") private var classC = ClassC(result: "C")
            @Injectable(named: "D") private var classD = ClassC(result: "D")
        }
        _ = InjectableTest()
        class InjectTest {
            @Inject(named: "C") var injectedC: P?
            @Inject(named: "D") var injectedD: P?
        }
        let injectTest = InjectTest()
        XCTAssertEqual(injectTest.injectedC?.result, "C")
        XCTAssertEqual(injectTest.injectedD?.result, "D")
    }

    /// Test if circular dependencies can be injected
    func testInjectCircularDependencies() {
        class InjectTestA {
            @Injectable(named: "circularA") var injectableA = ClassC(result: "circularA")
            @Inject(named: "circularB") var injectedB: P?
        }
        class InjectTestB {
            @Injectable(named: "circularB") var injectableA = ClassC(result: "circularB")
            @Inject(named: "circularA") var injectedA: P?
        }
        let injectTestA = InjectTestA()
        let injectTestB = InjectTestB()
        XCTAssertEqual(injectTestA.injectedB?.result, "circularB")
        XCTAssertEqual(injectTestB.injectedA?.result, "circularA")
    }

    /// Test if not registered classes will be injected as nil.
    /// Property wrappers cannot throw exceptions, so for now there is no better solution for this situation.
    func testInjectedClassNotExisting() {
        class SomeClass { }
        class InjectTest {
            @Inject var injected: SomeClass?
        }
        let injectTest = InjectTest()
        XCTAssertNil(injectTest.injected)
    }

    /// Test if not existing named classes will be injected as nil.
    /// Property wrappers cannot throw exceptions, so for now there is no better solution for this situation.
    func testInjectedNamedClassNotExisting() {
        class InjectTest {
            @Inject(named: "NotExisting") var injected: ClassA?
        }
        let injectTest = InjectTest()
        XCTAssertNil(injectTest.injected)
    }

    /// Test nilling registered instances
    func testInjectNilledClass() {
        class InjectableTest {
            @Injectable var classA: ClassA? = ClassA(result: "A")
        }
        class InjectTest {
            @Inject var injected: ClassA?
        }
        let injectableTest: InjectableTest? = InjectableTest()
        let injectTest = InjectTest()
        XCTAssertEqual(injectTest.injected?.result, "A")
        injectableTest?.classA = nil
        XCTAssertNil(injectTest.injected?.result)
    }

    static var allTests = [
        ("testInjectClass", testInjectClass),
        ("testInjectStruct", testInjectStruct),
        ("testInjectClassWithUpdatedRegistry", testInjectClassWithUpdatedRegistry),
        ("testInjectArrayWithUpdatedRegistry", testInjectArrayWithUpdatedRegistry),
        ("testInjectStructWithUpdatedRegistry", testInjectStructWithUpdatedRegistry),
        ("testInjectNamedClass", testInjectNamedClass),
        ("testInjectCircularDependencies", testInjectCircularDependencies),
        ("testInjectedClassNotExisting", testInjectedClassNotExisting),
        ("testInjectedNamedClassNotExisting", testInjectedNamedClassNotExisting),
        ("testInjectNilledClass", testInjectNilledClass),
    ]
}
