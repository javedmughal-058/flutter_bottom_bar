import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Animated Bottom Bar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CustomUI(),
    );
  }
}

class CustomUI extends StatefulWidget {
  final List<BarItem> barItems = [
    BarItem(
      text: 'Home',
      iconData: Icons.home,
      color: Colors.indigo,
    ),
    BarItem(
      text: 'Likes',
      iconData: Icons.favorite_border,
      color: Colors.pinkAccent,
    ),
    BarItem(
      text: 'Search',
      iconData: Icons.search,
      color: Colors.yellow.shade900,
    ),
    BarItem(
      text: 'Profile',
      iconData: Icons.person_outline,
      color: Colors.teal,
    ),
  ];

  CustomUI({super.key});

  @override
  _CustomUIState createState() => _CustomUIState();
}

class _CustomUIState extends State<CustomUI> {
  int selectedBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        // color: widget.barItems[selectedBarIndex].color,
        color: Colors.white,
        child: Center(child: Text(widget.barItems[selectedBarIndex].text, style: Theme.of(context).textTheme.titleLarge)),
      ),
      bottomNavigationBar: AnimatedBottomBar(
        barItems: widget.barItems,
        animationDuration: const Duration(milliseconds: 150),
        barStyle: BarStyle(
          fontSize: 12.0,
          iconSize: 22.0,
        ),
        onBarTap: (index) {
          setState(() {
            selectedBarIndex = index;
          });
        },
      ),
    );
  }
}

class AnimatedBottomBar extends StatefulWidget {
  final List<BarItem> barItems;
  final Duration animationDuration;
  final Function onBarTap;
  final BarStyle barStyle;

  const AnimatedBottomBar(
      {super.key, required this.barItems,
        this.animationDuration = const Duration(milliseconds: 500),
        required this.onBarTap,
        required this.barStyle});


  @override
  _AnimatedBottomBarState createState() => _AnimatedBottomBarState();
}

class _AnimatedBottomBarState extends State<AnimatedBottomBar>
    with TickerProviderStateMixin {
  int selectedBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 16.0,
          left: 16.0,
          right: 16.0,
          top: 16.0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _buildBarItems(),
        ),
      ),
    );
  }

  List<Widget> _buildBarItems() {
    List<Widget> barItems = [];

    for (var item in widget.barItems) {
      int index = widget.barItems.indexOf(item);
      bool isSelected = selectedBarIndex == index;

      barItems.add(InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          setState(() {
            selectedBarIndex = index;
            widget.onBarTap(index);
          });
        },
        child: AnimatedContainer(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          duration: widget.animationDuration,
          decoration: BoxDecoration(
            color: isSelected ? item.color.withOpacity(0.15) : Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(30.0)),
          ),
          child: Row(
            children: <Widget>[
              Icon(item.iconData, color: isSelected ? item.color : Colors.black, size: widget.barStyle.iconSize),
              const SizedBox(width: 10.0),
              AnimatedSize(
                duration: widget.animationDuration,
                curve: Curves.easeInOut,
                child: Text(
                  isSelected ? item.text : "",
                  style: TextStyle(
                    color: item.color,
                    fontWeight: widget.barStyle.fontWeight,
                    fontSize: widget.barStyle.fontSize,
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
    }

    return barItems;
  }
}

class BarStyle {
  final double fontSize, iconSize;
  final FontWeight fontWeight;

  BarStyle({
    this.fontSize = 18.0,
    this.iconSize = 32.0,
    this.fontWeight = FontWeight.w600,
  });
}

class BarItem {
  String text;
  IconData iconData;
  Color color;

  BarItem({required this.text, required this.iconData, required this.color});
}