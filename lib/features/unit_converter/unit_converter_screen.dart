import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toolmint/core/theme.dart';
import 'package:toolmint/features/unit_converter/unit_converter_provider.dart';
import 'package:toolmint/shared/widgets/glass_card.dart';

class UnitConverterScreen extends ConsumerStatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  ConsumerState<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends ConsumerState<UnitConverterScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(unitConverterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Unit Converter'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildCategorySelector(context, state),
            const SizedBox(height: 32),
            _buildConverterCard(context, state),
            const SizedBox(height: 32),
            _buildResultCard(context, state),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector(BuildContext context, UnitConverterState state) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: UnitCategory.values.map((cat) {
          final isSelected = state.category == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(cat.name.toUpperCase()),
              selected: isSelected,
              onSelected: (_) => ref.read(unitConverterProvider.notifier).setCategory(cat),
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? AppTheme.primaryColor : Colors.white54,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              backgroundColor: Colors.white.withOpacity(0.05),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected ? AppTheme.primaryColor : Colors.white10,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildConverterCard(BuildContext context, UnitConverterState state) {
    List<String> units = [];
    if (state.category == UnitCategory.length) {
      units = ['Meters', 'Kilometers', 'Feet', 'Inches'];
    } else if (state.category == UnitCategory.weight) {
      units = ['Grams', 'Kilograms', 'Pounds'];
    } else {
      units = ['Celsius', 'Fahrenheit'];
    }

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('FROM', style: TextStyle(color: Colors.white38, fontSize: 12)),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '0.00',
                  ),
                  onChanged: (val) {
                    final d = double.tryParse(val) ?? 0;
                    ref.read(unitConverterProvider.notifier).convert(d);
                  },
                ),
              ),
              DropdownButton<String>(
                value: state.fromUnit,
                items: units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                onChanged: (val) => ref.read(unitConverterProvider.notifier).setFromUnit(val!),
                underline: const SizedBox(),
                dropdownColor: AppTheme.cardColor,
              ),
            ],
          ),
          const Divider(color: Colors.white10, height: 32),
          const Text('TO', style: TextStyle(color: Colors.white38, fontSize: 12)),
          Row(
            children: [
              Expanded(
                child: Text(
                  state.toValue.toStringAsFixed(4),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                ),
              ),
              DropdownButton<String>(
                value: state.toUnit,
                items: units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                onChanged: (val) => ref.read(unitConverterProvider.notifier).setToUnit(val!),
                underline: const SizedBox(),
                dropdownColor: AppTheme.cardColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, UnitConverterState state) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, color: AppTheme.primaryColor.withOpacity(0.5), size: 20),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              '${state.fromValue} ${state.fromUnit} = ${state.toValue.toStringAsFixed(4)} ${state.toUnit}',
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
