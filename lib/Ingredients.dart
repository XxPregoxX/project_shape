import 'package:flutter/material.dart';
import 'package:project_shape/GeneralWidgets.dart';
import 'package:project_shape/functions.dart';

class ingredients extends StatefulWidget {
  const ingredients({super.key});

  @override
  State<ingredients> createState() => _ingredientsState();
}

class _ingredientsState extends State<ingredients> {
    List<Map<String, dynamic>> ingredients = [];
    int limit = 10;
    int offset = 0;
    bool isLoading = false;
    bool hasMore = true;
    final ScrollController _controller = ScrollController();
    Future<void> loadMore() async {
        if (isLoading || !hasMore) return;

        setState(() {isLoading = true;});

        final newItems = await Ingredients().fetchIngredients(
          limit: limit,
          offset: offset,
        );

        if (newItems.isEmpty) {
          hasMore = false;
        } else {
          ingredients.addAll(newItems);
          offset += limit;
        }


        setState(() {isLoading = false;});
    }

    @override
    void initState() {
      super.initState();
      _controller.addListener(() {
        if (_controller.position.pixels >=
            _controller.position.maxScrollExtent - 100) {
          loadMore();
        }
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
    _ensureScrollable();
    });
    }

    Future<void> _ensureScrollable() async {
  if (!_controller.hasClients) return;

  while (_controller.position.maxScrollExtent == 0 && hasMore && !isLoading) {
    await loadMore();
    await Future.delayed(const Duration(milliseconds: 16)); // deixa o frame respirar
  }
  } 

    Future<void> goToAddIngredient() async {
    final result = await Navigator.pushNamed(context, '/add_ingredient');
    if (result == true) {
      ingredients.clear();
      offset = 0;
      hasMore = true;
      await loadMore();
    }
    }

    build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
          width: screenWidth * 0.8,
          child: Column(children: [
            search_bar('Pesquisar'),
            Expanded(
              child: ListView.builder(
                controller: _controller,
                itemCount: ingredients.length + (isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < ingredients.length) {
                    final item = ingredients[index];
                    return ingredient_card(item);
                  } else {
                    return Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
            ),
          ],),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        goToAddIngredient();
      }, 
      child: Icon(Icons.add),
      shape: CircleBorder(),
    ),
    );
  }
}