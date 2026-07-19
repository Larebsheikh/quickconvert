import 'package:flutter/material.dart';
import '../data/unit_data.dart';
import '../models/conversion_category.dart';
import '../theme.dart';
import '../widgets/category_chip_bar.dart';
import '../widgets/result_card.dart';
import '../widgets/swap_button.dart';
import '../widgets/unit_dropdown.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final TextEditingController _inputController = TextEditingController(text: '1');

  int _categoryIndex = 0;
  late String _fromUnit;
  late String _toUnit;
  double? _result;
  bool _hasInputError = false;

  @override
  void initState() {
    super.initState();
    final units = conversionCategories[_categoryIndex].unitNames;
    _fromUnit = units[0];
    _toUnit = units.length > 1 ? units[1] : units[0];
    _convert();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _onCategoryChanged(int index) {
    final units = conversionCategories[index].unitNames;
    setState(() {
      _categoryIndex = index;
      _fromUnit = units[0];
      _toUnit = units.length > 1 ? units[1] : units[0];
    });
    _convert();
  }

  void _swapUnits() {
    setState(() {
      final temp = _fromUnit;
      _fromUnit = _toUnit;
      _toUnit = temp;
    });
    _convert();
  }

  void _convert() {
    final value = double.tryParse(_inputController.text.trim());
    if (value == null) {
      setState(() {
        _hasInputError = _inputController.text.trim().isNotEmpty;
        _result = null;
      });
      return;
    }
    final category = conversionCategories[_categoryIndex];
    setState(() {
      _hasInputError = false;
      _result = category.convert(value, _fromUnit, _toUnit);
    });
  }

  String _formatNumber(double value) {
    if (value.isNaN || value.isInfinite) return '—';
    if (value == 0) return '0';
    final abs = value.abs();
    if (abs >= 1e9 || abs < 1e-6) return value.toStringAsExponential(4);
    // Trim trailing zeros but keep useful precision.
    String s = value.toStringAsFixed(abs >= 100 ? 2 : 6);
    if (s.contains('.')) {
      s = s.replaceFirst(RegExp(r'0+$'), '');
      s = s.replaceFirst(RegExp(r'\.$'), '');
    }
    return s;
  }

  String? _rateLine(ConversionCategory category) {
    if (_fromUnit == _toUnit) return null;
    final oneUnit = category.convert(1, _fromUnit, _toUnit);
    return '1 $_fromUnit = ${_formatNumber(oneUnit)} $_toUnit';
  }

  @override
  Widget build(BuildContext context) {
    final category = conversionCategories[_categoryIndex];
    final units = category.unitNames;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.straighten, size: 20, color: AppColors.accent),
            SizedBox(width: 10),
            Text('Multi-Unit Converter'),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            CategoryChipBar(selectedIndex: _categoryIndex, onSelected: _onCategoryChanged),
            const SizedBox(height: 20),
            TextField(
              controller: _inputController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              onChanged: (_) => _convert(),
              decoration: InputDecoration(
                labelText: 'Value',
                errorText: _hasInputError ? 'Enter a valid number' : null,
                suffixText: category.type.name == 'temperature' ? '°' : null,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: UnitDropdown(
                    label: 'From',
                    value: _fromUnit,
                    options: units,
                    onChanged: (v) {
                      setState(() => _fromUnit = v);
                      _convert();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SwapButton(onTap: _swapUnits),
                ),
                Expanded(
                  child: UnitDropdown(
                    label: 'To',
                    value: _toUnit,
                    options: units,
                    onChanged: (v) {
                      setState(() => _toUnit = v);
                      _convert();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ResultCard(
              resultText: _result == null ? '—' : _formatNumber(_result!),
              toUnit: _toUnit,
              rateLine: _result == null ? null : _rateLine(category),
              hasError: _hasInputError,
            ),
          ],
        ),
      ),
    );
  }
}
