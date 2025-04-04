import 'package:flutter/material.dart';
import 'package:leaderboard_app/shared/colors.dart'; // Import color palette
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileUpdate extends StatefulWidget {
  final String studentId; // Accept studentId as a parameter

  const ProfileUpdate({super.key, required this.studentId});

  @override
  ProfileUpdateState createState() => ProfileUpdateState();
}

class ProfileUpdateState extends State<ProfileUpdate> {
  final _formKey = GlobalKey<FormState>();
  String profilePictureUrl = '';
  String bio = ''; // Add bio field
  bool _isSaving = false; // Add a flag for loading state
  bool _isLoading = true; // Add a flag for loading existing data

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // Load existing profile data
  }

  Future<void> _loadProfileData() async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('profiles')
              .doc(widget.studentId)
              .get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          profilePictureUrl = data['profilePictureUrl'] ?? '';
          bio = data['bio'] ?? '';
        });
      }
    } catch (e) {
      debugPrint('Error loading profile data: $e');
    } finally {
      setState(() {
        _isLoading = false; // Reset loading state
      });
    }
  }

  Future<void> _saveProfileData(
    String studentId,
    String? profilePictureUrl,
    String? bio,
  ) async {
    try {
      setState(() {
        _isSaving = true; // Set loading state to true
      });
      final Map<String, dynamic> updateData = {};
      if (profilePictureUrl != null && profilePictureUrl.isNotEmpty) {
        updateData['profilePictureUrl'] = profilePictureUrl;
      }
      if (bio != null && bio.isNotEmpty) {
        updateData['bio'] = bio;
      }
      if (updateData.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('profiles')
            .doc(studentId)
            .set(updateData, SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint('Error saving profile data: $e');
    } finally {
      setState(() {
        _isSaving = false; // Reset loading state
      });
    }
  }

  Future<void> _deleteProfileField(String studentId, String field) async {
    try {
      await FirebaseFirestore.instance
          .collection('profiles')
          .doc(studentId)
          .update({field: FieldValue.delete()});
    } catch (e) {
      debugPrint('Error deleting $field: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
        backgroundColor: AppColors.primaryAccentColor,
      ),
      backgroundColor: AppColors.primaryBgColor,
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(),
              ) // Show loading indicator
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Profile Picture URL',
                                labelStyle: TextStyle(
                                  color: AppColors.primaryTextColor,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.primaryAccentColor,
                                  ),
                                ),
                              ),
                              initialValue: profilePictureUrl,
                              onSaved:
                                  (value) => profilePictureUrl = value ?? '',
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: AppColors.primaryAccentColor,
                            ),
                            onPressed: () async {
                              await _deleteProfileField(
                                widget.studentId,
                                'profilePictureUrl',
                              );
                              setState(() {
                                profilePictureUrl = '';
                              });
                              if (mounted) {
                                Navigator.pop(
                                  context,
                                  true,
                                ); // Reload Profile screen
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Bio',
                                labelStyle: TextStyle(
                                  color: AppColors.primaryTextColor,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.primaryAccentColor,
                                  ),
                                ),
                              ),
                              initialValue: bio,
                              onSaved: (value) => bio = value ?? '',
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: AppColors.primaryAccentColor,
                            ),
                            onPressed: () async {
                              await _deleteProfileField(
                                widget.studentId,
                                'bio',
                              );
                              setState(() {
                                bio = '';
                              });
                              if (mounted) {
                                Navigator.pop(
                                  context,
                                  true,
                                ); // Reload Profile screen
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _isSaving
                          ? const Center(
                            child: CircularProgressIndicator(),
                          ) // Show saving indicator
                          : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryAccentColor,
                            ),
                            onPressed: () async {
                              _formKey.currentState?.save();
                              await _saveProfileData(
                                widget.studentId,
                                profilePictureUrl.isNotEmpty
                                    ? profilePictureUrl
                                    : null,
                                bio.isNotEmpty ? bio : null,
                              );
                              if (mounted) {
                                Navigator.pop(
                                  context,
                                  true,
                                ); // Pass true to reload profile
                              }
                            },
                            child: Text(
                              'Save',
                              style: TextStyle(
                                color: AppColors.secondaryTextColor,
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
