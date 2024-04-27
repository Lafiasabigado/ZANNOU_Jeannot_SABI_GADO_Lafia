import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'candidates.dart';

class AddElectPage extends StatefulWidget {
  final Function(Candidate) addCandidate;

  const AddElectPage({required this.addCandidate, super.key});

  @override
  _AddElectPageState createState() => _AddElectPageState();
}

class _AddElectPageState extends State<AddElectPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _surname = '';
  String _party = '';
  String _bio = '';
  DateTime _dateOfBirth = DateTime.now();
  File? _image;
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      List<int> imageBytes = await _image!.readAsBytesSync();
      String imageBase64 = base64Encode(imageBytes);

      final candidate = Candidate(
        id: 0, // L'ID sera attribué par le serveur
        name: _name,
        surname: _surname,
        party: _party,
        bio: _bio,
        imageBase64: imageBase64, // L'image en base64 sera stockée dans l'objet Candidate
      );

      // Appeler la fonction addCandidate passée en paramètre
      widget.addCandidate(candidate);

      // Fermer la page actuelle
      Navigator.pop(context);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _dateOfBirth,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null && picked != _dateOfBirth) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Création de Candidat'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Candidate image
                GestureDetector(
                  onTap: () async {
                    try {
                      await _pickImage(ImageSource.gallery);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to pick image: $e')),
                      );
                    }
                  },
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: _image != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.file(_image!, fit: BoxFit.cover),
                    )
                        : const Center(child: Icon(Icons.camera)),
                  ),
                ),
                const SizedBox(height: 12),
                // Name
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nom',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(17)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Champ obligatoire';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                ),
                const SizedBox(height: 12),
                // Surname
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Prénom(s)',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(17)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Champ obligatoire';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _surname = value!;
                  },
                ),
                const SizedBox(height: 12),
                // Party
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Parti politique',
                    prefixIcon: Icon(Icons.flag),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(17)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Champ obligatoire';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _party = value!;
                  },
                ),
                const SizedBox(height: 12),
                // Bio
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Icons.description_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(17)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Champ obligatoire';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _bio = value!;
                  },
                ),
                const SizedBox(height: 16),
                // Date of Birth
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Date de naissance',
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () {
                        _selectDate(context);
                      },
                    ),
                  ),
                  controller: TextEditingController(
                      text: _formatDate(_dateOfBirth)),
                  onTap: () {
                    _selectDate(context);
                  },
                  readOnly: true,
                ),
                const SizedBox(height: 32),
                // Add button
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('SAUVEGARDER',
                      style: TextStyle(color: Colors.white),),
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }
}
