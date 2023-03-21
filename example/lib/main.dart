import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twilio_conversations_example/conversations/conversations_notifier.dart';
import 'package:twilio_conversations_example/conversations/conversations_page.dart';
// import 'package:twilio_conversations_example/services/backend_service.dart';

// import 'models/twilio_chat_token_request.dart';

void main() async {
  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Twilio Conversations Example'),
        ),
        body: Center(
          child: Column(
            children: [
              // _buildUserIdField(),
              _buildButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return ChangeNotifierProvider<ConversationsNotifier>(
      create: (_) => ConversationsNotifier(),
      child: Consumer<ConversationsNotifier>(
        builder: (BuildContext context, conversationsNotifier, Widget? child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: conversationsNotifier.identityController,
                onChanged: conversationsNotifier.updateIdentity,
              ),
              ElevatedButton(
                onPressed: conversationsNotifier.identity.isNotEmpty &&
                        !conversationsNotifier.isClientInitialized
                    ? () async {
                        // <Set your JWT token here>
                        String? jwtToken;
                        // jwtToken = (await BackendService.createToken(
                        //         TwilioChatTokenRequest(
                        //             identity: conversationsNotifier.identity)))
                        //     ?.token;
                        jwtToken =
                            'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImN0eSI6InR3aWxpby1mcGE7dj0xIn0.eyJqdGkiOiJTSzcxZjE4ZTljZTlhOTlhYTYxZDAzZGE4ZDA0ZWZlNDU2LTE2NzkzOTEyMDMiLCJpc3MiOiJTSzcxZjE4ZTljZTlhOTlhYTYxZDAzZGE4ZDA0ZWZlNDU2Iiwic3ViIjoiQUNlMjM4MzViYTI2YWQ0ZTRhMGRmZDIxNDMyYWJhYzA3ZiIsImV4cCI6MTY3OTM5NDgwMywiZ3JhbnRzIjp7ImlkZW50aXR5IjoiOTAyRjRBIiwiY2hhdCI6eyJzZXJ2aWNlX3NpZCI6IklTYzUzODVjYzIwYTllNDlmNWE0ZTRlZmQ2MWZiZWUyOTMiLCJwdXNoX2NyZWRlbnRpYWxfc2lkIjoiQ1I3YmY1MmE4NDBlYzMwZTg3YmMzNTAyYWM1NjUyZjk1OCJ9fX0.RFJ7Eyq3DttpXoLQi-5TZFMuU0Gvdo5AUgLtToXFYhY';
                        if (jwtToken == null) {
                          return;
                        }

                        if (jwtToken.isEmpty) {
                          _showInvalidJWTDialog(context);
                          return;
                        }
                        await conversationsNotifier.create(jwtToken: jwtToken);
                      }
                    : null,
                child: Text('Start Client'),
              ),
              ElevatedButton(
                onPressed: conversationsNotifier.isClientInitialized
                    ? () async {
                        String? jwtToken;
                        // jwtToken = (await BackendService.createToken(
                        //         TwilioChatTokenRequest(
                        //             identity: conversationsNotifier.identity)))
                        //     ?.token; // <Set your JWT token here>
                        jwtToken =
                            'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImN0eSI6InR3aWxpby1mcGE7dj0xIn0.eyJqdGkiOiJTSzcxZjE4ZTljZTlhOTlhYTYxZDAzZGE4ZDA0ZWZlNDU2LTE2NzkzOTEyMDMiLCJpc3MiOiJTSzcxZjE4ZTljZTlhOTlhYTYxZDAzZGE4ZDA0ZWZlNDU2Iiwic3ViIjoiQUNlMjM4MzViYTI2YWQ0ZTRhMGRmZDIxNDMyYWJhYzA3ZiIsImV4cCI6MTY3OTM5NDgwMywiZ3JhbnRzIjp7ImlkZW50aXR5IjoiOTAyRjRBIiwiY2hhdCI6eyJzZXJ2aWNlX3NpZCI6IklTYzUzODVjYzIwYTllNDlmNWE0ZTRlZmQ2MWZiZWUyOTMiLCJwdXNoX2NyZWRlbnRpYWxfc2lkIjoiQ1I3YmY1MmE4NDBlYzMwZTg3YmMzNTAyYWM1NjUyZjk1OCJ9fX0.RFJ7Eyq3DttpXoLQi-5TZFMuU0Gvdo5AUgLtToXFYhY';
                        if (jwtToken == null) {
                          debugPrint('I am here!!');
                          return;
                        }

                        if (jwtToken.isEmpty) {
                          _showInvalidJWTDialog(context);
                          return;
                        }
                        await conversationsNotifier.updateToken(
                            jwtToken: jwtToken);
                      }
                    : null,
                child: Text('Update Token'),
              ),
              ElevatedButton(
                onPressed: conversationsNotifier.isClientInitialized
                    ? () async {
                        await conversationsNotifier.shutdown();
                      }
                    : null,
                child: Text('Shutdown Client'),
              ),
              ElevatedButton(
                onPressed: conversationsNotifier.isClientInitialized
                    ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConversationsPage(
                              conversationsNotifier: conversationsNotifier,
                            ),
                          ),
                        )
                    : null,
                child: Text('See My Conversations'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showInvalidJWTDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Error: No JWT provided'),
        content: Text(
            'To create the conversations client, a JWT must be supplied on line 44 of `main.dart`'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
