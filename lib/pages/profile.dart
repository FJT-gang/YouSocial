import 'package:aoc/pages/chat.dart';
import 'package:flutter/material.dart';
// Widgets
import 'package:aoc/widgets/themeWidget.dart';
// Firebase
import 'package:flutter/services.dart';
// Provider
import 'package:provider/provider.dart';
import '../providers/themeprov.dart';
import '../providers/fireprov.dart';
// Serv
import 'package:aoc/services/imgserv.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:aoc/pages/chat.dart';

// ignore: must_be_immutable
class ProfilePage extends StatefulWidget {
  late String userId;
  late bool editRights;
  ProfilePage({required this.editRights, required this.userId, Key? key})
      : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final double coverHeight = 280;
  final double profileHeight = 170;

  File? image;
  XFile? pickedImage;
  bool ran = false;

  ImgServ imgServ = ImgServ();

  // Images
  String imgTl =
      'https://www.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png';
  String imgBl =
      'https://www.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png';
  String imgR =
      'https://www.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png';
  String imgPf =
      'https://www.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png';
  String imgBanner =
      'https://www.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png';

  @override
  Widget build(BuildContext context) {
    var themeProv = Provider.of<ThemeProv>(context, listen: true);
    var fireStream = Provider.of<List>(context, listen: true);

    var userId = widget.userId;

    late String userName = '';
    String email = ' ';

    // Future getImages() async {
    //   imageProv.reset();
    //   ran = true;
    //   final imgSourceList = await imgServ.getImages();
    //   for (var e in imgSourceList) {
    //     imageProv.sImages(Image.network(e));
    //     imageProv.sImages(const SizedBox(height: 200));
    //   }

    //   setState(() {});
    // }

    void setImages() async {
      ran = true;
      imgTl = await imgServ.getImage('imgTl', userId);
      imgBl = await imgServ.getImage('imgBl', userId);
      imgR = await imgServ.getImage('imgR', userId);
      imgPf = await imgServ.getImage('imgPf', userId);
      imgBanner = await imgServ.getImage('imgBanner', userId);
      setState(() {});
    }

    ran ? '' : setImages();

    Future pickImage(String location) async {
      if (widget.editRights) {
        try {
          pickedImage =
              await ImagePicker().pickImage(source: ImageSource.gallery);
          pickedImage;
          if (pickedImage == null) {
            return;
          } else {
            await imgServ.uploadImage('users/$userId/$location', pickedImage!);
            setImages();
          }
        } on PlatformException catch (e) {
          print('Failed to get image: $e');
        }
      }
    }

    for (var e in fireStream) {
      if (userId == e.data().keys.toList().first) {
        userName = e.data()[userId]['name'];
        email = e.data()[userId]['email'];
        // setState(() {});
      }
      // print(e.data()[fireProv.userId!.uid].toString());
    }

    return SafeArea(
      child: Scaffold(
          body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            themeProv.grStart,
            themeProv.grEnd,
          ],
        )),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Column(
                    children: [
                      Stack(
                        children: [
                          FractionallySizedBox(
                            widthFactor: 1,
                            child: Container(
                              color: Colors.grey,
                              child: GestureDetector(
                                onTap: () {
                                  pickImage('imgBanner');
                                },
                                child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxHeight: 270,
                                    ),
                                    child: Image.network(
                                      imgBanner,
                                      fit: BoxFit.cover,
                                    )),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  )),
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: ThemeSelector(),
                              ),
                              const SizedBox(width: 175),
                              IconButton(
                                icon: const Icon(Icons.chat),
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Chat(
                                              otherUserId: userId,
                                              userName: userName,
                                              imgSource: imgPf,
                                            )),
                                  );
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 15, top: 140),
                                  child: GestureDetector(
                                    onTap: () {
                                      pickImage('imgPf');
                                    },
                                    child: CircleAvatar(
                                      radius: profileHeight / 2,
                                      backgroundColor: Colors.grey.shade800,
                                      backgroundImage: NetworkImage(imgPf),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Padding(
                                padding: const EdgeInsets.only(top: 260),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        userName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 45,
                                          fontWeight: FontWeight.bold,
                                          shadows: <Shadow>[
                                            // Shadow(
                                            //   offset: Offset(2, 2),
                                            //   blurRadius: 25,
                                            //   color: Colors.white,
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    IconT(
                                        text: email,
                                        icon: const Icon(
                                          Icons.email_outlined,
                                          color: Colors.white,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(38, 25, 0, 25),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: const [
                            Text(
                              'Bio:    ',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            Text(
                              'I like ... ',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(8),
                                child: GestureDetector(
                                  onTap: () {
                                    pickImage('imgTl');
                                  },
                                  child: Image.network(
                                    imgTl,
                                    height: 100,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
                                )),
                            Padding(
                                padding: const EdgeInsets.all(8),
                                child: GestureDetector(
                                  onTap: () {
                                    pickImage('imgBl');
                                  },
                                  child: Image.network(
                                    imgBl,
                                    height: 100,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ))
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8),
                            child: GestureDetector(
                                onTap: () {
                                  pickImage('imgR');
                                },
                                child: Image.network(
                                  imgR,
                                  height: 215,
                                  width: 150,
                                  fit: BoxFit.cover,
                                )))
                      ],
                    )
                  ])
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}

// ignore: must_be_immutable
class IconT extends StatelessWidget {
  late String text;
  late Icon icon;
  IconT({Key? key, required this.text, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      icon,
      const SizedBox(
        width: 5,
      ),
      Text(
        text,
        style: const TextStyle(color: Colors.white),
      )
    ]);
  }
}
