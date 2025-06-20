import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:cocteles_app/features/stats/controllers/StatsController.dart';
class UserStatsPage extends StatelessWidget {
  UserStatsPage({Key? key}) : super(key: key);

  final StatsController controller = Get.find<StatsController>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;
    final crossAxisCount = isWideScreen ? 2 : 1;
    final childAspectRatio = isWideScreen ? 1.4 : 0.9;

    return Scaffold(
      appBar: AppBar(title: const Text('Estadísticas'), automaticallyImplyLeading: false),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: GridView.count(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: childAspectRatio,
            children: [
              _buildUserStatsCard(context),
              _buildAlcoholPieCard(context),
              _buildTopUsersCard(context),
              _buildTopLikedRecipesCard(context),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildUserStatsCard(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final chartHeight = screenWidth < 600 ? 200.0 : 300.0;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Usuarios registrados por mes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            if (controller.stats.isEmpty)
              const Center(child: Text('No hay datos de estadísticas.'))
            else
              SizedBox(
                height: chartHeight,
                child: BarChart(
                  BarChartData(
                    barGroups: controller.stats.asMap().entries.map((entry) {
                      return BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value.total.toDouble(),
                            color: Colors.teal,
                            width: 18,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ],
                      );
                    }).toList(),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      bottomTitles: AxisTitles(
  sideTitles: SideTitles(
    showTitles: true,
    reservedSize: 30, // más espacio para texto
    getTitlesWidget: (value, meta) {
      int index = value.toInt();
      if (index >= controller.stats.length) return const SizedBox.shrink();
      final month = controller.stats[index].mes.substring(5);
      final monthNames = {
        '01': 'ENE', '02': 'FEB', '03': 'MAR', '04': 'ABR',
        '05': 'MAY', '06': 'JUN', '07': 'JUL', '08': 'AGO',
        '09': 'SEP', '10': 'OCT', '11': 'NOV', '12': 'DIC',
      };
       return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Text(monthNames[month] ?? month),
      );
    },
  ),
),

                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

Widget _buildAlcoholPieCard(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final pieHeight = screenWidth < 600 ? 320.0 : 380.0;

  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Alcoholes más populares',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (controller.alcoholStats.isEmpty)
            const Center(child: Text("No hay datos disponibles."))
          else
            Column(
              children: [
                SizedBox(
                  height: 220,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: _buildPieSections(controller),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: _buildLegend(controller),
                ),
              ],
            ),
        ],
      ),
    ),
  );
}


  Widget _buildTopUsersCard(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final boxHeight = screenWidth < 600 ? 200.0 : 280.0;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Top usuarios por recetas creadas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            if (controller.topUsers.isEmpty)
              const Center(child: Text("No hay datos disponibles."))
            else
              SizedBox(
                height: boxHeight,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.topUsers.length,
                  itemBuilder: (context, index) {
                    final user = controller.topUsers[index];
                    final max = controller.topUsers.first.recetasCreadas;
                    final ratio = max > 0 ? user.recetasCreadas / max : 0.0;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(
                              user.author.username,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: ratio,
                              minHeight: 18,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text('${user.recetasCreadas}'),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopLikedRecipesCard(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final boxHeight = screenWidth < 600 ? 200.0 : 280.0;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Recetas con más likes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            if (controller.topLikedRecipes.isEmpty)
              const Center(child: Text("No hay recetas con likes aún."))
            else
              SizedBox(
                height: boxHeight,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.topLikedRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = controller.topLikedRecipes[index];
                    final max = controller.topLikedRecipes.first.totalLikes;
                    final ratio = max > 0 ? recipe.totalLikes / max : 0.0;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recipe.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'por ${recipe.authorUsername}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 3,
                            child: LinearProgressIndicator(
                              value: ratio,
                              minHeight: 18,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text('${recipe.totalLikes} ❤️'),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieSections(StatsController controller) {
    final total = controller.alcoholStats.fold<int>(0, (sum, item) => sum + item.total);

    final List<Color> colors = [
      Colors.teal,
      Colors.deepOrange,
      Colors.indigo,
      Colors.pink,
      Colors.green,
      Colors.amber,
      Colors.blueGrey,
    ];

    return controller.alcoholStats.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final percentage = ((data.total / total) * 100).toStringAsFixed(1);

      return PieChartSectionData(
  color: colors[index % colors.length],
  value: data.total.toDouble(),
  title: "$percentage%",
  radius: 70,
  titlePositionPercentageOffset: 0.55, 
  titleStyle: const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
);

    }).toList();
  }

 List<Widget> _buildLegend(StatsController controller) {
  final List<Color> colors = [
    Colors.teal,
    Colors.deepOrange,
    Colors.indigo,
    Colors.pink,
    Colors.green,
    Colors.amber,
    Colors.blueGrey,
  ];

  return controller.alcoholStats.asMap().entries.map((entry) {
    final index = entry.key;
    final alcohol = entry.value;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: colors[index % colors.length],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            alcohol.alcoholType,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }).toList();
}
}