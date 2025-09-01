import 'package:flutter/material.dart';

class HourlyForcastItem extends StatelessWidget {
  final String time;
  final String temprature;
  final IconData icon;
  const HourlyForcastItem({
    super.key,
    required this.time,
    required this.temprature,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              time,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            Icon(
              icon,
              size: 32,
            ),
            SizedBox(height: 8),
            Text(
              '$temprature °K',
            ),
          ],
        ),
      ),
    );
  }
}
