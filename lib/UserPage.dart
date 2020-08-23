import 'package:flutter/material.dart';
import 'package:notablonjo/helper/PreferenceHelper.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  TextEditingController _namaToko = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void saveForm() async {
    if (_formKey.currentState.validate()) {
      // collect input field
      String namaToko = _namaToko.text;
      await PreferenceHelper.setString('namatoko', namaToko);
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Berhasil simpan nama.', textAlign: TextAlign.center),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  void populateUserInfo() async {
    _namaToko.text = await PreferenceHelper.getString('namatoko');
  }

  @override
  void initState() {
    super.initState();
    populateUserInfo();
  }

  @override
  void dispose() {
    _namaToko.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Info'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(20)),
              height: 290,
              width: double.infinity,
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Text('NB'),
                  ),
                  SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                            text:
                                'Masukan nama toko atau usaha anda dikolom bawah ini. Nanti akan tampil pada header nota. Jika dikosongkan maka akan terisi default.'),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Material(
                      color: Color(0xFFEEF0F8),
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: TextFormField(
                        textInputAction: TextInputAction.done,
                        validator: (val) => val.isEmpty ? 'Tidak boleh kosong' : null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          hintText: 'Masukan nama toko / usaha',
                        ),
                        controller: _namaToko,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  RaisedButton(
                    color: Colors.purple.shade400,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    onPressed: saveForm,
                    child: Text(
                      'Simpan',
                      style: TextStyle(letterSpacing: 1),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
