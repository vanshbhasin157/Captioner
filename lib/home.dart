import 'dart:io';
import 'package:captioning/captions.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toast/toast.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  bool uploaded = false;
  String imagePath = "";
  bool loading = false;
  List<String> finalCap = [];
  List<ImageLabel> finalLabels = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: loading
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitDoubleBounce(
                    color: Color(0xFFed6666),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Genrating Captions',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  )
                ],
              ))
            : Stack(
                alignment: AlignmentDirectional.topStart,
                children: [
                  Positioned(
                    top: 130,
                    left: 30,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 100, 230, 0),
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: Image.asset('lib/assets/icon.png'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 130, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Find Suitable',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 15),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text('Caption',
                                  style: TextStyle(
                                      color: Color(0xFFff8d6e), fontSize: 15)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 3, 193, 0),
                          child: Text(
                            'for a picture',
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 180,
                    child: Container(
                      height: 350,
                      width: 350,
                      child: Image.asset(
                        'lib/assets/back.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                      top: 500,
                      left: 140,
                      child: Stack(
                        children: <Widget>[
                          CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.transparent,
                              child: imagePath.isEmpty
                                  ? Image.asset(
                                      'lib/assets/upload.png',
                                      fit: BoxFit.fill,
                                    )
                                  : Image.file(
                                      File(imagePath),
                                    )),
                          Positioned(
                              top: 83,
                              left: 83,
                              child: FloatingActionButton(
                                onPressed: () async {
                                  FilePickerResult result = await FilePicker
                                      .platform
                                      .pickFiles(type: FileType.image);
                                  if (result != null) {
                                    File file = File(result.files.first.path);
                                    String filePath = file.path;
                                    setState(() {
                                      imagePath = filePath;
                                      uploaded = true;
                                    });
                                  }
                                },
                                backgroundColor: Color(0xFFed6666),
                                child: Icon(Icons.add),
                              ))
                        ],
                      )),
                  Positioned(
                    bottom: 190,
                    left: 90,
                    child: SizedBox(
                        child: Text(
                      'Upload image and find a matching caption',
                      style: TextStyle(color: Colors.grey[600], fontSize: 15),
                    )),
                  ),
                  Positioned(
                    bottom: 170,
                    left: 180,
                    child: SizedBox(
                        child: Text(
                      'instantly :-)',
                      style: TextStyle(color: Colors.grey[600], fontSize: 15),
                    )),
                  ),
                  Positioned(
                      bottom: 80,
                      left: 65,
                      child: Container(
                        height: 50,
                        width: 300,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          onPressed: uploaded
                              ? () {
                                  detectLabels();
                                  Future.delayed(Duration(seconds: 2), () {
                                    if (finalCap.isNotEmpty) {
                                      print("length 0");
                                      setState(() {
                                        loading = false;
                                      });

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Captions(
                                                    captions: finalCap,
                                                    labels: finalLabels,
                                                  )));
                                    }else
                                    {
                                      setState(() {
                                        loading = false;
                                      });
                                      Toast.show(
                                          "Cannot find a suitable caption for this picture :-(",
                                          context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.BOTTOM);
                                    }
                                  });
                                }
                              : null,
                          child: Text(
                            'Genrate Captions',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Color(0xFFed6666),
                        ),
                      )),
                ],
              ));
  }

  Future<void> detectLabels() async {
    setState(() {
      loading = true;
    });
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFilePath(imagePath);
    final ImageLabeler labelDetector = FirebaseVision.instance
        .imageLabeler(ImageLabelerOptions(confidenceThreshold: 0.50));
    final List<ImageLabel> lables =
        await labelDetector.processImage(visionImage);
    String url = "https://api.mocki.io/v1/4c02e7b4";
    var response = await http.get(url);

    var body = json.decode(response.body);
    finalLabels = lables;
    for (int i = 0; i < 102; i++) {
      for (ImageLabel label in lables) {
        String labelText = label.text;

        if ((body['Lyrics'][i]['caption'].toString())
                .contains(labelText.toLowerCase()) ==
            true) {
          setState(() {
            finalCap.add(body['Lyrics'][i]['caption'].toString());
          });
          print('matchFound');
        }
      }
    }

    print(finalCap);
  }
}
