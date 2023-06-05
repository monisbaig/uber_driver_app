import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_info_provider.dart';
import '../widgets/history_design.dart';

class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({super.key});

  @override
  State<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    var historyData = Provider.of<AppInfoProvider>(context, listen: false)
        .tripHistoryInfoList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip History'),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Divider(
              thickness: 1,
              height: 1,
              color: Colors.blue,
            ),
          );
        },
        itemCount: historyData.length,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return HistoryDesign(
            historyModel: historyData[index],
          );
        },
      ),
    );
  }
}
