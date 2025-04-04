import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leaderboard_app/screens/profile/profileupdate.dart';
import 'package:leaderboard_app/screens/signin/sign_in.dart';
import 'package:leaderboard_app/shared/colors.dart';
import 'package:leaderboard_app/providers/auth_provider.dart';
import 'package:leaderboard_app/models/students.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  final TextEditingController _studentIdController = TextEditingController();
  bool _isLoading = false;
  String? _error;
  int? _profileRank; // Add a state variable to store the fetched rank
  int? _peopleAhead;
  int? _peopleBehind;

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
    } on Exception catch (e) {
      if (e.toString().contains('Student not found')) {
        setState(() {
          _error = 'Student not found.';
        });
      } else {
        setState(() {
          _error = 'Failed to fetch student details: $e';
        });
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchRank(String studentId) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('students')
              .orderBy('Result', descending: true)
              .get();

      final students = querySnapshot.docs;
      final rank = students.indexWhere((doc) => doc.id == studentId) + 1;

      if (rank > 0) {
        setState(() {
          _profileRank = rank;
          _peopleAhead = rank - 1; // People ahead are rank - 1
          _peopleBehind =
              students.length - rank; // People behind are total - rank
        });
      } else {
        setState(() {
          _error = 'Rank not found.';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to fetch rank: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>?> _fetchProfileData(String studentId) async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('profiles')
              .doc(studentId)
              .get();
      if (doc.exists) {
        return doc.data();
      }
    } catch (e) {
      debugPrint('Error fetching profile data: $e');
    }
    return null;
  }

  Future<void> _bindProfileToAccount(String studentId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('user_profiles')
        .doc(user.uid)
        .set({'profileId': studentId});
  }

  Future<void> _unbindProfileFromAccount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('user_profiles')
        .doc(user.uid)
        .delete();

    ref.read(studentProvider.notifier).clearStudent();
    setState(() {
      _profileRank = null;
      _peopleAhead = null;
      _peopleBehind = null;
    });
  }

  @override
  void initState() {
    super.initState();
    ref.read(boundProfileProvider).whenData((profileId) {
      if (profileId != null) {
        _fetchStudentDetails(profileId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final student = ref.watch(studentProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref
                .read(studentProvider.notifier)
                .clearStudent(); // Clear profile on logout
          });
          return const SignIn(); // Redirect to SignIn if user is not logged in
        }

        return FutureBuilder<Map<String, dynamic>?>(
          future: _fetchProfileData(student?.id ?? ''),
          builder: (context, snapshot) {
            final profileData = snapshot.data ?? {};
            final profilePictureUrl = profileData['profilePictureUrl'] ?? '';
            final bio = profileData['bio'] ?? 'No bio available';

            return Scaffold(
              backgroundColor: AppColors.primaryBgColor,
              body: Center(
                child:
                    student == null
                        ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RichText(
                              // Updated to use RichText for styling "Load" and "Profile"
                              text: TextSpan(
                                text: 'Load ',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      AppColors
                                          .primaryTextColor, // "Load" uses primary text color
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Profile',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          AppColors
                                              .secondaryAccentColor, // "Profile" uses secondary accent color
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ), // Added spacing below the text
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
                                      hintStyle: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ), // Added padding
                                      border: OutlineInputBorder(
                                        // Added rounded border
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide:
                                            BorderSide
                                                .none, // No visible border
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
                                      backgroundColor:
                                          AppColors.secondaryAccentColor,
                                      foregroundColor: AppColors.primaryBgColor,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed:
                                        _isLoading
                                            ? null
                                            : () {
                                              final studentId =
                                                  _studentIdController.text
                                                      .trim();
                                              if (studentId.isNotEmpty) {
                                                _fetchStudentDetails(studentId);
                                              }
                                            },
                                    child:
                                        _isLoading
                                            ? const CircularProgressIndicator(
                                              color: Colors.white,
                                            )
                                            : const Icon(
                                              Icons.search,
                                              size: 20,
                                            ),
                                  ),
                                ),
                              ],
                            ),
                            if (_error != null) ...[
                              const SizedBox(height: 16),
                              Text(
                                _error!,
                                style: const TextStyle(
                                  color:
                                      AppColors
                                          .secondaryAccentColor, // Changed to secondary accent color
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        )
                        : SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  backgroundImage:
                                      profilePictureUrl.isNotEmpty
                                          ? NetworkImage(profilePictureUrl)
                                          : const AssetImage(
                                                'assets/profile.png',
                                              )
                                              as ImageProvider,
                                  onBackgroundImageError: (_, __) {
                                    debugPrint(
                                      'Error loading profile picture asset.',
                                    );
                                  },
                                  backgroundColor: AppColors.primaryAccentColor,
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
                                  bio,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.primaryTextColor,
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
                                        _buildDetailRow(
                                          'Student ID',
                                          student.id,
                                        ),
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
                                        if (_profileRank != null) ...[
                                          _buildDetailRow(
                                            'Rank',
                                            _profileRank.toString(),
                                          ), // Only display rank text
                                          _buildDetailRow(
                                            'People Ahead',
                                            _peopleAhead.toString(),
                                          ),
                                          _buildDetailRow(
                                            'People Behind',
                                            _peopleBehind.toString(),
                                          ),
                                        ],
                                        if (_profileRank != null) ...[
                                          const SizedBox(height: 16),
                                          const Text(
                                            'Badges',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const Divider(thickness: 1.5),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              if (_profileRank == 1) ...[
                                                Column(
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.yellow,
                                                      size: 40,
                                                    ), // Rank 1 badge
                                                    const SizedBox(height: 4),
                                                    const Text(
                                                      'Rank 1',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(width: 16),
                                              ],
                                              if (_profileRank! <= 10) ...[
                                                Column(
                                                  children: [
                                                    Icon(
                                                      Icons.emoji_events,
                                                      color: Colors.orange,
                                                      size: 40,
                                                    ), // Top 10 badge
                                                    const SizedBox(height: 4),
                                                    const Text(
                                                      'Top 10',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                        ],
                                        const SizedBox(height: 16),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors
                                                    .transparent, // Transparent background
                                            elevation: 0, // Remove shadow
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              side: BorderSide(
                                                color:
                                                    AppColors
                                                        .secondaryAccentColor, // Border color
                                              ),
                                            ),
                                          ),
                                          onPressed:
                                              _isLoading
                                                  ? null
                                                  : () {
                                                    if (student != null) {
                                                      _fetchRank(student.id);
                                                    }
                                                  },
                                          child:
                                              _isLoading
                                                  ? const CircularProgressIndicator(
                                                    color:
                                                        AppColors
                                                            .secondaryAccentColor,
                                                  )
                                                  : Text(
                                                    'Fetch Rank',
                                                    style: TextStyle(
                                                      color:
                                                          AppColors
                                                              .secondaryAccentColor, // Text color
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
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
                                ElevatedButton(
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
                                  onPressed: () async {
                                    final shouldReload = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ProfileUpdate(
                                              studentId: student.id,
                                            ),
                                      ),
                                    );
                                    if (shouldReload == true) {
                                      setState(
                                        () {},
                                      ); // Reload the profile data
                                    }
                                  },
                                  child: const Text(
                                    'Update Profile',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
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
                                  onPressed: () async {
                                    if (student != null) {
                                      await _bindProfileToAccount(student.id);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Profile bound to account successfully!',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text(
                                    'Bind Profile to Account',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () async {
                                    await _unbindProfileFromAccount();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Profile unbound from account successfully!',
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Unbind Account',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 32,
                                ), // Add spacing at the bottom
                              ],
                            ),
                          ),
                        ),
              ),
            );
          },
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
