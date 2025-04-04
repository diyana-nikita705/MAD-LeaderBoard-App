import 'package:flutter/material.dart';
import 'package:leaderboard_app/shared/colors.dart';
import 'package:leaderboard_app/models/students.dart'; // Import StudentService

class Placement extends StatefulWidget {
  const Placement({super.key});

  @override
  State<Placement> createState() => _PlacementState();
}

class _PlacementState extends State<Placement> {
  final TextEditingController _studentIdController = TextEditingController();
  final StudentService _studentService = StudentService();
  Student? _student;
  String? _error;
  int? _rank;

  void _searchStudent() async {
    final studentId = _studentIdController.text.trim();
    if (studentId.isEmpty) {
      setState(() {
        _error = "Please enter a valid Student ID.";
        _student = null;
        _rank = null;
      });
      return;
    }

    try {
      final studentDoc = await _studentService.fetchStudentById(studentId);
      if (studentDoc != null) {
        // Fetch leaderboard data dynamically
        final leaderboard = await _studentService.fetchStudentsPaginated(100);
        final rank = leaderboard.indexWhere(
          (student) => student.id == studentId,
        );
        setState(() {
          _student = studentDoc;
          _rank =
              rank != -1
                  ? rank + 1
                  : null; // Convert 0-based index to 1-based rank
          _error = null;
        });
      } else {
        setState(() {
          _error = "Student not found.";
          _student = null;
          _rank = null;
        });
      }
    } catch (e) {
      setState(() {
        _error = "Failed to fetch student details.";
        _student = null;
        _rank = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBgColor,
      body: Center(
        child: SingleChildScrollView(
          // Added SingleChildScrollView
          padding: const EdgeInsets.all(16.0), // Added padding
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, // Center content
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Check your\n',
                  style: const TextStyle(
                    fontSize: 40, // Increased font size
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: 'Placement',
                      style: TextStyle(
                        fontSize: 40, // Increased font size
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryAccentColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
              Stack(
                children: [
                  SizedBox(
                    // Added SizedBox to control width
                    width:
                        MediaQuery.of(context).size.width *
                        0.8, // Set width to 80% of screen
                    child: TextField(
                      controller: _studentIdController,
                      decoration: InputDecoration(
                        hintText: 'Enter Student ID',
                        hintStyle: const TextStyle(color: Colors.grey),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ), // Added padding
                        border: OutlineInputBorder(
                          // Added rounded border
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none, // No visible border
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryAccentColor,
                        foregroundColor: AppColors.primaryBgColor,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _searchStudent, // Call search logic
                      child: const Icon(Icons.search, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_error != null)
                Text(
                  _error!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ), // Styled error text
                  textAlign: TextAlign.center,
                ),
              if (_student != null)
                Card(
                  elevation: 4, // Added elevation for better appearance
                  margin: const EdgeInsets.symmetric(
                    vertical: 16.0,
                  ), // Added margin
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name: ${_student!.name}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Department: ${_student!.department}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Batch: ${_student!.batch}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Section: ${_student!.section}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Result: ${_student!.result}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Achievement: ${_student!.achievement}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Extracurricular: ${_student!.extracurricular}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Co-Curriculum: ${_student!.coCurriculum}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        if (_rank != null)
                          Text(
                            "Rank: $_rank",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
