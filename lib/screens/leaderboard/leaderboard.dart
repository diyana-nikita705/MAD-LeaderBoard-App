import 'package:flutter/material.dart';
import 'package:leaderboard_app/shared/colors.dart'; // Import AppColors

class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBgColor, // Set background color
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rankings',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryAccentColor, // Set text color
                        fontSize: 20.0, // Increase font size
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      labelText: 'Section',
                                      border: OutlineInputBorder(),
                                    ),
                                    items:
                                        ['A', 'B', 'C']
                                            .map(
                                              (section) => DropdownMenuItem(
                                                value: section,
                                                child: Text(section),
                                              ),
                                            )
                                            .toList(),
                                    onChanged: (value) {
                                      // Handle section selection
                                    },
                                  ),
                                  SizedBox(height: 16.0),
                                  DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      labelText: 'Department',
                                      border: OutlineInputBorder(),
                                    ),
                                    items:
                                        ['CSE', 'EEE', 'BBA']
                                            .map(
                                              (department) => DropdownMenuItem(
                                                value: department,
                                                child: Text(department),
                                              ),
                                            )
                                            .toList(),
                                    onChanged: (value) {
                                      // Handle department selection
                                    },
                                  ),
                                  SizedBox(height: 16.0),
                                  DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      labelText: 'Batch',
                                      border: OutlineInputBorder(),
                                    ),
                                    items:
                                        ['2020', '2021', '2022']
                                            .map(
                                              (batch) => DropdownMenuItem(
                                                value: batch,
                                                child: Text(batch),
                                              ),
                                            )
                                            .toList(),
                                    onChanged: (value) {
                                      // Handle batch selection
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Icons.filter_list,
                        color: AppColors.secondaryTextColor, // Set icon color
                      ),
                      label: Text(
                        'Filter',
                        style: TextStyle(
                          color: AppColors.secondaryTextColor,
                        ), // Set text color
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.secondaryAccentColor, // Set button color
                      ),
                    ),
                  ],
                ),
              ),
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
                        child: DataTable(
                          columnSpacing: 16.0, // Adjust spacing between columns
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
                              label: Text(
                                'Rank',
                                style: TextStyle(
                                  color: Colors.white, // Set text color
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                // Stretch Name column
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
                              label: Text(
                                'CGPA',
                                style: TextStyle(
                                  color: Colors.white, // Set text color
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                          rows: [
                            DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    '1',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ), // Set text color
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    'Anzir Rahman Khan',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ), // Set text color
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '3.99',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ), // Set text color
                                  ),
                                ),
                              ],
                            ),
                            DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    '2',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ), // Set text color
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    'Bob',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ), // Set text color
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '3.8',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ), // Set text color
                                  ),
                                ),
                              ],
                            ),
                            DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    '3',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ), // Set text color
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    'Charlie',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ), // Set text color
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '3.7',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ), // Set text color
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(8.0),
              color:
                  AppColors
                      .tertiaryColor, // Set background color to tertiary color
              child: TextField(
                textAlign: TextAlign.left, // Align text to the left
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 10.0, // Add padding at the start
                  ),
                  hintText: 'Search by Student ID',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      // Handle search button click logic here
                    },
                  ),
                  border: InputBorder.none, // Remove border line
                ),
                onChanged: (value) {
                  // Handle search logic here
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
