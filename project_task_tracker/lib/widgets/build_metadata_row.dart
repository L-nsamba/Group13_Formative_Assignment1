// Helper method for aligned metadata rows
import 'package:flutter/material.dart';

Widget buildMetadataRow({
  required IconData icon,
  required String label,
  required Widget valueWidget,
}) {
  return Row(
    children: [
      Icon(icon, size: 20, color: Color.fromRGBO(100, 116, 139, 1)),
      const SizedBox(width: 12),
      SizedBox(
        width: 90,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color.fromRGBO(100, 116, 139, 1),
          ),
        ),
      ),
      Expanded(child: valueWidget),
    ],
  );
}
