import 'package:flutter/material.dart';
import 'package:project_shape/GeneralWidgets.dart';
import 'package:project_shape/functions.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Container(
          width: screenWidth * 0.8,
          child: Column(
            children: [
              SizedBox(height: 40),
              FutureBuilder(future: Profile().getProfile(), builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final profile = snapshot.data as Map;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Nome: ${profile['name']}'),
                          IconButton(onPressed: () => edit_profile(context), icon: Icon(Icons.mode_edit, color: Colors.white))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Altura: ${profile['height']}'),
                          Text('Data de nascimento: ${profile['birth_date']}')
                        ],
                      )
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('Erro ao carregar perfil');
                } else if(snapshot.data == null) {
                  return TextButton(onPressed: () => edit_profile(context), child: Text('Adicionar perfil'));
                } else {
                  return Text('Carregando perfil...');
                }
              }),
              FutureBuilder(future: Profile().getAllGoals(), builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final goals = snapshot.data as List<Map>;
                  return Column(
                    children: goals.map((goal) => goal_card(goal)).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Erro ao carregar metas');
                } else {
                  return Text('Carregando metas...');
                }
              }),
              TextButton(onPressed: (){add_goal(context);}, child: Text('adicionar meta'))
            ],
          )),
      ),
    );
  }
}