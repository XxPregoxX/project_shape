import 'package:flutter/material.dart';
import 'package:project_shape/GeneralWidgets.dart';
import 'package:project_shape/functions.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  
  Future<void> editProfile(BuildContext context, [List? profileData]) async {
    await edit_profile(context, (){setState(() {});}, profileData);
  }

  Future<void> addGoal(BuildContext context) async {
    await add_goal(context, (){setState(() {});});
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Container(
          width: screenWidth * 0.9,
          child: Column(
            children: [
              SizedBox(height: 40),
              FutureBuilder(future: Profile().getProfile(), builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final profile = snapshot.data as Map;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: [
                             titleText('${profile['name']}'),
                             IconButton(
                                 padding: EdgeInsets.zero,
                                 constraints: const BoxConstraints(),
                                 onPressed: () => editProfile(
                                   context,
                                   [profile['name'], profile['birth_date'], profile['height'].toString()]
                                 ),
                                 icon: const Icon(Icons.mode_edit, color: Colors.white, size: 25),
                             ),
                           ],
                         ),
                      SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            subtitleText('Altura: ${profile['height']}'),
                            SizedBox(width: 50,),
                            subtitleText('Idade: ${Profile().calcAge(profile['birth_date'])}')
                          ],
                        ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('Erro ao carregar perfil');
                } else if(snapshot.data == null) {
                  return TextButton(onPressed: () => editProfile(context), child: Text('Adicionar perfil'));
                } else {
                  return Text('Carregando perfil...');
                }
              }),
              FutureBuilder(future: Profile().getAllGoals(), builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final goals = snapshot.data as List<Map>;
                  return Column(
                    children: [
                      titleText('Metas'),
                      Column(
                        children: goals.map((goal) => goal_card(goal)).toList(),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('Erro ao carregar metas');
                } else {
                  return Text('Carregando metas...');
                }
              }),
              TextButton(onPressed: (){addGoal(context);}, child: Text('adicionar meta'))
            ],
          )),
      ),
    );
  }
}