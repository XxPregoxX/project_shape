import 'package:flutter/material.dart';
import 'package:project_shape/GeneralWidgets.dart';
import 'package:project_shape/functions.dart';

class day extends StatefulWidget {
  final Map Day;
  const day({super.key, required this.Day});

  @override
  State<day> createState() => _dayState();
}

class _dayState extends State<day> {
  late Map Day;

  @override
  void initState() {
    super.initState();
    Day = (this.widget.Day);
  }

  Future<List<Widget>> buildCards() async{
    List<Widget> cards = [];
    for (var i in Day['consumed']){
      await consumed_card(i).then((value) => cards.add(value));
    }
    return cards;
  }

  add_consumed() async {
    final result = await AddConsumed(context, this.widget.Day['day_id']);
    Day = await Days().getById(this.widget.Day['day_id']);
    if (result == true) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          width: screenWidth * 0.9,
          child: Column(
            children: [
              day_grid(Day),
              SizedBox(height: 20),
              FutureBuilder(future: buildCards(), builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Erro ao carregar card: ${snapshot.error}');
                } else {
                  return Column(
                    children: snapshot.data!,
                  );
                }
              }),             
              ElevatedButton(onPressed: () {
                add_consumed();
              }, child: Text('Adicionar refeição')),
            ],
          ),
        ),
      ),
    );
  }
}