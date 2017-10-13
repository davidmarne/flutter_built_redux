import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';
import 'package:built_redux/built_redux.dart';

import 'redux/chat_messages.dart';
import './models.dart';

void main() {
  runApp(new MaterialApp(
      title: 'Chat',
      theme: new ThemeData(
          primarySwatch: Colors.purple, accentColor: Colors.orangeAccent[400]),
      home: new ChatProvider()));
}

class ChatProvider extends StatelessWidget {
  final store =
      new Store<ChatMessages, ChatMessagesBuilder, ChatMessagesActions>(
    createReducer(),
    new ChatMessages(),
    new ChatMessagesActions(),
  );

  @override
  Widget build(BuildContext context) {
    return new ReduxProvider(
      store: store,
      child: new ChatScreen(),
    );
  }
}

class ChatScreen extends StoreConnector<ChatMessages, ChatMessagesBuilder,
    ChatMessagesActions, ChatMessages> {
  ChatScreen({Key key}) : super(key: key);

  @override
  ChatMessages connect(ChatMessages state) => state;

  Widget _buildTextComposer(
      BuildContext context, ChatMessages state, ChatMessagesActions actions) {
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
              onPressed: state.isComposing
                  ? () => actions.commitCurrentMessageAction(me)
                  : null,
              color: state.isComposing
                  ? themeData.accentColor
                  : themeData.disabledColor))
    ]);
  }

  final ChatUser me = new ChatUser();

  @override
  Widget build(
      BuildContext context, ChatMessages state, ChatMessagesActions actions) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Chatting as ${me.name}')),
      body: new ListView(
        padding: new EdgeInsets.symmetric(vertical: 8.0),
        children: state.messages.map((ChatMessage message) {
          return new ListTile(
              dense: true,
              leading: new CircleAvatar(
                  child: new Text(message.sender.name[0]),
                  backgroundColor: message.sender.color),
              title: new Text(message.sender.name),
              subtitle: new Text(message.text));
        }).toList(),
      ),
      bottomNavigationBar: _buildTextComposer(context, state, actions),
    );
  }
}
