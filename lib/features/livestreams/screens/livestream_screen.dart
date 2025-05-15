import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LivestreamScreen extends StatelessWidget {
  const LivestreamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Livestream'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 600) {
            return _buildDesktopLayout();
          } else {
            return _buildMobileLayout();
          }
        },
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Center(child: Text('Desktop Layout'));
  }

  Widget _buildMobileLayout() {
    return Center(child: Text('Mobile Layout'));
  }
}
