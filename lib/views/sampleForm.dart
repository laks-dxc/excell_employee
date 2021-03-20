import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:smart_select/smart_select.dart';

class SampleForm extends StatefulWidget {
  SampleForm({this.app});
  final FirebaseApp app;

  @override
  _SampleFormState createState() => _SampleFormState(app: app);
}

class _SampleFormState extends State<SampleForm> {
  _SampleFormState({this.app});
  final FirebaseApp app;

  DatabaseReference formRef;
  List<dynamic> formFields = new List.empty();

  @override
  void initState() {
    super.initState();
    // Demonstrates configuring to the database using a file
    formRef = FirebaseDatabase.instance.reference().child('formMeta');
    // Demonstrates configuring the database directly
    final FirebaseDatabase database = FirebaseDatabase(app: widget.app);

    formRef.once().then((DataSnapshot snapshot) {
      setState(() {
        formFields = snapshot.value;
        print(formFields.length.toString());
      });
      // print('Connected to second database and read ${}');
    });

    // database.reference().child('counter').once().then((DataSnapshot snapshot) {
    //   print('Connected to second database and read ${snapshot.value}');
    // });

    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    formRef.keepSynced(true);
  }

  void updateForm() {
    formRef.once().then((DataSnapshot snapshot) {
      setState(() {
        formFields = snapshot.value;
        print(formFields.length.toString());
      });
      // print('Connected to second database and read ${}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sample Form"),
        actions: [
          IconButton(
              icon: Icon(
                Icons.refresh,
              ),
              onPressed: updateForm),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: formFields.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: formFields[index]["type"] == 'tb'
                        ? TextFormField(
                            decoration: new InputDecoration(
                              labelText: formFields[index]["hint"] ?? "",
                              fillColor: Colors.green,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(15.0),
                                borderSide: new BorderSide(),
                              ),
                            ),
                            validator: (val) {
                              if (val.length == 0) {
                                return "Email cannot be empty";
                              } else {
                                return null;
                              }
                            },
                            keyboardType: TextInputType.emailAddress,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          )
                        : Container(
                            // margin: const EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade500,
                                ),
                                borderRadius: BorderRadius.circular(15.0)),
                            child: SmartSelect<String>.single(
                              title: formFields[index]["hint"] ?? "",
                              value: null,
                              // selectedValue: _os,
                              choiceItems: [
                                S2Choice<String>(
                                    value: 'and', title: 'Android'),
                                S2Choice<String>(value: 'ios', title: 'IOS'),
                                S2Choice<String>(
                                    value: 'mac', title: 'Macintos'),
                                S2Choice<String>(value: 'tux', title: 'Linux'),
                                S2Choice<String>(
                                    value: 'win', title: 'Windows'),
                              ],
                              onChange: (selected) =>
                                  setState(() => print(selected.value)),
                              modalType: S2ModalType.bottomSheet,
                              tileBuilder: (context, state) {
                                return S2Tile.fromState(
                                  state,
                                  isTwoLine: false,
                                  // leading: const CircleAvatar(
                                  //   backgroundImage: NetworkImage(
                                  //     'https://source.unsplash.com/xsGxhtAsfSA/100x100',
                                  //   ),
                                  // ),
                                );
                              },
                            ),
                          ),
                  );
                },
              ),
            ),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
