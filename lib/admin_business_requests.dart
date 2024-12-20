import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminBusinessRequests extends StatelessWidget {
  const AdminBusinessRequests({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Requests', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('business profile requests')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final requests = snapshot.data?.docs ?? [];
          
          if (requests.isEmpty) {
            return const Center(child: Text('No pending requests'));
          }

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index].data() as Map<String, dynamic>;
              
              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              request['store/brandName'] ?? 'Unknown Store',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          PopupMenuButton<String>(
                            onSelected: (value) => _handleAction(value, request, requests[index].id),
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'approve',
                                child: Text('Approve'),
                              ),
                              const PopupMenuItem(
                                value: 'reject',
                                child: Text('Reject'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Contact: ${request['contact'] ?? 'N/A'}'),
                      Text('Location: ${request['location'] ?? 'N/A'}'),
                      Text('Website: ${request['website'] ?? 'N/A'}'),
                      if (request['storeLogo'] != null) ...[
                        const SizedBox(height: 8),
                        Image.network(
                          request['storeLogo'],
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _handleAction(String action, Map<String, dynamic> request, String docId) async {
    try {
      if (action == 'approve') {
        // Add to brands collection
        await FirebaseFirestore.instance
            .collection('brand')
            .doc(request['store/brandName'])
            .set({
          'brand_name': request['store/brandName'],
          'contact': request['contact'],
          'location': request['location'],
          'website': request['website'],
          'logo': request['storeLogo'],
          'image': request['storeLogo'],
          'brandId': docId,
        });

        // Update user role
        await FirebaseFirestore.instance
            .collection('users')
            .doc(request['email'])
            .update({
          'role': 'vendorAdmin',
          'adminrole': request['store/brandName'],
        });

        // Delete request
        await FirebaseFirestore.instance
            .collection('business profile requests')
            .doc(docId)
            .delete();

        Get.snackbar(
          'Success',
          'Business profile approved',
          backgroundColor: Colors.green.withOpacity(0.3),
        );
      } else if (action == 'reject') {
        // Delete request
        await FirebaseFirestore.instance
            .collection('business profile requests')
            .doc(docId)
            .delete();

        Get.snackbar(
          'Rejected',
          'Business profile request rejected',
          backgroundColor: Colors.red.withOpacity(0.3),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red.withOpacity(0.3),
      );
    }
  }
}