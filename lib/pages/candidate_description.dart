import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'candidates.dart';

class CandidateDescriptionPage extends StatefulWidget {
  final Candidate candidate;

  const CandidateDescriptionPage({required this.candidate});

  @override
  _CandidateDescriptionPageState createState() => _CandidateDescriptionPageState();
}

class _CandidateDescriptionPageState extends State<CandidateDescriptionPage> {
  @override
  Widget build(BuildContext context) {
    Uint8List imageBytes = base64Decode(widget.candidate.imageBase64);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('${widget.candidate.name} ${widget.candidate.surname}'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.grey[300],
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              child: Image.memory(
                imageBytes,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Text(
              '${widget.candidate.name} ${widget.candidate.surname}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10),
            Text(
              widget.candidate.bio,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Parti : ${widget.candidate.party}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
