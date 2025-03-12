import 'package:financeapp_app/dtos/asset_dto.dart';
import 'package:financeapp_app/dtos/category_dto.dart';
import 'package:flutter/material.dart';

// TODO BUG als je komma gebruikt bij double, krijg je een error

class AddAssetModal extends StatefulWidget {
  const AddAssetModal({super.key, required this.ctx, required this.categories, required this.onAddAsset});

  final List<CategoryDTO> categories;
  final BuildContext ctx;

  final void Function (CreateAssetDTO asset) onAddAsset;

  @override
  _AddAssetModalState createState() => _AddAssetModalState();
}

class _AddAssetModalState extends State<AddAssetModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _assetNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _purchasePriceController = TextEditingController();
  final TextEditingController _fictionalPriceController = TextEditingController();

  DateTime? _purchaseDate;
  CategoryDTO? _selectedCategory;

  @override
  void initState() {
    super.initState();
    if (widget.categories.isNotEmpty) {
      _selectedCategory = widget.categories.first;
    }
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final CreateAssetDTO asset = CreateAssetDTO(
        name: _assetNameController.text,
        description: _descriptionController.text,
        purchaseDate: _purchaseDate!,
        purchasePrice: double.parse(_purchasePriceController.text),
        fictionalPrice: double.parse(_fictionalPriceController.text),
        categoryId: _selectedCategory!.id,
      );

      widget.onAddAsset(asset);
    }
  }

  // Validator functions
  String? _validateAssetName(String? value) {
    if (value == null || value.isEmpty) return 'Please enter asset name';
    return null;
  }

  String? _validatePurchasePrice(String? value) {
    if (value == null || value.isEmpty) return 'Enter purchase price';
    return null;
  }

  String? _validatePurchaseDate(DateTime? value) {
    if (value == null) return 'Select purchase date';
    return null;
  }

  String? _validateCategory(CategoryDTO? value) {
    if (value == null) return 'Select category';
    return null;
  }

  // Helper functions
  Future<void> _selectPurchaseDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _purchaseDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _purchaseDate = pickedDate;
      });
    }
  }

  // Widget builder functions to keep the build method clean
  Widget _buildDragHandle() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 16),
        width: 40,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(2.5),
        ),
      ),
    );
  }

  Widget _buildAssetNameField() {
    return TextFormField(
      controller: _assetNameController,
      decoration: const InputDecoration(labelText: 'Asset Name'),
      validator: _validateAssetName,
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(labelText: 'Description (optional)'),
      maxLines: 3,
    );
  }

  Widget _buildPurchaseDateField() {
    return FormField<DateTime>(
      validator: (_) => _validatePurchaseDate(_purchaseDate),
      builder: (state) {
        return InkWell(
          onTap: _selectPurchaseDate,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Purchase Date',
              errorText: state.errorText,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _purchaseDate == null
                      ? 'Select Date'
                      : '${_purchaseDate!.toLocal()}'.split(' ')[0],
                ),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPurchasePriceField() {
    return TextFormField(
      controller: _purchasePriceController,
      decoration: const InputDecoration(
        labelText: 'Purchase Price',
        prefixText: '€ ',
      ),
      keyboardType: TextInputType.number,
      validator: _validatePurchasePrice,
    );
  }

  Widget _buildFictionalPriceField() {
    return TextFormField(
      controller: _fictionalPriceController,
      decoration: const InputDecoration(
        labelText: 'Fictional Price (optional)',
        prefixText: '€ ',
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildCategoryField() {
    return DropdownButtonFormField<CategoryDTO>(
      value: _selectedCategory,
      decoration: const InputDecoration(labelText: 'Category'),
      items: widget.categories
          .map((cat) => DropdownMenuItem<CategoryDTO>(
                value: cat,
                child: Text(cat.name),
              ))
          .toList(),
      validator: (value) => _validateCategory(value),
      onChanged: (value) {
        setState(() {
          _selectedCategory = value;
        });
      },
    );
  }

  Widget _buildSubmitButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _onSubmit();
              Navigator.of(widget.ctx).pop();
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Ensure modal is not obstructed by the keyboard.
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 16,
        left: 16,
        right: 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDragHandle(),
              const Text(
                'Add Asset',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildAssetNameField(),
              const SizedBox(height: 16),
              _buildDescriptionField(),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _buildPurchasePriceField(),
                        const SizedBox(height: 16),
                        _buildPurchaseDateField(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        _buildFictionalPriceField(),
                        const SizedBox(height: 16),
                        _buildCategoryField(),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildSubmitButton(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _assetNameController.dispose();
    _descriptionController.dispose();
    _purchasePriceController.dispose();
    _fictionalPriceController.dispose();
    super.dispose();
  }
}
