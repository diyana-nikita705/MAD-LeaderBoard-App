import 'package:flutter/material.dart';
import 'package:leaderboard_app/shared/colors.dart'; // Import color palette

class ProfileUpdate extends StatefulWidget {
  const ProfileUpdate({super.key});

  @override
  ProfileUpdateState createState() => ProfileUpdateState();
}

class ProfileUpdateState extends State<ProfileUpdate> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String profilePictureUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
        backgroundColor: AppColors.primaryAccentColor,
      ),
      backgroundColor: AppColors.primaryBgColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: AppColors.primaryTextColor),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryAccentColor),
                  ),
                ),
                initialValue: email,
                onSaved: (value) => email = value ?? '',
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter your email'
                            : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: AppColors.primaryTextColor),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryAccentColor),
                  ),
                ),
                obscureText: true,
                onSaved: (value) => password = value ?? '',
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter your password'
                            : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Profile Picture URL',
                  labelStyle: TextStyle(color: AppColors.primaryTextColor),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryAccentColor),
                  ),
                ),
                initialValue: profilePictureUrl,
                onSaved: (value) => profilePictureUrl = value ?? '',
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter your profile picture URL'
                            : null,
              ),
              SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryAccentColor,
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    // Handle save logic here
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  'Save',
                  style: TextStyle(color: AppColors.secondaryTextColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
