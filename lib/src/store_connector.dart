import 'dart:async';

import 'package:meta/meta.dart';
import 'package:flutter/widgets.dart' hide Builder;
import 'package:built_redux/built_redux.dart';
import 'package:built_value/built_value.dart';

abstract class StoreConnector<
    StoreState extends BuiltReducer<StoreState, StoreStateBuilder>,
    StoreStateBuilder extends Builder<StoreState, StoreStateBuilder>,
    Actions extends ReduxActions,
    LocalState extends Built<LocalState, LocalStateBuilder>,
    LocalStateBuilder extends Builder<LocalState, LocalStateBuilder>> extends StatefulWidget {
  StoreConnector({Key key}) : super(key: key);

  @protected
  LocalState connect(Store<StoreState, StoreStateBuilder, Actions> store);
}

abstract class StoreConnectorState<
        StoreState extends BuiltReducer<StoreState, StoreStateBuilder>,
        StoreStateBuilder extends Builder<StoreState, StoreStateBuilder>,
        Actions extends ReduxActions,
        LocalState extends Built<LocalState, LocalStateBuilder>,
        LocalStateBuilder extends Builder<LocalState, LocalStateBuilder>>
    extends State<
        StoreConnector<StoreState, StoreStateBuilder, Actions, LocalState, LocalStateBuilder>> {
  StreamSubscription<StoreChange<StoreState, StoreStateBuilder, Actions>> _storeSub;

  LocalState state;
  InheritedStore _inheritedStore;

  Store<StoreState, StoreStateBuilder, Actions> get store {
    if (_inheritedStore == null) {
      _inheritedStore = context.inheritFromWidgetOfExactType(InheritedStore);
      if (_inheritedStore == null)
        throw new Exception(
            "Store was not found in context, make sure your component tree is wrapped in a provider");
    }
    return _inheritedStore.store;
  }

  Actions get actions => store.actions;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    state = widget.connect(store);
    _storeSub = store.subscribe.listen((_) {
      LocalState nextLocalState = widget.connect(store);
      if (nextLocalState != state)
        setState(() {
          state = nextLocalState;
        });
    });
  }

  /// Cancel all store subscriptions.
  @override
  @mustCallSuper
  void dispose() {
    _storeSub.cancel();
    super.dispose();
  }
}

/// Inject a store for descendant widgets.
class InheritedStore extends InheritedWidget {
  InheritedStore({Key key, @required this.store, @required Widget child})
      : super(key: key, child: child);

  final Store store;

  @override
  bool updateShouldNotify(InheritedStore old) => store != old.store;
}
