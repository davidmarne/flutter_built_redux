## 0.4.1

* Add changelog

## 0.4.0

* **Breaking changes**:

  * Remove state builder generic from StoreConnector

  * Made StoreConnectorState private

* Perform check on storeSub in didChangeDependencies to return early if a subscription to the store has already been created.

* Raise exceptions if the store found by inheritFromWidgetOfExactType has different generics than the StoreConnector

* Add unit tests
