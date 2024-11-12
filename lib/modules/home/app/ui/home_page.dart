import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    ChatPage(),
    WritePage(),
    TranslatePage(),
    SearchPage(),
    OCRPage(),
    GrammarPage(),
    AskPage(),
  ];

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(
                child: Text(
                  'Jarvis AI',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            NavDrawerItem(
              icon: Icons.chat,
              label: "Chat",
              index: 0,
              selectedIndex: _selectedIndex,
              onTap: _onNavItemTapped,
            ),
            NavDrawerItem(
              icon: Icons.edit,
              label: "Write",
              index: 1,
              selectedIndex: _selectedIndex,
              onTap: _onNavItemTapped,
            ),
            NavDrawerItem(
              icon: Icons.translate,
              label: "Translate",
              index: 2,
              selectedIndex: _selectedIndex,
              onTap: _onNavItemTapped,
            ),
            NavDrawerItem(
              icon: Icons.search,
              label: "Search",
              index: 3,
              selectedIndex: _selectedIndex,
              onTap: _onNavItemTapped,
            ),
            NavDrawerItem(
              icon: Icons.camera,
              label: "OCR",
              index: 4,
              selectedIndex: _selectedIndex,
              onTap: _onNavItemTapped,
            ),
            NavDrawerItem(
              icon: Icons.spellcheck,
              label: "Grammar",
              index: 5,
              selectedIndex: _selectedIndex,
              onTap: _onNavItemTapped,
            ),
            NavDrawerItem(
              icon: Icons.question_answer,
              label: "Ask",
              index: 6,
              selectedIndex: _selectedIndex,
              onTap: _onNavItemTapped,
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}

class NavDrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int selectedIndex;
  final Function(int) onTap;

  const NavDrawerItem({
    super.key,
    required this.icon,
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: index == selectedIndex ? Colors.blue : Colors.grey),
      title: Text(
        label,
        style: TextStyle(color: index == selectedIndex ? Colors.blue : Colors.grey),
      ),
      selected: index == selectedIndex,
      onTap: () => onTap(index),
    );
  }
}

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Chat Page"));
  }
}

class WritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Write Page"));
  }
}

class TranslatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Translate Page"));
  }
}

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Search Page"));
  }
}

class OCRPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("OCR Page"));
  }
}

class GrammarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Grammar Page"));
  }
}

class AskPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Ask Page"));
  }
}
