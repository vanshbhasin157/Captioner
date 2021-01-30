import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

class Captions extends StatelessWidget {
  const Captions({Key key, @required this.captions, @required this.labels})
      : super(key: key);
  final List<String> captions;
  final List<ImageLabel> labels;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(20,40,20,0),
                height: 40,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color(0xFFed6666)),
                      child: Center(child: Text(labels[0].text,style: TextStyle(color: Colors.white),)),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Container(
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color(0xFFed6666)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(child: Text(labels[1].text,style: TextStyle(color: Colors.white))),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Container(
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color(0xFFed6666)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(child: Text(labels[2].text,style: TextStyle(color: Colors.white))),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Container(
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color(0xFFed6666)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(child: Text(labels[3].text,style: TextStyle(color: Colors.white))),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    
                  ],
                ),
              ),
              Expanded(
                child: captions.isEmpty
                    ? Text(
                        'No Captions',
                        style: TextStyle(color: Colors.black),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: captions.length,
                        itemBuilder: (context, i) {
                          return Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                              ),
                              child: ListTile(
                                title: Text(captions[i]),
                                trailing: IconButton(onPressed: (){
                                  Clipboard.setData(ClipboardData(text: captions[i]));
                                  Toast.show("Copied to clipboard", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);

                                },
                                icon: Icon(Icons.copy_rounded,color: Color(0xFFed6666),),
                                )
                              ));
                        },
                      ),
              )
            ],
          ),
        ));
  }
}
