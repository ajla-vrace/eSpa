import 'package:espa_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child:Center(
         child:Text("Ovo je home page"),
      ),
     title: "Home",
    );
  }
}