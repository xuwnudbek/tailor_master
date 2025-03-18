import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tailor_master/ui/order/provider/order_provider.dart';
import 'package:tailor_master/utils/theme/app_colors.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Consumer<OrderProvider>(
      builder: (context, provider, _) {
        return LayoutBuilder(builder: (context, constraints) {
          return RefreshIndicator(
            onRefresh: () async {
              provider.initialize();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: (provider.orders.isEmpty || provider.isLoading) ? 1 : provider.orders.length,
                itemExtent: (provider.orders.isEmpty || provider.isLoading) ? constraints.maxHeight : null,
                itemBuilder: (context, index) {
                  if (provider.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (provider.orders.isEmpty) {
                    return Center(
                      child: Text('Buyurtmalar topilmadi'),
                    );
                  }

                  final order = provider.orders[index];

                  String status = order['status'] == "printing"
                      ? "Chop etilmoqda"
                      : order['status'] == "cutting"
                          ? "Bichuvda"
                          : order['status'] == "tailoring"
                              ? "Tikuvda"
                              : order['status'] == "pending"
                                  ? "Kutilmoqda"
                                  : "Unknown";

                  final expansionController = provider.expansionControllers[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ExpansionTile(
                      controller: expansionController,
                      onExpansionChanged: (value) {
                        if (!value) {
                          expansionController.collapse();
                          return;
                        }

                        for (var controller in provider.expansionControllers) {
                          if (controller != expansionController) {
                            controller.collapse();
                          }
                        }

                        expansionController.expand();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: AppColors.light,
                      collapsedBackgroundColor: AppColors.light,
                      title: Text.rich(
                        TextSpan(
                          text: '#${order['id']}',
                          style: textTheme.titleLarge?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: ' / ${order['name']}',
                              style: textTheme.titleMedium?.copyWith(
                                color: AppColors.dark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      childrenPadding: EdgeInsets.all(16),
                      expandedAlignment: Alignment.centerLeft,
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // model
                        Row(
                          children: [
                            Text.rich(
                              TextSpan(
                                text: 'Model:',
                                style: textTheme.bodyMedium,
                                children: [
                                  TextSpan(
                                    text: ' ${order['orderModel']?['model']?['name'] ?? "Unknown"}',
                                    style: textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        // mato
                        Row(
                          children: [
                            Text.rich(
                              TextSpan(
                                text: 'Mato:',
                                style: textTheme.bodyMedium,
                                children: [
                                  TextSpan(
                                    text: ' ${order['orderModel']?['material']?['name'] ?? "Unknown"}',
                                    style: textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        // status
                        Row(
                          children: [
                            Text(
                              "Holat: ",
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: Text(
                                status,
                                style: textTheme.bodySmall?.copyWith(
                                  color: AppColors.light,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        // submodellar
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: 'Submodellar:',
                                    style: textTheme.bodyMedium,
                                  ),
                                ),
                                Wrap(
                                  spacing: 4,
                                  runSpacing: 4,
                                  children: [
                                    for (final submodel in order['orderModel']?['submodels'] ?? [])
                                      Chip(
                                        padding: EdgeInsets.all(4),
                                        backgroundColor: AppColors.primary,
                                        label: Text(
                                          submodel?['submodel']?['name'] ?? 'Unknown',
                                          style: textTheme.bodyMedium?.copyWith(
                                            color: AppColors.light,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        // o'lchamlar
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: 'O\'lchamlar:',
                                    style: textTheme.bodyMedium,
                                  ),
                                ),
                                Wrap(
                                  spacing: 4,
                                  runSpacing: 4,
                                  children: [
                                    for (final size in order['orderModel']?['sizes'] ?? [])
                                      Chip(
                                        padding: EdgeInsets.all(4),
                                        backgroundColor: AppColors.primary,
                                        label: Text.rich(
                                          TextSpan(
                                            text: size?['size']?['name'] ?? 'Unknown',
                                            style: textTheme.bodyMedium?.copyWith(
                                              color: AppColors.light,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: ' - ${size['quantity']} ta',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        // izoh
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: 'Izoh:',
                                    style: textTheme.bodyMedium,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Container(
                                  width: constraints.maxWidth * 0.8,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    order['comment'] ?? 'Izohsiz',
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: AppColors.light,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        // instruksiyalar
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: 'Instruksiyalar:',
                                    style: textTheme.bodyMedium,
                                  ),
                                ),
                                SizedBox(height: 4),
                                SizedBox(
                                  width: constraints.maxWidth - 48,
                                  child: Table(
                                    border: TableBorder.all(
                                      borderRadius: BorderRadius.circular(4),
                                      color: AppColors.dark.withValues(alpha: 0.3),
                                    ),
                                    columnWidths: {
                                      0: FlexColumnWidth(2),
                                      1: FlexColumnWidth(3),
                                    },
                                    children: [
                                      for (final instruction in order['instructions'] ?? [])
                                        TableRow(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                instruction['title'] ?? 'Unknown',
                                                style: textTheme.titleSmall,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                instruction['description'] ?? 'Unknown',
                                                style: textTheme.bodyMedium,
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        });
      },
    );
  }
}
