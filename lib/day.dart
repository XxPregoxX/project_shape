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
  late bool edited;

  @override
  void initState() {
    super.initState();
    edited = false;
    Day = (this.widget.Day);
  }

  remove_consumed(int index)async{
    await Days().removeConsumed(Day['day_id'], index);
    Day = await Days().getById(Day['day_id']);
    edited = true;
    setState(() {});
  }

  Future<List<Widget>> buildCards() async{
    List<Widget> cards = [];
    for (int index = 0; index < Day['consumed'].length; index++){
      var i = Day['consumed'][index];
      await consumed_card(context, i, (){remove_consumed(index);}).then((value) => cards.add(value));
    }
    return cards;
  }

  add_consumed() async {
    final result = await AddConsumed(context, Day['day_id']);
    Day = await Days().getById(Day['day_id']);
    edited = true;
    if (result == true) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, edited);
            },)
      ),
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