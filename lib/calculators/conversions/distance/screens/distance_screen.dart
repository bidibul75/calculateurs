// lib/calculators/conversions/distance/screens/distance_screen.dart

import 'package:calculators/calculators/conversions/distance/controllers/distance_controller.dart';
import 'package:calculators/calculators/conversions/distance/models/distance_state.dart';
import 'package:calculators/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DistanceScreen extends StatelessWidget {
  const DistanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ChangeNotifierProvider(
      create: (_) => DistanceController(),
      child: Consumer<DistanceController>(
        builder: (context, controller, _) {
          final state = controller.state;

          return Scaffold(
            appBar: AppBar(title: Text(l10n.distanceTitle)),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Système métrique
                  _buildUnitSection(
                    context,
                    label: l10n.distanceLabelMetric,
                    value: state.metricValue,
                    unit: state.metricUnit,
                    units: const [DistanceUnit.km, DistanceUnit.m, DistanceUnit.cm, DistanceUnit.mm],
                    onValueChanged: (val) => controller.updateMetric(val, state.metricUnit),
                    onUnitChanged: controller.changeMetricUnit,
                    l10n: l10n,
                  ),
                  const SizedBox(height: 24),

                  // Système impérial
                  _buildUnitSection(
                    context,
                    label: l10n.distanceLabelImperial,
                    value: state.imperialValue,
                    unit: state.imperialUnit,
                    units: const [DistanceUnit.mi,
                    DistanceUnit.yd,
                    DistanceUnit.ft,
                    DistanceUnit.inch],
                    onValueChanged: (val) => controller.updateImperial(val, state.imperialUnit),
                    onUnitChanged: controller.changeImperialUnit,
                    l10n: l10n,
                  ),
                  const SizedBox(height: 24),

                  // Mille nautique
                  _buildSimpleField(
                    context,
                    label: l10n.distanceLabelNautical,
                    value: state.nauticalValue,
                    onChanged: controller.updateNautical,
                    unitLabel: l10n.distanceUnitNmi,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUnitSection(BuildContext context, {
    required String label,
    required String value,
    required DistanceUnit unit,
    required List<DistanceUnit> units,
    required Function(String) onValueChanged,
    required Function(DistanceUnit) onUnitChanged,
    required AppLocalizations l10n,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme
                .of(context)
                .textTheme
                .titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: TextEditingController(text: value),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    onChanged: onValueChanged,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<DistanceUnit>(
                    initialValue: unit,
                    items: units
                        .map((u) =>
                        DropdownMenuItem(
                          value: u,
                          child: Text(_unitToLabel(u, l10n)),
                        ))
                        .toList(),
                    onChanged: (newUnit) {
                      if (newUnit != null) {
                        onUnitChanged(newUnit);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleField(BuildContext context, {
    required String label,
    required String value,
    required Function(String) onChanged,
    required String unitLabel,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme
                .of(context)
                .textTheme
                .titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: value),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    onChanged: onChanged,
                  ),
                ),
                const SizedBox(width: 12),
                Text(unitLabel, style: Theme
                    .of(context)
                    .textTheme
                    .titleMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _unitToLabel(DistanceUnit unit, AppLocalizations l10n) {
    switch (unit) {
    case DistanceUnit.km: return l10n.distanceUnitKm;
    case DistanceUnit.m: return l10n.distanceUnitM;
    case DistanceUnit.cm: return l10n.distanceUnitCm;
    case DistanceUnit.mm: return l10n.distanceUnitMm;
    case DistanceUnit.mi: return l10n.distanceUnitMi;
    case DistanceUnit.yd: return l10n.distanceUnitYd;
    case DistanceUnit.ft: return l10n.distanceUnitFt;
    case DistanceUnit.inch: return l10n.distanceUnitInch;
    case DistanceUnit.nmi: return l10n.distanceUnitNmi;
    }
  }
}
