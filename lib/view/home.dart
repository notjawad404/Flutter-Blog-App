import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final TextEditingController _textcontroller = TextEditingController();
  
  HomePage({super.key});

  void sendMessage(String message) {
    print(message);
    _textcontroller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Todo App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to Flutter Todo App',
            ),
            ElevatedButton(onPressed: () {
              if (_textcontroller.text.isNotEmpty) {
                sendMessage(_textcontroller.text);
              }
              else {
                print('Please enter a message');
              }

            }, child: Text('Click Me')),
          ],
        
      ),
      ),
    );
  }
}