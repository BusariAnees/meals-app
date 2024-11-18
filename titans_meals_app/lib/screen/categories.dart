import 'package:flutter/material.dart';
import 'package:titans_meals_app/data/dummy_data.dart';
import 'package:titans_meals_app/models/meal.dart';
import 'package:titans_meals_app/screen/meals.dart';
import 'package:titans_meals_app/models/categories.dart';
import 'package:titans_meals_app/widgets/category_grid_item.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.availableMeals});

  final List<Meal> availableMeals;
  @override
  State<CategoriesScreen> createState() {
    return _CategoriesScreenState();
  }
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
        lowerBound: 0,
        upperBound: 1);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = widget.availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();

    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => MealsSCreen(
            title: category.title,
            meals: filteredMeals))); //Navigator.push(context,route)
  }

  @override
  Widget build(BuildContext context) {
    return
        // InkWell
        AnimatedBuilder(
            animation: _animationController,
            child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                children: [
                  // availableCategories.map(category) => CategoryGridItem(category:category),
                  for (final category in availableCategories)
                    CategoriesGridItem(
                      category: category,
                      onSelectCategory: () {
                        _selectCategory(context, category);
                      },
                    )
                ]),
            builder: (context, child) => SlideTransition(
                  position: Tween(
                    begin: const Offset(0, 0.3),
                    end: const Offset(0, 0),
                  ).animate(CurvedAnimation(
                      parent: _animationController, curve: Curves.easeOut)),
                  child: child,
                ));
  }
}
