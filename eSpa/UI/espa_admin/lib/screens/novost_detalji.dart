// ignore_for_file: prefer_const_constructors

import 'package:espa_admin/models/novost.dart';
import 'package:espa_admin/providers/novost_provider.dart';
import 'package:espa_admin/screens/novosti.dart';
import 'package:espa_admin/widgets/master_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';


// ignore: must_be_immutable
class NovostDetaljiPage extends StatefulWidget {
  Novost? novost;
  NovostDetaljiPage({Key? key, this.novost}) : super(key: key);

  @override
  State<NovostDetaljiPage> createState() => _NovostDetaljiPageState();
}

class _NovostDetaljiPageState extends State<NovostDetaljiPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};

  late NovostProvider _novostProvider;

  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'naslov': widget.novost?.naslov,
      'sadrzaj': widget.novost?.sadrzaj?.toString(),
    };

    _novostProvider = context.read<NovostProvider>();

    initForm();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    // if (widget.product != null) {
    //   setState(() {
    //     _formKey.currentState?.patchValue({'sifra': widget.product?.sifra});
    //   });
    // }
  }

  Future initForm() async {
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      // ignore: sort_child_properties_last
      child: Column(
        children: [
          isLoading ? Container() : _buildForm(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: ElevatedButton(
                    onPressed: () async {
                      _formKey.currentState?.saveAndValidate();

                      var currentValues =
                          Map.from(_formKey.currentState!.value);

                      // Provera da li su vrednosti promenjene
                      bool isChanged = false;
                      _initialValue.forEach((key, value) {
                        if (currentValues[key] != value) {
                          isChanged = true;
                        }
                      });

                      if (!isChanged) {
                        // Ako nema promena, vrati se na prethodnu stranicu bez ažuriranja
                        Navigator.pop(context, false);
                        return;
                      }

                      var request = new Map.from(_formKey.currentState!.value);

                      try {
                        if (widget.novost == null) {
                          await _novostProvider.insert(request);
                        } else {
                          await _novostProvider.update(
                              widget.novost!.id!, request);
                        }
                        //Navigator.pop(context);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NovostPage(),
                          ),
                        );
                      } on Exception catch (e) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: Text("Error"),
                                  content: Text(e.toString()),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("OK"))
                                  ],
                                ));
                      }
                    },
                    child: Text("Sačuvaj")),
              )
            ],
          )
        ],
      ),
      title: this.widget.novost?.naslov ?? "Novost details",
    );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column(children: [
        Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: FormBuilderTextField(
                decoration: InputDecoration(labelText: "Naslov"),
                name: "naslov",
              ),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: FormBuilderTextField(
                decoration: InputDecoration(labelText: "Sadrzaj"),
                name: "sadrzaj",
              ),
            ),
          ],
        ),
      ]),
    );
  }

  //File? _image;
  //String? _base64Image;

  /*Future getImage()  async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if(result != null && result.files.single.path != null) {
      _image = File(result.files.single.path!);
      _base64Image = base64Encode(_image!.readAsBytesSync());
    }

  }*/
}
