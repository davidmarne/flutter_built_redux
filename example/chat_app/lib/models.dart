import 'dart:math' show Random;

import 'package:flutter/material.dart';

class ChatUser {
  ChatUser()
      : name = "Guest${new Random().nextInt(1000)}",
        color =
            Colors.accents[new Random().nextInt(Colors.accents.length)][700];

  final String name;
  final Color color;
}

class ChatMessage {
  ChatMessage({this.sender, this.text});
  final ChatUser sender;
  final String text;
}
