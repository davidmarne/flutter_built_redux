import 'dart:async';

import 'package:meta/meta.dart';
import 'package:flutter/widgets.dart' hide Builder;
import 'package:built_redux/built_redux.dart';
import 'package:built_value/built_value.dart';

/// [StoreConnector] is a widget that rebuilds when the redux store
/// has triggered and the connect function yields a new result.
/// [LocalState] should be comparable. It is recommended to only use primitive and built types.
abstract class StoreConnector<
    StoreState extends Built<StoreState, StoreStateBuilder>,
    StoreStateBuilder extends Builder<StoreState, StoreStateBuilder>,
    Actions extends ReduxActions,
    LocalState> extends StatefulWidget {
  StoreConnector({Key key}) : super(key: key);

  StreamSubscription<SubstateChange<LocalState>> _storeSub;

  /// [connect] takes the current state of the redux store and retuns an object that contains
  /// the subset of the redux state tree that this component cares about.
  @protected
  LocalState connect(StoreState state);

  @override
  StoreConnectorState<StoreState, StoreStateBuilder, Actions, LocalState>
      createState() => new StoreConnectorState<StoreState, StoreStateBuilder,
          Actions, LocalState>();

  @protected
  Widget build(BuildContext context, LocalState state, Actions actions);
}

class StoreConnectorState<
        StoreState extends Built<StoreState, StoreStateBuilder>,
        StoreStateBuilder extends Builder<StoreState, StoreStateBuilder>,
        Actions extends ReduxActions,
        LocalState>
    extends State<
        StoreConnector<StoreState, StoreStateBuilder, Actions, LocalState>> {
  ReduxProvider _reduxProvider;

  /// [LocalState] is an object that contains the subset of the redux state tree that this component
  /// cares about.
  LocalState _state;

  Store<StoreState, StoreStateBuilder, Actions> get _store {
    // get the store from the ReduxProvider ancestor
    if (_reduxProvider == null) {
      _reduxProvider = context.inheritFromWidgetOfExactType(ReduxProvider);
      if (_reduxProvider == null)
        throw new Exception(
            "Store was not found, make sure ReduxProvider is an ancestor of this component");
    }
    return _reduxProvider.store;
  }


  @override
  @mustCallSuper
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget._storeSub == null) {
      _subscribe();
    }
  }

  @override
  @mustCallSuper
  void didUpdateWidget(StoreConnector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._storeSub == null || oldWidget._storeSub != widget._storeSub) {
      _subscribe();
    }
  }

  /// Cancel the store subscription.
  @override
  @mustCallSuper
  void deactivate() {
    _unsubscribe();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return widget.build(context, _state, _store.actions);
  }

  _subscribe() {
    // set the initial state
    _state = widget.connect(_store.state);

    _unsubscribe();
    // listen to changes
    widget._storeSub = _store.substateStream(widget.connect).listen((change) {
      setState(() {
        _state = change.next;
      });
    });
  }

  void _unsubscribe() {
    widget._storeSub?.cancel();
    widget._storeSub = null;
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
