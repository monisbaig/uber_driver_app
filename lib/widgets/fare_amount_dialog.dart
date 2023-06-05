import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uber_driver_app/global_variables/global_variables.dart';

class FareAmountDialog extends StatefulWidget {
  final double totalFareAmount;

  const FareAmountDialog({super.key, required this.totalFareAmount});

  @override
  State<FareAmountDialog> createState() => _FareAmountDialogState();
}

class _FareAmountDialogState extends State<FareAmountDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Container(
        margin: const EdgeInsets.all(6),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Text(
              'Trip Fare Amount (${driverCarType!.toUpperCase()})',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            const Divider(
              thickness: 1,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            Text(
              widget.totalFareAmount.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 50,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Please collect your amount',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(18),
              child: ElevatedButton(
                onPressed: () {
                  Future.delayed(const Duration(seconds: 3), () {
                    SystemNavigator.pop();
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Collect Cash',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Rs: ${widget.totalFareAmount}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
