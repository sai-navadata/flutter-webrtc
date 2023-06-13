import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:record_audio/screens/join_dialog.dart';
import 'package:record_audio/utils/snackbar.dart';
import 'package:rich_clipboard/rich_clipboard.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.title,
  });

  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String streamId = 'Generate Unique ID';
  bool generatedStreamID = false;

  Future<void> enterStreamID({required String streamId}) => showDialog(
        context: context,
        builder: (context) => JoinDialogBox(
          streamId: streamId,
          generatedStreamID: generatedStreamID,
        ),
      );

  Future<void> fetchStreamId() async {
    try {
      final response = await Dio().post('http://10.0.2.2:8000/stream');
      final data = response.data as Map<String, dynamic>;

      setState(() {
        streamId = data['stream_id'];
        generatedStreamID = true;
      });

      const SnackBarUtil();

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Copied stream ID to clipboard'),
      //     duration: Duration(seconds: 1),
      //   ),
      // );

      await RichClipboard.setData(RichClipboardData(text: streamId));
    } catch (e) {
      setState(() {
        streamId = 'Error occurred';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Image.asset(
              'assets/logo.png',
              fit: BoxFit.contain,
              height: 40,
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: Column(
          children: [
            OutlinedButton(
              style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(const Size(250, 45))),
              onPressed: fetchStreamId,
              child: Text(streamId),
            ),
            OutlinedButton(
              onPressed: () {
                enterStreamID(streamId: streamId);
              },
              child: const Text('Join Stream'),
            )
          ],
        ),
      ),
    );
  }
}
