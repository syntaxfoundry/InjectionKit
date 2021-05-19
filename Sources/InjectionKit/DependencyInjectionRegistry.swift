//
//  DependencyInjectionRegistry.swift
//  InjectionKit
//
//  Created by Bastiaan Verreijt on 08/05/2021.
//

import Foundation

/// The DependencyInjectionRegistry holds a reference to all registered instances and makes them available for
/// dependency injection. The instances can be retrieved by its __Type__ or by its __named__ parameter if that
/// was given during registration.
struct DependencyInjectionRegistry {
    static var shared = DependencyInjectionRegistry()
    private var _registry: [String: Any?] = [:]

    /// Register a new instance in the dependency injection registry.
    /// This will make the instance available by its Type, or when provided by its named parameter.
    /// Any existing entry will be overwritten.
    ///
    /// - parameter instance: The instance that needs to be registered.
    /// - parameter named: Optional name to be used in the register for this instance.
    mutating func register<T: Any>(instance: T, named name: String? = nil) {
        let key = name ?? type(of: instance)
        _registry[key] = instance
    }

    /// Returns the type of the provide instance as a String.
    /// - Parameter instance: The instance to inspect.
    /// - Returns: The type of the instance.
    private func type<T: Any>(of instance: T) -> String {
        String(describing: Swift.type(of: instance))
            .replacingOccurrences(of: "Optional<([^>]+)>",
                                  with: "$1",
                                  options: .regularExpression)
    }

    /// Returns an optional instance for a given class type
    ///
    /// - parameter ofType: The class type e.g. _someObject.self_
    func get<T>(ofType: T) -> Any? {
        let instanceType = String(describing: ofType)
        return get(key: instanceType)
    }

    /// Returns an optional instance for a given class type
    ///
    /// - parameter named: The  name it was registered with
    func get(named: String?) -> Any? {
        guard let name = named, !name.isEmpty else { return nil }
        return get(key: name)
    }

    /// Retrieves the injectable instance from the registry
    /// - Parameter key: The key identifying the stored instance.
    /// - Returns: The instnace if found, nil otherwise.
    private func get(key: String) -> Any? {
        _registry[key] ?? nil
    }
}
