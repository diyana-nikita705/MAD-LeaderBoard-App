import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leaderboard_app/screens/profile/profileupdate.dart';
import 'package:leaderboard_app/screens/signin/sign_in.dart';
import 'package:leaderboard_app/shared/colors.dart';
import 'package:leaderboard_app/providers/auth_provider.dart';
import 'package:leaderboard_app/models/students.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  final TextEditingController _studentIdController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  Future<void> _fetchStudentDetails(String studentId) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final studentService = StudentService();
      final student = await studentService.fetchStudentById(studentId);
      if (student != null) {
        ref.read(studentProvider.notifier).setStudent(student);
      } else {
        setState(() {
          _error = 'Student not found.';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to fetch student details: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final student = ref.watch(studentProvider);
    final leaderboardData = ref.watch(leaderboardProvider);
    final rank = leaderboardData['currentRank'] as int?;

    return authState.when(
      data: (user) {
        if (user == null) {
          ref
              .read(studentProvider.notifier)
              .clearStudent(); // Clear profile on logout
          return const SignIn(); // Redirect to SignIn if user is not logged in
        }

        return Scaffold(
          backgroundColor: AppColors.primaryBgColor,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 32.0,
              ), // Added vertical padding
              child:
                  student == null
                      ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                            controller: _studentIdController,
                            decoration: InputDecoration(
                              labelText: 'Enter Student ID',
                              labelStyle: TextStyle(
                                color:
                                    AppColors
                                        .secondaryAccentColor, // Set label color to secondary accent color
                                fontWeight: FontWeight.bold,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: AppColors.primaryAccentColor.withAlpha(
                                25,
                              ), // Replaced withAlpha
                            ),
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.primaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed:
                                _isLoading
                                    ? null
                                    : () {
                                      final studentId =
                                          _studentIdController.text.trim();
                                      if (studentId.isNotEmpty) {
                                        _fetchStudentDetails(studentId);
                                      }
                                    },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryAccentColor,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child:
                                _isLoading
                                    ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                    : const Text(
                                      'Load Profile',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                          ),
                          if (_error != null) ...[
                            const SizedBox(height: 16),
                            Text(
                              _error!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      )
                      : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                          ), // Added vertical padding
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 60,
                                      backgroundImage: const AssetImage(
                                        'assets/profile_picture.png',
                                      ),
                                      backgroundColor:
                                          AppColors.primaryAccentColor,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      student.name,
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryTextColor,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Hi, ${user.email}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 6,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Student Details',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const Divider(thickness: 1.5),
                                      const SizedBox(height: 8),
                                      _buildDetailRow('Student ID', student.id),
                                      _buildDetailRow(
                                        'Department',
                                        student.department,
                                      ),
                                      _buildDetailRow(
                                        'Batch',
                                        student.batch.toString(),
                                      ),
                                      _buildDetailRow(
                                        'Section',
                                        student.section,
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'Academic Details',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const Divider(thickness: 1.5),
                                      const SizedBox(height: 8),
                                      _buildDetailRow(
                                        'CGPA',
                                        student.result.toString(),
                                      ),
                                      if (rank != null)
                                        _buildDetailRow(
                                          'Rank',
                                          rank.toString(),
                                        ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'Achievements',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const Divider(thickness: 1.5),
                                      const SizedBox(height: 8),
                                      _buildDetailRow(
                                        'Achievement Points',
                                        student.achievement.toString(),
                                      ),
                                      _buildDetailRow(
                                        'Extracurricular',
                                        student.extracurricular,
                                      ),
                                      _buildDetailRow(
                                        'Co-Curriculum',
                                        student.coCurriculum,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AppColors.primaryAccentColor,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfileUpdate(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Update Profile',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
