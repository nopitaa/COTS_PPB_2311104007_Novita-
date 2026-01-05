import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/app_routes.dart';
import 'controllers/task_controller.dart';
import 'services/task_service.dart';
import 'design_system/app_colors.dart';

import 'presentation/pages/dashboard_page.dart';
import 'presentation/pages/task_list_page.dart';
import 'presentation/pages/task_detail_page.dart';
import 'presentation/pages/task_form_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TaskController(TaskService()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.bg,
      ),
      initialRoute: AppRoutes.dashboard,
      routes: {
        AppRoutes.dashboard: (_) => const DashboardPage(),
        AppRoutes.list: (_) => const TaskListPage(),
        AppRoutes.detail: (_) => TaskDetailPage(),
        AppRoutes.form: (_) => TaskFormPage(),
      },
    );
  }
}
