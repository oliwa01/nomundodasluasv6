import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:nomundodasluas_v6/classes/columnDateTime.dart';
import 'package:nomundodasluas_v6/classes/columnHemisferio.dart';
import 'package:nomundodasluas_v6/classes/reusableContainerDatetime.dart';
import 'package:nomundodasluas_v6/classes/reusablecontainerlua.dart';
import 'package:nomundodasluas_v6/classes/rowAppBar.dart';
import 'package:nomundodasluas_v6/constantes/constantes.dart';
import 'package:nomundodasluas_v6/pages/pageFoto1.dart';
import 'package:nomundodasluas_v6/pages/principal.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home.dart';
import 'luas.dart';

enum Hemisferio { norte, sul, nulo }

class Lua1 extends StatefulWidget {
  Lua1(this.email);
  String email;
  @override
  _Lua1State createState() => _Lua1State();
}

class _Lua1State extends State<Lua1> {
  final nameTextController = TextEditingController();
  TextEditingController _controllerNome = TextEditingController(text: "");
  Hemisferio selectedHemisferio = Hemisferio.nulo;
  String _selectedDateNasc = "DD/MM/AAAA";
  String _selectedTimeNasc = "HH:MM";
  String _selectedNome = '';
  String _selectedHemisferio = '';

  bool selectedData = false;
  bool selectedTime = false;

  String _selecteDateNasc = "DD/MM/AAAA";
  String _selecteTimeNasc = "HH:MM";

