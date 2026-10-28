import 'package:flutter/material.dart';
import 'package:job_app/core/theme/app_colors.dart';
import 'package:job_app/models/internship.dart';
import 'package:job_app/screens/providers/tab_provider.dart';
import 'package:job_app/widgets/about_widget.dart';
import 'package:job_app/widgets/benefits_widget.dart';
import 'package:job_app/widgets/requirement_widget.dart';
import 'package:job_app/widgets/review_widget.dart';
import 'package:provider/provider.dart';

class TabWidget extends StatefulWidget {
  const new({super.key, required this.internship});
  final Internship internship;

  @override
  State<TabWidget> createState() => _TabWidgetState();
}

class _TabWidgetState extends State<TabWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<TabProvider>().changeTabIndex(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTabIndex = context.watch<TabProvider>().currentTabIndex;

    if (_tabController.index != currentTabIndex) {
      _tabController.animateTo(currentTabIndex);
    }
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          tabs: [
            Tab(text: 'About'),
            Tab(text: 'Requriements'),
            Tab(text: 'Benefits'),
            Tab(text: 'Reviews'),
          ],
        ),
        const SizedBox(height: 20),

        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              AboutWidget(internship: widget.internship),
              RequirementWidget(),
              BenefitsWidget(),
              ReviewsWidget(),
            ],
          ),
        ),
      ],
    );
  }
}
