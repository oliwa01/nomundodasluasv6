import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:nomundodasluas_v6/classes/rowAppBar.dart';
import 'package:nomundodasluas_v6/pages/principal.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home.dart';
import 'luas.dart';

class SlideFotos extends StatefulWidget {
  final String email;
  SlideFotos(this.email);

  @override
  _SlideFotosState createState() => _SlideFotosState();
}

class _SlideFotosState extends State<SlideFotos> {
  _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      (index == 0)
          ? Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Principal(widget.email);
            }))
          : (index == 1)
              ? Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Luas(widget.email);
                }))
              : (index == 2)
                  ? _launchInBrowser("https://loja.nomundodasluas.com.br/")
                  : Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                      return Home();
                    }));
    });
  }

  @override
  Widget build(BuildContext context) {
    final widthlua = MediaQuery.of(context).size.width;
    final heightlua = MediaQuery.of(context).size.height;
    bool portrait = (heightlua > widthlua);
    double fontAdj = portrait
        ? sqrt(heightlua) / (heightlua / widthlua)
        : sqrt(heightlua) / (widthlua / heightlua);

    double horizonte = ((widthlua > 1400)
        ? widthlua * 0.25
        : (widthlua > 1200)
            ? widthlua * 0.20
            : (widthlua > 1000)
                ? widthlua * 0.15
                : (widthlua > 800)
                    ? widthlua * 0.10
                    : (widthlua > 600)
                        ? widthlua * 0.05
                        : 0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: RowAppBarr(' ', widthlua, heightlua, widget.email, 'luas'),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Luas(widget.email);
              }));
            }),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/fundodatas.png"),
                fit: BoxFit.cover)),
        child: Container(
            height: heightlua,
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: horizonte),
            child: CarouselSlider(
              options: CarouselOptions(),
              items: imgList
                  .map((item) => Container(
                        child: Center(
                            child: Image.asset(item, fit: BoxFit.fitWidth)),
                      ))
                  .toList(),
            )),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, color: Colors.white),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera, color: Colors.white),
            label: 'Luas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            label: 'Loja',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}

final List<String> imgList = [
  'assets/images/amb-01.jpg',
  'assets/images/amb-02.jpg',
  'assets/images/amb-03.jpg',
  'assets/images/amb-04.jpg',
  'assets/images/amb-05.jpg',
  'assets/images/amb-06.jpg',
  'assets/images/amb-07.jpg',
  'assets/images/amb-08.jpg',
  'assets/images/amb-09.jpg',
  'assets/images/amb-10.jpg',
  'assets/images/amb-11.jpg',
  'assets/images/amb-12.jpg',
  'assets/images/amb-13.jpg',
  'assets/images/amb-14.jpg',
  'assets/images/amb-15.jpg',
  'assets/images/amb-16.jpg',
  'assets/images/amb-17.jpg',
  'assets/images/amb-18.jpg',
  'assets/images/amb-19.jpg',
  'assets/images/amb-20.jpg',
  'assets/images/amb-21.jpg',
  'assets/images/amb-22.jpg',
  'assets/images/amb-23.jpg',
  'assets/images/amb-24.jpg',
  'assets/images/amb-25.jpg',
  'assets/images/amb-26.jpg',
  'assets/images/amb-27.jpg',
  'assets/images/amb-28.jpg',
  'assets/images/amb-29.jpg',
  'assets/images/amb-30.jpg',
  'assets/images/amb-31.jpg',
  'assets/images/amb-32.jpg',
  'assets/images/amb-33.jpg',
  'assets/images/amb-34.jpg',
  'assets/images/amb-35.jpg',
  'assets/images/amb-36.jpg',
  'assets/images/amb-37.jpg',
  'assets/images/amb-38.jpg',
  'assets/images/amb-39.jpg',
  'assets/images/amb-40.jpg',
  'assets/images/amb-41.jpg'
];
final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    Image.network(item, fit: BoxFit.cover, width: 1000.0),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Text(
                          'No. ${imgList.indexOf(item)} image',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ))
    .toList();
