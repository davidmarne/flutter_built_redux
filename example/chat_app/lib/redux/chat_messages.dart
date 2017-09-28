library chat_messages;

import 'package:built_redux/built_redux.dart';
import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';

import '../models.dart';

part 'chat_messages.g.dart';

abstract class ChatMessagesActions extends ReduxActions {
  ActionDispatcher<String> setCurrentMessageAction;
  ActionDispatcher<ChatUser> commitCurrentMessageAction;

  // factory to create on instance of the generated implementation ofChatMessagesActions
  ChatMessagesActions._();
  factory ChatMessagesActions() => new _$ChatMessagesActions();
}

setCurrentMessageAction(ChatMessages state, Action<String> action,
        ChatMessagesBuilder builder) =>
    builder..currentMessage = action.payload;

commitCurrentMessageAction(ChatMessages state, Action<ChatUser> action,
        ChatMessagesBuilder builder) =>
    builder
      ..messages.add(
          new ChatMessage(sender: action.payload, text: state.currentMessage))
      ..currentMessage = "";

createReducer() => (new ReducerBuilder<ChatMessages, ChatMessagesBuilder>()
      ..add<String>(ChatMessagesActionsNames.setCurrentMessageAction,
          setCurrentMessageAction)
      ..add<ChatUser>(ChatMessagesActionsNames.commitCurrentMessageAction,
          commitCurrentMessageAction))
    .build();

abstract class ChatMessages
    implements Built<ChatMessages, ChatMessagesBuilder> {
  BuiltList<ChatMessage> get messages;
  String get currentMessage;

  @memoized
  bool get isComposing => currentMessage != "";

  // Built value boilerplate
  ChatMessages._();
  factory ChatMessages([updates(ChatMessagesBuilder b)]) =>
      new _$ChatMessages((ChatMessagesBuilder b) => b..currentMessage = "");
}
