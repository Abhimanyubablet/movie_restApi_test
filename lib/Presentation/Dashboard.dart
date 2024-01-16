import 'package:flutter/material.dart';
import 'package:project_for_movie_with_api/Presentation/shows.dart';
import 'package:project_for_movie_with_api/Presentation/videos.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Videos'),
            Tab(text: 'Show',)
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Videos(),
          Shows(),
        ],
      ),
    );
  }
}
