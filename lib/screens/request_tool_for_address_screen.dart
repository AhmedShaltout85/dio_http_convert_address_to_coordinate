// ignore_for_file: unnecessary_type_check

import 'package:flutter/material.dart';
import '../network/remote/dio_network_repos.dart';

class RequestToolForAddressScreen extends StatefulWidget {
  final String address;
  final String handasahName;

  const RequestToolForAddressScreen({
    super.key,
    required this.address,
    required this.handasahName,
  });

  @override
  State<RequestToolForAddressScreen> createState() =>
      _RequestToolForAddressState();
}

class _RequestToolForAddressState extends State<RequestToolForAddressScreen> {
  late Future<List<dynamic>> getToolsForAddressInHandasah;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserRequestForAddress();
  }

  Future<void> _fetchUserRequestForAddress() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Ensure the network call returns a Future<List<dynamic>>
      final response = await DioNetworkRepos()
          .getHandasahToolsByAddressAndHandasahAndRequestStatus(
              widget.address, widget.handasahName, 1);

      // Convert the response to List if it's not already
      final List<dynamic> toolsList = response is List ? response : [response];

      setState(() {
        getToolsForAddressInHandasah = Future.value(toolsList);
        _isLoading = false;
      });

      debugPrint("Fetched tools: ${toolsList.length} items");
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
      debugPrint("Error fetching tools: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "طلب المهمات لعنوان: ${widget.address}",
          style: const TextStyle(
            color: Colors.indigo,
          ),
        ),
        centerTitle: true,
        elevation: 7,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.indigo,
          size: 17,
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text("Error: $_errorMessage"));
    }

    return Row(
      children: [
        const Expanded(flex: 1, child: SizedBox()),
        Expanded(
          flex: 2,
          child: FutureBuilder<List<dynamic>>(
            future: getToolsForAddressInHandasah,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No tools available"));
              }

              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final item = snapshot.data![index] as Map<String, dynamic>;
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                  widget.handasahName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo,
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Text(
                                  'اسم الهندسة : ',
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                  item['toolName']?.toString() ??
                                      'Default Tool',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo,
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Text(
                                  'اسم المهمة: ',
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                  item['techName']?.toString() ??
                                      'Default user',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo,
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Text(
                                  'أسم الفنى :',
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                  ' ${item['toolQty']?.toString() ?? 'N/A'}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo,
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Text(
                                  'العدد: ',
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        const Expanded(flex: 1, child: SizedBox()),
      ],
    );
  }
}
