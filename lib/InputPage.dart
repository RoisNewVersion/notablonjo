import 'package:flutter/material.dart';
import 'package:notablonjo/helper/PreferenceHelper.dart';
import 'package:notablonjo/models/CalcModel.dart';
import 'package:provider/provider.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';
import 'providers/CalcProvider.dart';
import 'package:intl/intl.dart';

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  TextEditingController _namaBarang = TextEditingController();
  TextEditingController _qty = TextEditingController();
  TextEditingController _harga = TextEditingController();
  FocusNode _firstFocusField = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int total = 0;
  GlobalKey previewContainer = GlobalKey();
  final formatCurrency = NumberFormat.currency(locale: 'id_ID', name: 'IDR', symbol: 'Rp ', decimalDigits: 0);

  // save form
  void saveForm() {
    if (_formKey.currentState.validate()) {
      // collect all input field
      String namaBrg = _namaBarang.text;
      int formQty = int.tryParse(_qty.text);
      int formHarga = int.tryParse(_harga.text);
      int kaliHarga = formQty * formHarga;
      // masukan ke provider
      Provider.of<CalcProvider>(context, listen: false).addCalc(CalcModel(
        qty: formQty,
        namaBarang: namaBrg,
        hargaSatuan: formHarga,
        kaliHarga: kaliHarga,
      ));
      // set total
      Provider.of<CalcProvider>(context, listen: false).setTotal = kaliHarga;
      /* setState(() {
        total += kaliHarga;
      }); */
      // bersihkan inputan setelah selesai
      _namaBarang.clear();
      _qty.clear();
      _harga.clear();
    } else {
      // tampilkan error jika input invalid
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Tidak boleh kosong')));
    }
  }

  Future<String> populateUserInfo() async {
    return await PreferenceHelper.getString('namatoko');
  }

  @override
  void dispose() {
    _namaBarang.dispose();
    _qty.dispose();
    _harga.dispose();
    _firstFocusField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final calcProvider = context.watch<CalcProvider>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Nota Blonjo'),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            tooltip: 'Bersihkan',
            onPressed: () {
              calcProvider.clearAllCalc();
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Form(
              key: _formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nama barang'),
                        SizedBox(height: 5),
                        Material(
                          color: Color(0xFFEEF0F8),
                          elevation: 1,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: TextFormField(
                            focusNode: _firstFocusField,
                            autofocus: true,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            ),
                            controller: _namaBarang,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Qty'),
                        SizedBox(height: 5),
                        Material(
                          color: Color(0xFFEEF0F8),
                          elevation: 1,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: TextFormField(
                            maxLength: 2,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (val) {
                              if (val.isEmpty || val.startsWith(' ')) {
                                // jika dibiarkan kosong, maka anggap default value = 1
                                this._qty.text = '1';
                              }
                              // jumpt to next input field
                              FocusScope.of(context).nextFocus();
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              counterText: '',
                              contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            ),
                            controller: _qty,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Harga satuan'),
                        SizedBox(height: 5),
                        Material(
                          color: Color(0xFFEEF0F8),
                          elevation: 1,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: TextFormField(
                            validator: (val) => val.isEmpty ? 'Tidak boleh kosong' : null,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (val) {
                              saveForm();
                              if (val.isNotEmpty) {
                                FocusScope.of(context).requestFocus(_firstFocusField);
                              }
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            ),
                            controller: _harga,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Next',
                    splashRadius: 25,
                    icon: Icon(Icons.send, color: Colors.blue, size: 30),
                    onPressed: () {
                      saveForm();
                      FocusScope.of(context).requestFocus(_firstFocusField);
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: RepaintBoundary(
                key: previewContainer,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // show Nama Toko
                      calcProvider.calcModels.isEmpty
                          ? Container()
                          : Column(
                              children: [
                                Divider(),
                                FutureBuilder(
                                  future: populateUserInfo(),
                                  initialData: '...',
                                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                    return Text(
                                      snapshot.hasData ? snapshot.data : 'Nama Toko',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 24,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                      // show list hasil inputan
                      calcProvider.calcModels.isEmpty
                          ? Container()
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: calcProvider.calcModels.length,
                              itemBuilder: (BuildContext context, int index) {
                                CalcModel calcLoop = calcProvider.calcModels[index];
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                  child: Row(
                                    children: [
                                      Text('${index + 1}. '),
                                      Text(calcLoop.namaBarang),
                                      SizedBox(width: 15),
                                      Text('${calcLoop.qty}x ${calcLoop.hargaSatuan}'),
                                      Spacer(),
                                      Text('${formatCurrency.format(calcLoop.kaliHarga)}')
                                    ],
                                  ),
                                );
                              },
                            ),
                      // show Total
                      calcProvider.calcModels.isEmpty
                          ? Container()
                          : Padding(
                              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                              child: Text(
                                'Total : ${formatCurrency.format(calcProvider.total)}',
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.end,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // show Share button
          calcProvider.calcModels.isEmpty
              ? Container()
              : Container(
                  padding: EdgeInsets.only(right: 10, left: 10, bottom: 5),
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: Text(
                      'Share',
                      style: TextStyle(fontSize: 18, letterSpacing: 1),
                    ),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      Future.delayed(Duration(milliseconds: 500));
                      ShareFilesAndScreenshotWidgets().shareScreenshot(
                        previewContainer,
                        1000,
                        'Nota Blonjo',
                        'Nota_blonjo.jpg',
                        "image/jpg",
                        text: 'Ini Nota',
                      );
                    },
                  ),
                )
        ],
      ),
    );
  }
}
