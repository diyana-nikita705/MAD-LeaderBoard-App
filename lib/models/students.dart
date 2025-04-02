import 'package:cloud_firestore/cloud_firestore.dart';

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
