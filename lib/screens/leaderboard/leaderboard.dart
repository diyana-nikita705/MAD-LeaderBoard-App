import 'package:flutter/material.dart';
import 'package:leaderboard_app/shared/colors.dart'; // Import AppColors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leaderboard_app/models/students.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leaderboard_app/providers/auth_provider.dart';

class Leaderboard extends ConsumerWidget {
  const Leaderboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return Center(
            child: Text(
              'Please log in to access the leaderboard.',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          );
        }
        return const _LeaderboardContent();
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }
}

class _LeaderboardContent extends StatefulWidget {
  const _LeaderboardContent();

  @override
  State<_LeaderboardContent> createState() => _LeaderboardContentState();
}

class _LeaderboardContentState extends State<_LeaderboardContent> {
  final StudentService _studentService = StudentService();
  final List<Student> _students = [];
  DocumentSnapshot? _lastDoc;
  bool _isLoading = false;

  String? _selectedDepartment;
  int? _selectedBatch;
  String? _selectedSection;

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents({bool reset = false}) async {
    if (_isLoading) return;
    if (reset) {
      setState(() {
        _students.clear();
        _lastDoc = null;
      });
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final newStudents = await _studentService.fetchStudentsPaginated(
        20, // Load 20 students instead of 10
        lastDoc: _lastDoc,
        department: _selectedDepartment,
        batch: _selectedBatch,
        section: _selectedSection,
      );
      setState(() {
        _students.addAll(newStudents);
        if (newStudents.isNotEmpty) {
          _lastDoc = newStudents.last.doc; // Correctly update _lastDoc
        }
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filter Options',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Department'),
                    value: _selectedDepartment,
                    items:
                        ['CSE', 'EEE', 'NFE']
                            .map(
                              (dept) => DropdownMenuItem(
                                value: dept,
                                child: Text(dept),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      _selectedDepartment = value;
                    },
                  ),
                  SizedBox(height: 8.0),
                  DropdownButtonFormField<int>(
                    decoration: InputDecoration(labelText: 'Batch'),
                    value: _selectedBatch,
                    items:
                        [221, 222, 223] // Batch numbers remain as integers
                            .map(
                              (batch) => DropdownMenuItem(
                                value: batch,
                                child: Text(
                                  batch.toString(),
                                ), // Display batch as string
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      _selectedBatch = value;
                    },
                  ),
                  SizedBox(height: 8.0),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Section'),
                    value: _selectedSection,
                    items:
                        List.generate(
                              16,
                              (index) => String.fromCharCode(
                                65 + index,
                              ), // Generate sections A to P
                            )
                            .map(
                              (section) => DropdownMenuItem(
                                value: section,
                                child: Text(section),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSection =
                            value?.toUpperCase(); // Normalize to uppercase
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedDepartment = null;
                            _selectedBatch = null;
                            _selectedSection = null;
                          });
                          Navigator.pop(context);
                          _fetchStudents(
                            reset: true,
                          ); // Refetch the list without filters
                        },
                        child: Text('Clear Filters'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _fetchStudents(
                            reset: true,
                          ); // Refetch the list with filters
                        },
                        child: Text('Apply Filters'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBgColor, // Set background color
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter, // Align the table to the top
                  child: Padding(
                    padding: EdgeInsets.zero, // Remove padding
                    child: SingleChildScrollView(
                      scrollDirection:
                          Axis.horizontal, // Enable horizontal scrolling
                      child: SizedBox(
                        width:
                            MediaQuery.of(
                              context,
                            ).size.width, // Stretch to full width
                        child: SingleChildScrollView(
                          scrollDirection:
                              Axis.vertical, // Enable vertical scrolling
                          child: DataTable(
                            columnSpacing:
                                16.0, // Adjust spacing between columns
                            headingRowColor: WidgetStateProperty.all(
                              AppColors
                                  .secondaryAccentColor, // Set heading row color
                            ),
                            dataRowColor: WidgetStateProperty.all(
                              AppColors
                                  .primaryBgColor, // Set data row background color
                            ),
                            columns: const [
                              DataColumn(
                                label: Padding(
                                  padding: EdgeInsets.only(
                                    left: 8.0,
                                  ), // Add left padding
                                  child: Text(
                                    'Rank',
                                    style: TextStyle(
                                      color: Colors.white, // Set text color
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Padding(
                                  padding: EdgeInsets.only(
                                    left: 16.0,
                                  ), // Increase left padding for Name
                                  child: Text(
                                    'Name',
                                    style: TextStyle(
                                      color: Colors.white, // Set text color
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Padding(
                                  padding: EdgeInsets.only(
                                    left: 8.0,
                                  ), // Add left padding
                                  child: Text(
                                    'CGPA',
                                    style: TextStyle(
                                      color: Colors.white, // Set text color
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            rows:
                                _students.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final student = entry.value;
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 16.0,
                                          ), // Increase left padding
                                          child: Text(
                                            '${index + 1}',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 16.0,
                                          ), // Increase left padding
                                          child: InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                builder: (context) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          16.0,
                                                        ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Details for ${student.name}',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18.0,
                                                          ),
                                                        ),
                                                        SizedBox(height: 8.0),
                                                        Text(
                                                          'ID: ${student.id}',
                                                        ),
                                                        Text(
                                                          'Department: ${student.department}',
                                                        ),
                                                        Text(
                                                          'Batch: ${student.batch}',
                                                        ),
                                                        Text(
                                                          'Section: ${student.section}',
                                                        ),
                                                        Text(
                                                          'Result: ${student.result}',
                                                        ),
                                                        Text(
                                                          'Achievements: ${student.achievement}',
                                                        ),
                                                        Text(
                                                          'Extracurricular: ${student.extracurricular}',
                                                        ),
                                                        Text(
                                                          'Co-curriculum: ${student.coCurriculum}',
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Text(
                                              student.name,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 16.0,
                                          ), // Increase left padding
                                          child: Text(
                                            student.result.toString(),
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (_isLoading)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 64, // Slightly increase space between buttons
            right: 16, // Align to the right
            child: SizedBox(
              width: 100, // Same width as "Load More"
              height: 40, // Same height as "Load More"
              child: FloatingActionButton(
                onPressed: _showFilterOptions, // Open filter options
                backgroundColor: Colors.white.withAlpha(240), // 50% opacity
                elevation: 0, // Remove shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Keep edges rounded
                  side: BorderSide(
                    color: AppColors.secondaryAccentColor, // Add border
                  ),
                ),
                child: Icon(
                  Icons.filter_list, // Filter icon
                  color: AppColors.secondaryAccentColor, // Icon color
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: SizedBox(
              width: 100, // Reduce width
              height: 40, // Reduce height
              child: FloatingActionButton(
                onPressed: _fetchStudents,
                backgroundColor: Colors.white.withAlpha(240), // 50% opacity
                elevation: 0, // Remove shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Keep edges rounded
                  side: BorderSide(
                    color: AppColors.secondaryAccentColor, // Add border
                  ),
                ),
                child: Text(
                  'Load More',
                  style: TextStyle(
                    color: AppColors.secondaryAccentColor, // Set text color
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
