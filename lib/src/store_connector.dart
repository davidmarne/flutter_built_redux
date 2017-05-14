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

  /// [connect] takes the current state of the redux store and retuns an object that contains
  /// the subset of the redux state tree that this component cares about.
  @protected
  LocalState connect(StoreState state);
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
  ReduxProvider _reduxProvider;

  /// [LocalState] is an object that contains the subset of the redux state tree that this component
  /// cares about.
  LocalState state;

  Store<StoreState, StoreStateBuilder, Actions> get store {
    // get the store from the ReduxProvider ancestor
    if (_reduxProvider == null) {
      _reduxProvider = context.inheritFromWidgetOfExactType(ReduxProvider);
      if (_reduxProvider == null)
        throw new Exception(
            "Store was not found, make sure ReduxProvider is an ancestor of this component");
    }
    return _reduxProvider.store;
  }

  /// [actions] returns the actions object that contains the [ActionDispatchers] associated with the redux store
  Actions get actions => store.actions;

  /// setup a subscription to the store
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // set the initial state
    state = widget.connect(store.state);

    // listen to changes
    _storeSub = store.subscribe.listen((_) {
      // get the next state
      LocalState nextLocalState = widget.connect(store.state);

      // if the result is different that the previous state call setState
      if (nextLocalState != state)
        setState(() {
          state = nextLocalState;
        });
    });
  }

  /// Cancel the store subscription.
  @override
  @mustCallSuper
  void dispose() {
    _storeSub.cancel();
    super.dispose();
  }
}

/// [ReduxProvider] provides access to the redux store to descendant widgets.
class ReduxProvider extends InheritedWidget {
  ReduxProvider({Key key, @required this.store, @required Widget child})
      : super(key: key, child: child);

  /// [store] is a reference to the redux store
  final Store store;

  @override
  bool updateShouldNotify(ReduxProvider old) => store != old.store;
}
