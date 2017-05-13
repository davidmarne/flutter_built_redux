import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';
import 'package:built_redux/built_redux.dart';

import 'redux/chat_messages.dart';
import './models.dart';

void main() {
  runApp(new MaterialApp(
      title: 'Chat',
      theme: new ThemeData(primarySwatch: Colors.purple, accentColor: Colors.orangeAccent[400]),
      home: new ChatProvider()));
}

class ChatProvider extends StatelessWidget {
  final store = new Store<ChatMessages, ChatMessagesBuilder, ChatMessagesActions>(
    new ChatMessages(),
    new ChatMessagesActions(),
  );

  @override
  Widget build(BuildContext context) {
    return new InheritedStore(
      store: store,
      child: new ChatScreen(),
    );
  }
}

class ChatScreen extends StoreConnector<ChatMessages, ChatMessagesBuilder, ChatMessagesActions,
    ChatMessages, ChatMessagesBuilder> {
  ChatScreen({Key key}) : super(key: key);

  @override
  ChatMessages connect(Store<ChatMessages, ChatMessagesBuilder, ChatMessagesActions> store) =>
      store.state;

  ChatScreenState createState() => new ChatScreenState();
}

class ChatScreenState extends StoreConnectorState<ChatMessages, ChatMessagesBuilder,
    ChatMessagesActions, ChatMessages, ChatMessagesBuilder> {
  Widget _buildTextComposer(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return new Row(children: <Widget>[
      new Flexible(
          child: new TextField(
              decoration: new InputDecoration(
                hintText: 'Type something',
              ),
              controller: new TextEditingController(text: state.currentMessage),
              onSubmitted: (_) => actions.commitCurrentMessageAction(me),
              onChanged: actions.setCurrentMessageAction)),
      new Container(
          margin: new EdgeInsets.symmetric(horizontal: 4.0),
          child: new IconButton(
              icon: new Icon(Icons.send),
              onPressed: state.isComposing ? () => actions.commitCurrentMessageAction(me) : null,
              color: state.isComposing ? themeData.accentColor : themeData.disabledColor))
    ]);
  }
  //

  final ChatUser me = new ChatUser();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Chatting as ${me.name}')),
      body: new ListView(
        padding: new EdgeInsets.symmetric(vertical: 8.0),
        children: state.messages.map((ChatMessage message) {
          return new ChatMessageListItem(message);
        }).toList(),
      ),
      bottomNavigationBar: _buildTextComposer(context),
    );
  }
}

class ChatMessageListItem extends StatefulWidget {
  ChatMessageListItem(ChatMessage m)
      : message = m,
        super(key: new ObjectKey(m));

  final ChatMessage message;

  @override
  State createState() => new ChatMessageListItemState();
}

class ChatMessageListItemState extends State<ChatMessageListItem>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        new AnimationController(vsync: this, duration: new Duration(milliseconds: 700));
    _animation = new CurvedAnimation(parent: _animationController, curve: Curves.easeOut);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ChatMessage message = widget.message;
    return new SizeTransition(
        sizeFactor: _animation,
        axisAlignment: 0.0,
        child: new ListTile(
            dense: true,
            leading: new CircleAvatar(
                child: new Text(message.sender.name[0]), backgroundColor: message.sender.color),
            title: new Text(message.sender.name),
            subtitle: new Text(message.text)));
  }
}
