# InjectionKit

InjectionKit is a lightweight dependency injection library for SWIFT.

Its goal is to help writing cleaner code by decoupling the instantiation of dependencies from the places where it being used. The dependencies will simply be **injected** into the objects that depend on it.

This library makes use of Swift 5.1's **Property Wrappers**, which will allow developers to use a combination of **@Injectable** and **@Inject** to register instances for dependency injection and inject them.

## Usage

To mark a particular instance of a class available for injection, simply annotate the property that holds the instance with **@Injectable**:

```Swift
// In some class:
@Injectable var dataSource = DataSource()
```

Then in each class that needs this dependency, add a property for it and annotate it with **@Inject**:

```Swift
// In some other class:
@Inject private var dataSource: DataSource?
```

That is all!

### Named dependencies

Per default, the injected instances will be matched by **Type**. In some cases, particularly when using Protocols, there might be multiple instances of the same Type. Since the dependency registry used by **@Inject** and **@Injectable** is keeping track of the dependencies per Type, it is not possible to distinguish the instances from each other.

For these cases, you can specify a **named** parameter:

```Swift
// In some class:
@Injectable(named: "UserData") var userDataSource: DataSource = UserDataSource()
@Injectable(named: "SystemData") var systemDataSource: DataSource = SystemDataSource()
```

Then in each class that needs this dependency, add a named parameter to **@Inject**:

```Swift
// In some other class:
@Inject(named: "UserData") private var userDataSource: DataSource?
@Inject(named: "SystemData") private var systemDataSource: DataSource?
```

### Replacing dependencies

**@Inject** properties will dynamically _get_ the registered instance from its internal dependency registry. This means that if you would assign a new instance to an **@Injectable** property, it will update the registered instance in the dependency registry and becomes available at the \__@Inject_ properties.

For example, given:

```Swift
// In some class:
@Injectable(named: "luckynumbers") var numbers = [1, 2, 3, 4]
```

```Swift
 // In some other class
 @Inject(named: "luckynumbers") var injected: [Int]?
```

Initially, _injected_ will see: `[1, 2, 3, 4]`. but when you replace numbers with something else: ` numbers = [5, 6, 7, 8]`, then _injected_ will see: `[5, 6, 7, 8]`.

## Limitations and Concerns

There are some limitations on **@Inject** and **@Injectable** properties:

- The property must be a **var**.
- The property cannot be **lazy**, **@NSCopying**, **@NSManaged**, **weak**, or **unowned**.
- The property cannot be overridden in a subclass.
- The property cannot have a custom set or get method.
