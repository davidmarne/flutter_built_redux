## 0.6.0
* Migrate to Dart 2
* Bump dependencies to more recent versions

## 0.5.0

* **Breaking changes**:
  * Renamed the typdef WidgetBuilder to StoreConnectionBuilder to avoid possible namespacing issues.

## 0.4.5

* create explicit typedefs for funcs passed to StoreConnection, as the new Function syntax messes up the analyzer

## 0.4.4

* add StoreConnection, which is an implementation of store connector that takes a connect & builder function as parameters.
* add example file.

## 0.4.3

* Move built_value dependency to dev_dependencies and bump to ^5.0.0

## 0.4.2

* Use assert for type assertions rather than thowing exceptions

## 0.4.1

* Add changelog

## 0.4.0

* **Breaking changes**:

  * Remove state builder generic from StoreConnector

  * Made StoreConnectorState private

* Perform check on storeSub in didChangeDependencies to return early if a subscription to the store has already been created.

* Raise exceptions if the store found by inheritFromWidgetOfExactType has different generics than the StoreConnector

* Add unit tests
