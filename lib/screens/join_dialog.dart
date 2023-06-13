import 'package:flutter/material.dart';
import 'package:record_audio/screens/recording_page.dart';

class JoinDialogBox extends StatefulWidget {
  const JoinDialogBox({
    super.key,
    required this.streamId,
    required this.generatedStreamID,
  });

  final String streamId;
  final bool generatedStreamID;

  @override
  State<JoinDialogBox> createState() => _JoinDialogBoxState();
}

class _JoinDialogBoxState extends State<JoinDialogBox> {
  final TextEditingController _streamIdController = TextEditingController();

  bool isAlertDialogVisible = true;

  void setAlertDialog(bool status) {
    setState(() {
      isAlertDialogVisible = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isAlertDialogVisible) {
          setAlertDialog(false);
          Navigator.pop(context);
        }
      },
      child: ScaffoldMessenger(
        child: Builder(builder: (context) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: AlertDialog(
              // title: Text('Join Stream'),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              elevation: 5,
              content: TextField(
                controller: _streamIdController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Stream ID',
                ),
              ),
              actions: [
                OutlinedButton(
                  onPressed: () {
                    if (_streamIdController.text.isEmpty) {
                      if (widget.generatedStreamID) {
                        setState(() {
                          _streamIdController.text = widget.streamId;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Only works for generated stream IDs'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Paste'),
                ),
                OutlinedButton(
                  // Should navigate to RecordingPage()
                  onPressed: _streamIdController.text.isNotEmpty
                      ? () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RecordingPage()),
                          );
                        }
                      : null,
                  child: const Text('Join'),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
