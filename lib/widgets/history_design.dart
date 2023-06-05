import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/history_model.dart';

class HistoryDesign extends StatefulWidget {
  final HistoryModel historyModel;

  const HistoryDesign({super.key, required this.historyModel});

  @override
  State<HistoryDesign> createState() => _HistoryDesignState();
}

class _HistoryDesignState extends State<HistoryDesign> {
  String formatDateTime(String dateTimeFormat) {
    DateTime dateTime = DateTime.parse(dateTimeFormat);

    String formattedDateTime = DateFormat.yMMMd().format(dateTime);

    return formattedDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'User: ${widget.historyModel.userName!}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Rs: ${widget.historyModel.fareAmount!}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.phone_android,
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.historyModel.userPhone!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/origin.png',
                  height: 20,
                  width: 20,
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    widget.historyModel.originAddress!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/destination.png',
                  height: 20,
                  width: 20,
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    widget.historyModel.destinationAddress!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              formatDateTime(widget.historyModel.time!),
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