  String datanasc = '';
  String horanasc = '';
  String nome = '';
  String hemisferio = '';
  //
  void dataPicketNasc() {
    var yearnow = DateTime.now();
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1900, 3, 5),
        maxTime: DateTime(yearnow.year, 12, 31),
        theme: DatePickerTheme(
            headerColor: Colors.deepOrange,
            backgroundColor: Colors.black38,
            itemStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
            doneStyle: TextStyle(color: Colors.white, fontSize: 25)),
        onChanged: (date) {}, onConfirm: (date) {
      selectedData = true;
      var decDate = date.toString();
      setState(() {
        _selecteDateNasc =
            ('${decDate.substring(8, 10)}/${decDate.substring(5, 7)}/${decDate.substring(0, 4)}');
        datanasc =
            ('${decDate.substring(0, 4)}${decDate.substring(5, 7)}${decDate.substring(8, 10)}');
      });
    }, currentTime: DateTime.now(), locale: LocaleType.pt);
  }

  void timePicketNasc() {
    DatePicker.showTime12hPicker(context,
        showTitleActions: true,
        theme: DatePickerTheme(
            headerColor: Colors.deepOrange,
            backgroundColor: Colors.black38,
            itemStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
            doneStyle: TextStyle(color: Colors.white, fontSize: 20)),
        onConfirm: (date) {
      selectedTime = true;
      var decDate = date.toString();
      setState(() {
        _selecteTimeNasc =
            ('${decDate.substring(11, 13)}:${decDate.substring(14, 16)}');
        horanasc = ('${decDate.substring(11, 13)}${decDate.substring(14, 16)}');
      });
    }, currentTime: DateTime.now(), locale: LocaleType.pt);
  }

  @override
  Widget build(BuildContext context) {
    final widthlua = MediaQuery.of(context).size.width;
    final heightlua = MediaQuery.of(context).size.height;
    double heightDateTime = heightlua * 0.45;
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
    //
    bool portrait = (heightlua > widthlua);
    double fontAdj = portrait
        ? sqrt(heightlua) / (heightlua / widthlua)
        : sqrt(heightlua) / (widthlua / heightlua);

    //
    DateTime now = DateTime.now();

    String _formattedDate2 = DateFormat('MMddkkmmss').format(now);

    String _codVenda = _formattedDate2;
//    DateTimeHemisferio dateTimeHemisferio1 = DateTimeHemisferio();
    //

    double _distanciadb1 = 0.0;
    int _luadiadb1 = 0;
    String _proximoDb = '';
    String _signosDb = '';
    String _timedb1 = '';
    //
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

    nomeDigitado(value) {
      setState(() {
        nome = value;
      });
    }

    //
    Future _gravaDados() async {
      CollectionReference users = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(widget.email)
          .collection('fotos');
      //
      CollectionReference luas =
          FirebaseFirestore.instance.collection('DiarioLuas');
      //
      luas.doc(datanasc).get().then((DocumentSnapshot docSn) {
        _distanciadb1 = docSn["Distanciadb"];
        _luadiadb1 = docSn["LuadiaDb"];
        _proximoDb = docSn["ProximoDb"];
        _signosDb = docSn["SignosDb"];
        _timedb1 = docSn["TimeDb"];

        users.doc(_codVenda).set({
          'codVenda': _codVenda,
          'email': widget.email,
          'dataPicket1': datanasc,
          'distanciadb1': docSn["Distanciadb"],
          'hemisferio': hemisferio,
          'luadiadb1': docSn["LuadiaDb"],
          'nome1': nome,
          'numberPicture': 1,
          'proximodb': docSn["ProximoDb"],
          'signo1': docSn["SignosDb"],
          'timedb1': docSn["TimeDb"],
          'timenasc1': _selectedTimeNasc == 'HH:MM' ? '9999' : horanasc
        });

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return PageFoto1(
              origem: 'luas',
              email: widget.email,
              codVenda: _codVenda,
              numberPicture: 1,
              dataPicket1: datanasc,
              nome1: nome,
              distanciadb1: _distanciadb1,
              luadiadb1: _luadiadb1,
              proximodb1: _proximoDb,
              signo1: _signosDb,
              timedb1: _timedb1,
              timenasc1: _selectedTimeNasc == 'HH:MM' ? '9999' : horanasc,
              hemisferio: hemisferio);
        }));
      });
    }

    //
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: RowAppBarr(' ', widthlua, heightlua, widget.email, 'luas'),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return Luas(widget.email);
                  }),
                );
              })),
      body: Container(
        width: double.infinity,
        height: heightlua,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/fundo_diario.png"),
                fit: BoxFit.cover)),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_box_outlined,
                      size: 50, color: Colors.white),
                  SizedBox(width: 20),
                  Text(
                    'FOTO 1',
                    style: kTitle2TextStyle,
                  )
                ],
              ),
              SizedBox(height: 30),
              Container(
                height: heightDateTime,
                margin:
                    EdgeInsets.symmetric(vertical: 0, horizontal: horizonte),
                decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(20.0)),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              Expanded(
                                  child: ReusableContainerLua(
                                      (selectedHemisferio == Hemisferio.norte)
                                          ? kcolorExpanded
                                          : kinactiveColorExpanded,
                                      ColumnHemisferio('assets/images/hn.png',
                                          'HEMISFÉRIO NORTE'), () {
                                setState(() =>
                                    selectedHemisferio = Hemisferio.norte);
                                hemisferio = 'norte';
                              })),
                              Expanded(
                                  child: ReusableContainerLua(
                                      (selectedHemisferio == Hemisferio.sul)
                                          ? kcolorExpanded
                                          : kinactiveColorExpanded,
                                      ColumnHemisferio('assets/images/hs.png',
                                          'HEMISFÉRIO SUL'), () {
                                setState(
                                    () => selectedHemisferio = Hemisferio.sul);
                                hemisferio = 'sul';
                              })),
                            ],
                          )),
                      Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  selectedHemisferio == Hemisferio.nulo
                                      ? 'Selecione o hemisfério do local de nascimento.'
                                      : '',
                                  style: TextStyle(
                                      fontSize: fontAdj * 1.2,
                                      color: Colors.deepOrange))
                            ],
                          )),
                      Expanded(
                          flex: 3,
                          child: Container(
                            alignment: Alignment.center,
                            child: TextField(
                                controller: _controllerNome,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                    color: Colors.black, fontSize: fontAdj),
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(32, 16, 32, 16),
                                    hintText: "Nome",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(32))),
                                onChanged: (value) => {nomeDigitado(value)}),
                          )),
                      Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              Expanded(
                                  child: ReusableContainerDatetime(
                                      selectedData
                                          ? kcolorDataSelect
                                          : kcolorDataUnSelect,
                                      ColumnDateTime(
                                          'Data Nascimento.', _selecteDateNasc),
                                      dataPicketNasc)),
                              Expanded(
                                  child: ReusableContainerLua(
                                      selectedTime
                                          ? kcolorDataSelect
                                          : kcolorDataUnSelect,
                                      ColumnDateTime(
                                          'Hora do Nascimento(Opcional).',
                                          _selecteTimeNasc),
                                      timePicketNasc)),
                            ],
                          )),
                      // Expanded(flex: 4, child: Container()),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              TextButton(
                  onPressed: () {
                    print("data nascimento =  $_selectedDateNasc");
                    print("hora nascimento = $_selectedTimeNasc");
                    print("nome = $_selectedNome");
                    print("hemisferio = $_selectedHemisferio");

                    print("data nascimento2 =  ${datanasc}");
                    print("hora nascimento2 = ${horanasc}");
                    print("nome2 = ${nome}");
                    print("hemisferio2 = ${hemisferio}");

                    if (hemisferio.isEmpty) {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Text('SELECIONAR'),
                          content: const Text(
                              'Selecionar Hemisfério do local de nascimento'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    } else if (nome.isEmpty) {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Text('Nome'),
                          content: const Text(
                              'Preenchimento do campo NOME é obrigatorio. '),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    } else if (datanasc == "DD/MM/AAAA") {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Text('DATA de NASCIMENTO'),
                          content: const Text('Selecione DATA de NASCIMENTO. '),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      _gravaDados();
                    }
                  },
                  child: Container(
                    width: 220,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.camera, color: Colors.white, size: 40),
                        Text('GERAR FOTO', style: ktextButtonImage)
                      ],
                    ),
                  )),
            ],
          ),
        ),
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
