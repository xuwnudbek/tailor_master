import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tailor_master/ui/fastening/provider/fastening_provider.dart';
import 'package:tailor_master/utils/theme/app_colors.dart';
import 'package:tailor_master/utils/widgets/custom_dropdown.dart';

class FasteningPage extends StatelessWidget {
  const FasteningPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Consumer<FasteningProvider>(builder: (context, provider, _) {
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

                // String status = order['status'] == "printing"
                //     ? "Chop etilmoqda"
                //     : order['status'] == "cutting"
                //         ? "Bichuvda"
                //         : order['status'] == "tailoring"
                //             ? "Tikuvda"
                //             : order['status'] == "pending"
                //                 ? "Kutilmoqda"
                //                 : "Unknown";

                final expansionController = provider.expansionControllers[index];
                List submodels = order['orderModel']?['submodels'] ?? [];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ExpansionTile(
                    controller: expansionController,
                    onExpansionChanged: (value) async {
                      if (!value) {
                        expansionController.collapse();
                        return;
                      }

                      for (var controller in provider.expansionControllers) {
                        if (controller != expansionController) {
                          controller.collapse();
                        }
                      }

                      provider.prepareFasteningGroups(submodels);
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
                    childrenPadding: EdgeInsets.all(12),
                    expandedAlignment: Alignment.centerLeft,
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // submodellar
                      Table(
                        border: TableBorder.all(
                          borderRadius: BorderRadius.circular(4),
                          color: AppColors.dark.withValues(alpha: 0.3),
                        ),
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        columnWidths: {
                          0: FlexColumnWidth(3),
                          1: FlexColumnWidth(2),
                        },
                        children: [
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                                child: Text(
                                  'Submodellar',
                                  style: textTheme.titleMedium?.copyWith(
                                    color: AppColors.dark,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    'Guruhlar',
                                    style: textTheme.titleMedium?.copyWith(
                                      color: AppColors.dark,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ...submodels.map((submodel) {
                            Map group = provider.fasteningGroups[submodel['id']] ?? {};

                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                                  child: Text(
                                    submodel['submodel']?['name'] ?? "Unknown",
                                    style: textTheme.titleSmall?.copyWith(
                                      color: AppColors.dark,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: CustomDropdown(
                                    color: AppColors.light,
                                    hint: "Guruh",
                                    value: group['id'],
                                    items: provider.groups.map((group) {
                                      bool beforeUsed = provider.fasteningGroups.values.any((value) => value?['id'] == group['id']);

                                      return DropdownMenuItem(
                                        value: group['id'],
                                        enabled: !beforeUsed,
                                        child: Text(
                                          group?['name'] ?? "Unknown",
                                          style: textTheme.titleSmall?.copyWith(
                                            color: beforeUsed ? AppColors.dark.withValues(alpha: 0.7) : AppColors.dark,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (groupId) {
                                      provider.onSelectGroup(submodel['id'], groupId);
                                    },
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                      SizedBox(height: 16),
                      // tugmalar
                      TextButton(
                        onPressed: () async {
                          if (provider.isUpdating) return;
                          await provider.updateFasteningGroups(context, order['id']);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (provider.isUpdating)
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(AppColors.light),
                              )
                            else
                              Text(
                                'Saqlash',
                                style: textTheme.titleMedium?.copyWith(
                                  color: AppColors.light,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      });
    });
  }
}
