import 'dart:async';

import 'package:meta/meta.dart';
import 'package:flutter/widgets.dart' hide Builder;
import 'package:built_redux/built_redux.dart';

/// [StoreConnector] is a widget that rebuilds when the redux store
/// has triggered and the connect function yields a new result.
/// [LocalState] should be comparable. It is recommended to only use primitive and built types.
abstract class StoreConnector<StoreState, Actions extends ReduxActions,
    LocalState> extends StatefulWidget {
  StoreConnector({Key key}) : super(key: key);

  /// [connect] takes the current state of the redux store and retuns an object that contains
  /// the subset of the redux state tree that this component cares about.
  @protected
  LocalState connect(StoreState state);

  @override
  StoreConnectorState<StoreState, Actions, LocalState> createState() =>
      new StoreConnectorState<StoreState, Actions, LocalState>();

  @protected
  Widget build(BuildContext context, LocalState state, Actions actions);
}

class StoreConnectorState<StoreState, Actions extends ReduxActions, LocalState>
    extends State<StoreConnector<StoreState, Actions, LocalState>> {
  StreamSubscription<SubstateChange<LocalState>> _storeSub;

  /// [LocalState] is an object that contains the subset of the redux state tree that this component
  /// cares about.
  LocalState _state;

  Store get _store {
    // get the store from the ReduxProvider ancestor
    final ReduxProvider reduxProvider =
        context.inheritFromWidgetOfExactType(ReduxProvider);

    // if it is not found raise an error
    if (reduxProvider == null) {
      throw new Exception(
          'Store was not found, make sure ReduxProvider is an ancestor of this component.');
    }

    if (reduxProvider.store.state is! StoreState) {
      throw new Exception(
          'Store found was not the correct type, make sure StoreConnector\'s generic for StoreState matches the state type of your built_redux store.');
    }

    if (reduxProvider.store.actions is! Actions) {
      throw new Exception(
          'Store found was not the correct type, make sure StoreConnector\'s generic for Actions matches the actions type of your built_redux store.');
    }

    return reduxProvider.store;
  }

  /// setup a subscription to the store
  @override
  @mustCallSuper
  void didChangeDependencies() {
    super.didChangeDependencies();

    // if the store has already been subscribed to return early. didChangeDependencies
    // will be called every time the dependencies of the widget change, but we only
    // want to subscribe to the store the first time it is called. Subscriptions are setup
    // in didChangeDependencies, rather than initState, because inheritFromWidgetOfExactType
    // cannot be called before initState completes.
    // See https://github.com/flutter/flutter/blob/0.0.20/packages/flutter/lib/src/widgets/framework.dart#L3721
    if (_storeSub != null) return;

    // set the initial state
    _state = widget.connect(_store.state as StoreState);

    // listen to changes
    _storeSub = _store
        .substateStream((state) => widget.connect(state as StoreState))
        .listen((change) {
      setState(() {
        _state = change.next;
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

  @override
  Widget build(BuildContext context) =>
      widget.build(context, _state, _store.actions);
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
