//
//  Inject.swift
//  InjectionKit
//
//  Created by Bastiaan Verreijt on 08/05/2021.
//

import Foundation

///
/// Dependency Injection annotation to inject instances, registered in the _DependencyInjectionRegistry_
///
/// Usage is as follows:
/// 1. Register an instance in the __DependencyInjectionRegistry__ using the __@Injectable__ annotation.
/// 2. Inject the instance in any class that requires that instance using __@Inject__.
///
/// __Example__:
///
///     // In some class:
///     @Injectable var dataSource = DataSource()
///
///     // In some other class:
///     @Inject private var dataSource: DataSource?
///
/// There are some limitations on @Inject  and @Injectable properties:
///  - The property must be a __var__.
///  - The property cannot be __lazy__, __@NSCopying__, __@NSManaged__, __weak__, or __unowned__.
///  - The property cannot be overridden in a subclass.
///  - The property with this __@Inject__ wrapper cannot have custom set or get method.
///
/// Per default, the registered instances will be matched by _Type_.
/// Instances also can be registered under a specific name, which is useful when there are multiple different
/// instances of the same type (e.g. when using protocols). In this case, a __named__ parameter needs to be specified.
///
/// __Example__:
///
///     // In some class:
///     @Injectable(named: "UserData") var userDataSource: DataSource = UserDataSource()
///     @Injectable(named: "SystemData") var systemDataSource: DataSource = SystemDataSource()
///
///     // In some other class:
///     @Inject(named: "UserData") private var userDataSource: DataSource?
///     @Inject(named: "SystemData") private var systemDataSource: DataSource?
///
@propertyWrapper
public struct Inject<T> {
    public var named: String?
    public var wrappedValue: T? {
        named != nil
            ? DependencyInjectionRegistry.shared.get(named: named) as? T
            : DependencyInjectionRegistry.shared.get(ofType: T.self) as? T
    }

    /// Inject a injectable instance by matching the specified name.
    /// - Parameter named: The name matching a registered injectable instance.
    public init(named: String) {
        self.named = named
    }

    /// Inject an injectable instance matching by Type.
    /// - Parameter wrappedValue: The wrapped value to be assigned a matching injectable instance.
    public init(wrappedValue: T?, named: String? = nil) {
        self.named = named
    }
}
