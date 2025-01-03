import 'package:espa_admin/providers/usluga_provider.dart';
import 'package:espa_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

late UslugaProvider _uslugaProvider;

@override
void didChangeDependencies() {
// TODO: implement didChangeDependencies

super.didChangeDependencies();
_uslugaProvider = context.read<UslugaProvider>();
}

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Home",
      child: Container(
        child:Column(children: [
          Text("Ovo je home page"),
         ElevatedButton( onPressed: () async {
        print("login proceed na home stranici");
        // Navigator.of (context).pop();
        var data = await _uslugaProvider.get(); 
        print("data: $data");
        },
        child: Text("Login"))

        ],)
         
      ),
    );
  }
}