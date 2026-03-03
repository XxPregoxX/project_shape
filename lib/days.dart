import 'package:flutter/material.dart';
import 'package:project_shape/GeneralWidgets.dart';
import 'package:project_shape/functions.dart';

class days extends StatefulWidget {
  const days({super.key});

  @override
  State<days> createState() => _daysState();
}

class _daysState extends State<days> {

  getDays() async {
    List<Map<String, dynamic>> goals = await Profile().getAllGoals();
    if (goals.isEmpty) {
      return [];
    }
    List<Map<String, dynamic>> days = await Days().getAll();
    return days;
  }
    
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: screenWidth * 0.8,
          child: FutureBuilder(future: getDays(), builder: (context, snapshot){
            if (snapshot.data != null && (snapshot.data as List).isEmpty) {
              return Center(child: Text('Nenhuma meta encontrada. Adicione uma meta e reinicie o aplicativo para começar a registrar seus dias!'));
            } else if(snapshot.hasData){
              List<Map<String, dynamic>> days = snapshot.data as List<Map<String, dynamic>>;
              return ListView.builder(
                itemCount: days.length,
                itemBuilder: (context, index){
                  var day = days[index];
                  return day_card(context, day);
                },
              );
            }else{
              return const CircularProgressIndicator();
            }
          }),
        ),
      ),
    );
    
  }
}