import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyD0oBokSf_n1MWXzOIP2KS6ndq7Ue2EmMc",
      appId: "1:39537905776:android:2b6f2cea23aec1b2f7a4b5",
      messagingSenderId: "39537905776",
      projectId: "flutter-mobile-applicati-473c5",
    ),
  )
      : await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,

      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _pickedImage;
  VideoPlayerController? _videoController;
  final TextEditingController _textController = TextEditingController();
  FlutterSoundPlayer? _audioPlayer;
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecording = false;
  String _currentRecording = '';
  Color _micIconColor = Colors.black;
  List<String> files = [];
  List<Map<String, dynamic>> firebaseDataList = [];

  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  _MyHomePageState() {
    _audioPlayer = FlutterSoundPlayer();
    _audioRecorder = FlutterSoundRecorder();
  }

  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
        _videoController = null;
      });
    }
  }

  Future<void> _pickVideo() async {
    final pickedFile =
    await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _videoController = VideoPlayerController.file(File(pickedFile.path))
          ..initialize().then((_) {
            _pickedImage = null;
            setState(() {});
          });
      });
    }
  }

  Future<void> _startRecording() async {
    try {
      await _audioRecorder!.startRecorder(
        toFile: 'path/to/your/audio/file.aac',
        codec: Codec.aacMP4,
      );

      setState(() {
        _isRecording = true;
        _micIconColor = Colors.blue;
      });
    } catch (e) {
      print("Error starting recording: $e");
    }
  }

  Future<void> _stopRecording() async {
    try {
      String? path = await _audioRecorder!.stopRecorder();
      if (path != null) {
        setState(() {
          _isRecording = false;
          _currentRecording = path;
          _micIconColor = Colors.black;
        });
      }
    } catch (e) {
      print("Error stopping recording: $e");
    }
  }

  void _createNewFile() {
    showDialog(
      context: context,
      builder: (context) {
        String content = '';

        return AlertDialog(
          title: const Text('New File'),
          content: TextField(
            onChanged: (value) {
              content = value;
            },
            maxLines: null,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _saveFile(content);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _saveFile(String content) {
    String fileName = 'File_${DateTime.now().millisecondsSinceEpoch}.txt';
    files.add(fileName);
    // Implement file saving logic and update the files list
    // For example, you can use a file name with a timestamp
    // Save content to the file - Implement this part based on your requirements
  }

  void _openAndEditFile(String fileName) {
    showDialog(
      context: context,
      builder: (context) {
        String content = ''; // Load the content of the file here

        return AlertDialog(
          title: Text(fileName),
          content: TextField(
            controller: TextEditingController(text: content),
            onChanged: (value) {
              content = value;
            },
            maxLines: null,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _saveFile(content);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _postToFirebase() async {
    // Check if at least one type of data is selected
    if (_pickedImage == null &&
        _videoController == null &&
        _textController.text.isEmpty &&
        _currentRecording.isEmpty) {
      // Show a message to add data first
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one type of data.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Upload selected data to Firebase Realtime Database
    Map<String, dynamic> postData = {
      'image': _pickedImage?.path ?? '',
      'video': _videoController?.dataSource ?? '',
      'text': _textController.text,
      'audio': _currentRecording,
    };

    try {
      await _databaseReference.push().set(postData);

      // Clear selected data from the UI
      setState(() {
        _pickedImage = null;
        _videoController = null;
        _textController.clear();
        _currentRecording = '';
        files.clear();
      });

      // Show success message using a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data saved successfully.'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      // Handle error if data couldn't be saved
      print('Error saving data: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save data.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _fetchDataFromFirebase() {
    _databaseReference.once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        setState(() {
          firebaseDataList.clear();
          if (snapshot.value is Map) {
            (snapshot.value as Map).forEach((key, value) {
              firebaseDataList.add(Map<String, dynamic>.from(value));
            });

            // Print data to the console for debugging
            print('Firebase Data: $firebaseDataList');
          }
        });

        // Show a message or navigate to the data view
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Firebase data retrieved successfully.'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // Show a message if there is no data
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No data found in Firebase.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }).catchError((error) {
      print('Error fetching data from Firebase: $error');
      // Handle error if fetching data fails
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to fetch data from Firebase.'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  void _viewFirebaseDataDetails(int index) {
    // Implement how you want to view the details for the selected data
    showDialog(
      context: context,
      builder: (context) {
        // Use firebaseDataList[index] to display details
        // ...
        return AlertDialog(
          title: const Text('Data Details'),
          content: Text('Details for data at index $index'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    double containerSize = MediaQuery.of(context).size.width * 0.4;
    double fontSize = MediaQuery.of(context).size.width * 0.04;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Traiding Admin pannel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_download),
            onPressed: _fetchDataFromFirebase,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                width: containerSize,
                height: containerSize,
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: _pickedImage != null
                    ? Image.file(_pickedImage!, fit: BoxFit.cover)
                    : IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: _pickImage,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: containerSize,
                height: containerSize,
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: _videoController != null
                    ? AspectRatio(
                  aspectRatio: _videoController!.value.aspectRatio,
                  child: VideoPlayer(_videoController!),
                )
                    : IconButton(
                  icon: const Icon(Icons.videocam),
                  onPressed: _pickVideo,
                ),
              ),

              // List of Firebase Data
              const SizedBox(height: 20),
              if (firebaseDataList.isNotEmpty)
                Column(
                  children: firebaseDataList.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> data = entry.value;
                    return ListTile(
                      title: Text('Data at Index $index'),
                      onTap: () {
                        _viewFirebaseDataDetails(index);
                      },
                    );
                  }).toList(),
                ),
              const SizedBox(height: 20),
              if (_currentRecording.isNotEmpty)
                Text('Recorded Voice: $_currentRecording'),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: _postToFirebase,
            child: const Text('Post'),
          ),
        ),
      ),
    );
  }
}
