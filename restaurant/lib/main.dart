import 'package:flutter/material.dart';
import 'package:restaurant/dummy_data.dart';
import 'package:restaurant/screens/meal_detail_screen.dart';
import 'package:restaurant/screens/settings_screen.dart';
import 'package:restaurant/screens/tabs_screen.dart';
import './screens/category_meals_screen.dart';
import './models/meal.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _settings = {
    'gluten': false,
    'lactose': false,
    'vegan': false,
    'vegetarian': false,
  };
  List<Meal> _availableMeals = DUMMY_MEALS;
  List<Meal> _favoritesMeals = [];

  void _setSettings(Map<String, bool> settingData) {
    setState(() {
      _settings = settingData;
      _availableMeals = DUMMY_MEALS.where((meal) {
        if (_settings['gluten'] && !meal.isGlutenFree) {
          return false;
        }
        if (_settings['lactose'] && !meal.isLactoseFree) {
          return false;
        }
        if (_settings['vegan'] && !meal.isVegan) {
          return false;
        }
        if (_settings['vegetarian'] && !meal.isVegetarian) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  void _toggleFavorite(String mealId) {
    final existingIndx =
        _favoritesMeals.indexWhere((meal) => meal.id == mealId);
    if (existingIndx >= 0) {
      setState(() {
        _favoritesMeals.removeAt(existingIndx);
      });
    } else {
      setState(() {
        _favoritesMeals
            .add(DUMMY_MEALS.firstWhere((meal) => meal.id == mealId));
      });
    }
  }

  bool _isMealFav(String id) {
    return _favoritesMeals.any((meal) => meal.id == id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
            bodyText1: TextStyle(
              color: Color.fromRGBO(20, 51, 51, 1),
            ),
            bodyText2: TextStyle(
              color: Color.fromRGBO(20, 51, 51, 1),
            ),
            headline6: TextStyle(
                fontSize: 20,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold)),
      ),
      //home: CategoriesScreen(),
      routes: {
        '/': (ctx) => TabsScreen(_favoritesMeals),
        CategoryMealsScreen.routeName: (ctx) =>
            CategoryMealsScreen(_availableMeals),
        MealDetailScreen.routeName: (ctx) => MealDetailScreen(_toggleFavorite, _isMealFav),
        SettingsScreen.routeName: (ctx) =>
            SettingsScreen(_settings, _setSettings),
      },
    );
  }
}
