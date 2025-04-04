import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Student {
  final String id;
  final String name;
  final String department;
  final int batch;
  final String section;
  final double result;
  final int achievement;
  final String extracurricular;
  final String coCurriculum;
  final DocumentSnapshot doc; // Add reference to the original DocumentSnapshot

  Student({
    required this.id,
    required this.name,
    required this.department,
    required this.batch,
    required this.section,
    required this.result,
    required this.achievement,
    required this.extracurricular,
    required this.coCurriculum,
    required this.doc, // Initialize the new field
  });

  factory Student.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Student(
      id: doc.id,
      name: data['Name'] ?? '',
      department: data['Department'] ?? '',
      batch: data['Batch'] ?? 0,
      section: data['Section'] ?? '',
      result: (data['Result'] ?? 0.0).toDouble(),
      achievement: data['Achievement'] ?? 0,
      extracurricular: data['Extracurricular'] ?? 'No',
      coCurriculum: data['Co-curriculum'] ?? 'No',
      doc: doc, // Pass the DocumentSnapshot
    );
  }
}

class StudentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Student>> fetchStudents() {
    return _firestore.collection('students').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Student.fromFirestore(doc)).toList();
    });
  }

  Future<Student?> fetchStudentById(String id) async {
    final doc = await _firestore.collection('students').doc(id).get();
    if (doc.exists) {
      return Student.fromFirestore(doc);
    } else {
      throw Exception("Student not found");
    }
  }

  Future<List<Student>> fetchStudentsPaginated(
    int limit, {
    DocumentSnapshot? lastDoc,
    String? department,
    int? batch,
    String? section,
  }) async {
    Query query = _firestore
        .collection('students')
        .orderBy('Result', descending: true)
        .limit(limit); // Limit remains dynamic, passed as 20 from the caller

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    if (department != null) {
      query = query.where('Department', isEqualTo: department);
    }
    if (batch != null) {
      query = query.where('Batch', isEqualTo: batch);
    }
    if (section != null && section.isNotEmpty) {
      query = query.where('Section', isEqualTo: section.toUpperCase());
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => Student.fromFirestore(doc)).toList();
  }
}

class StudentNotifier extends StateNotifier<Student?> {
  StudentNotifier() : super(null);

  void setStudent(Student student) {
    state = student;
  }

  void clearStudent() {
    state = null;
  }
}

final studentProvider = StateNotifierProvider<StudentNotifier, Student?>(
  (ref) => StudentNotifier(),
);

class LeaderboardNotifier extends StateNotifier<Map<String, dynamic>> {
  LeaderboardNotifier() : super({'filteredStudents': [], 'currentRank': null});

  void updateLeaderboard(List<Student> filteredStudents, String? studentId) {
    state = {
      'filteredStudents': filteredStudents,
      'currentRank': _calculateRank(filteredStudents, studentId),
    };
  }

  int? _calculateRank(List<Student> students, String? studentId) {
    if (studentId == null) return null;
    final rank = students.indexWhere((student) => student.id == studentId);
    return rank != -1
        ? rank + 1
        : null; // Convert 0-based index to 1-based rank
  }
}

final leaderboardProvider =
    StateNotifierProvider<LeaderboardNotifier, Map<String, dynamic>>(
      (ref) => LeaderboardNotifier(),
    );
