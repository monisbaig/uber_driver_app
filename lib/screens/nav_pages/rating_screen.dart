import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:uber_driver_app/providers/app_info_provider.dart';

import '../../global_variables/global_variables.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double ratings = 0;

  setupRatingTitle() {
    if (ratings == 1) {
      setState(() {
        starRatingTitle = 'Very Bad';
      });
    }
    if (ratings == 2) {
      setState(() {
        starRatingTitle = 'Bad';
      });
    }
    if (ratings == 3) {
      setState(() {
        starRatingTitle = 'Good';
      });
    }
    if (ratings == 4) {
      setState(() {
        starRatingTitle = 'Very Good';
      });
    }
    if (ratings == 5) {
      setState(() {
        starRatingTitle = 'Excellent';
      });
    }
  }

  getRatingNumber() {
    setState(() {
      ratings = double.parse(
          Provider.of<AppInfoProvider>(context, listen: false)
              .driverAverageRatings);
    });
    setupRatingTitle();
  }

  @override
  void initState() {
    super.initState();
    getRatingNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        child: Container(
          margin: const EdgeInsets.all(12),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Your Ratings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Divider(
                thickness: 4,
                height: 4,
                color: Colors.blue,
              ),
              const SizedBox(height: 10),
              SmoothStarRating(
                rating: ratings,
                allowHalfRating: false,
                starCount: 5,
                size: 40,
                color: Colors.orangeAccent,
              ),
              const SizedBox(height: 10),
              Text(
                starRatingTitle,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
