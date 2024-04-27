import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'candidates.dart';
import 'addelected.dart';
import 'dart:convert';

class ShowElectPage extends StatefulWidget {
  const ShowElectPage({super.key});

  @override
  _ShowElectPageState createState() => _ShowElectPageState();
}

class _ShowElectPageState extends State<ShowElectPage> {
  int _selectedIndex = 0;
  List<Candidate> _candidates = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addCandidate(Candidate candidate) {
    setState(() {
      _candidates.add(candidate);
      _isLoading = true;
    });
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Elections'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
        color: Colors.grey[300],
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _candidates.length,
                itemBuilder: (context, index) {
                  final candidate = _candidates[index];
                  Uint8List imageBytes = base64Decode(candidate.imageBase64);
                  return Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(5),
                    color: Colors.white,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: MemoryImage(imageBytes),
                      ),
                      title: Text('${candidate.name} ${candidate.surname}'),
                      subtitle: Text(candidate.bio),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddElectPage(
                addCandidate: (candidate) => _addCandidate(candidate),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Candidats',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.how_to_vote),
            label: 'Vote',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Paramètres',
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
