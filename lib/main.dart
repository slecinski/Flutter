// Here import module required for the app
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///
/// void main is mandatory
void main() {
  runApp(MyApp());
}

// statelesswidget is here coding the app structure
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'firstapp',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange.shade200),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

// MyAppState is to manage variables between widgets
class MyAppState extends ChangeNotifier {
  var current =
      WordPair.random(); // generate random wordpair in variable called current

  void getNext() {
    current = WordPair.random(); //fonction to generate the randome words
    notifyListeners();
  }

  var favorites = <WordPair>[]; // list of favorite

  // To generate the list of favorite, will add in the list each time  there's a new favorite selected
  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

// ...

// That is initialising the presence of a the menu from the homepage
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// This is coding the menu and what to display. It's generating structure
class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage(); // Printing the hompage
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError(
            'no widget for $selectedIndex'); // avoid bugs if the value inside selectedIndex is not the expected one
    }
    // coding for menu displayed as a row
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home), // add the house icon in the menu
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite), //add the heart icon in the menu
                    label: Text('Favorites'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page, // generate the favorite page
              ),
            ),
          ],
        ),
      );
    });
  }
}

// the Homepage is called GeneratorPage - that's it's class and the name used when the page need to be displayed
class GeneratorPage extends StatelessWidget {
  //Code the homepage
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;
    //take the wordpaire value in current from the appstate and put in a local variable called pair

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
      // the heart icon is codded by "Icons.favorite" - field with color if a word is selected
    } else {
      icon = Icons.favorite_border;
      // Heart icon without colour fill, only borders is coded by "Icons.favorite_border" - will be displayed when no favorite selected
    }

    // To code what to print on the homepage
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text(
          //   'Band name generator',
          //   style: TextStyle(
          //     fontFamily: 'RobotoMono',
          //     color: Color.fromARGB(255, 203, 99, 19),
          //     fontWeight: FontWeight.bold,
          //     fontSize: 30,
          //   ),

          // ),
          // SizedBox(height: 80),
          BigCard(pair: pair), // box with the pairword
          SizedBox(height: 50),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                //make a button with an icon
                onPressed: () {
                  appState.toggleFavorite(); // take the favorite value
                },
                icon: Icon(icon),
                label: Text('like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                // make a button no icon
                onPressed: () {
                  appState.getNext(); //generate pairword function
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// NEW Inserstion sarah

//class FavoritePage extends StatelessWidget {}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}

// END insertion sarah

// the pairword display is coded as a statelesswidget too - here are the formating info of it codded
class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        //child: Text(pair.asLowerCase),
        //child: Text(pair.asLowerCase, style: style),
        child: Text(
          textAlign: TextAlign.center,
          '(The) ' + pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}", // for disabled poeple
        ),
      ),
    );
  }
}
