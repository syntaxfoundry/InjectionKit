//
//  Injectable.swift
//  InjectionKit
//
//  Created by Bastiaan Verreijt on 08/05/2021.
//

import Foundation

///
/// Dependency Injection annotation to register an instance in the _DependencyInjectionRegistry_ so that it
/// can be injected with the __@Inject__ annotation. The instance will be registered by its _Type_ or by
/// its _named_ parameter if provided.
///
/// See __@Inject__ for details.
@propertyWrapper
public struct Injectable<T> {
    public var value: T
    public var named: String?
    public var wrappedValue: T {
        get {
            value
        }
        set {
            value = newValue
            DependencyInjectionRegistry.shared.register(instance: value, named: named)
        }
    }

    /// Register an injectable instance by its type.
    /// - Parameter wrappedValue: The property value being registered as an injectable instance.
    public init(wrappedValue: T) {
        self.value = wrappedValue
        DependencyInjectionRegistry.shared.register(instance: value)
    }

    /// Register an injectable instance by the specified name.
    /// - Parameter wrappedValue: The property value being registered as an injectable instance.
    public init(wrappedValue: T, named: String) {
        self.value = wrappedValue
        self.named = named
        DependencyInjectionRegistry.shared.register(instance: value, named: named)
    }
}
