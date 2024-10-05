import 'package:expenses_tracker/screens/add_expense/blocs/create_category_bloc/create_category_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:uuid/uuid.dart';
import 'package:expense_repository/expense_repository.dart';

Future getCategoryCreation(BuildContext context) {
  List<String> myCategoriesIcons = [
    'food',
    'entertainment',
    'health',
    'shopping',
    'travel',
    'pet',
    'agriculture',
    'education',
    'home',
    'sport',
    'tech',
    'vehicle',
    'other',
  ];

  List<String> myCategoryDescriptions = [
    'Food & Dining',
    'Entertainment',
    'Health & Fitness',
    'Shopping',
    'Travel & Vacations',
    'Pet Expenses',
    'Agriculture',
    'Education & Learning',
    'Home Expenses',
    'Sports',
    'Tech & Gadgets',
    'Vehicle Expenses',
    'Other Miscellaneous',
  ];

  return showDialog(
    context: context,
    builder: (ctx) {
      bool isExpanded = false;
      String iconSelected = '';
      Color categoryColor = Colors.white.withOpacity(0.5);

      TextEditingController categoryNameController = TextEditingController();
      TextEditingController categoryIconController = TextEditingController();
      TextEditingController categoryColorController = TextEditingController();
      bool isLoading = false;

      Category category = Category.empty;

      return BlocProvider.value(
        value: context.read<CreateCategoryBloc>(),
        child: StatefulBuilder(
          builder: (ctx, setState) {
            return BlocListener<CreateCategoryBloc, CreateCategoryState>(
              listener: (context, state) {
                if (state is CreateCategorySuccess) {
                  Navigator.pop(ctx, category);
                } else if (state is CreateCategoryLoading) {
                  setState(() {
                    isLoading = true;
                  });
                }
              },
              child: AlertDialog(
                title: const Text('Create a Category'),
                content: SingleChildScrollView(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: categoryNameController,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.5),
                            hintText: 'Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: categoryIconController,
                          onTap: () {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                          textAlignVertical: TextAlignVertical.center,
                          readOnly: true,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            suffixIcon: const Icon(
                              CupertinoIcons.chevron_down,
                              size: 12.0,
                            ),
                            fillColor: Colors.white.withOpacity(0.7),
                            hintText: 'Icon',
                            border: OutlineInputBorder(
                              borderRadius: isExpanded
                                  ? const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    )
                                  : BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        isExpanded
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                height: 200.0,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: const BorderRadius.vertical(
                                    bottom: Radius.circular(12),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 5,
                                      crossAxisSpacing: 5,
                                    ),
                                    itemCount: myCategoriesIcons.length,
                                    itemBuilder: (context, int i) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            iconSelected = myCategoriesIcons[i];
                                          });
                                        },
                                        onLongPress: () {
                                          // Show Tooltip or Dialog with the description
                                          showDialog(
                                            context: context,
                                            builder: (ctx2) {
                                              return AlertDialog(
                                                content: Text(
                                                  myCategoryDescriptions[i],
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    shadows: [
                                                      Shadow(
                                                        color: Colors.black
                                                            .withOpacity(0.7),
                                                        offset:
                                                            Offset(2.0, 2.0),
                                                        blurRadius: 4.0,
                                                      ),
                                                      Shadow(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurface,
                                                        offset:
                                                            Offset(-1.0, -1.0),
                                                        blurRadius: 0.0,
                                                      ),
                                                    ],
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(ctx2);
                                                    },
                                                    child: const Text('Close'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          width: 50.0,
                                          height: 50.0,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 3.0,
                                              color: iconSelected ==
                                                      myCategoriesIcons[i]
                                                  ? Colors.green
                                                  : Colors.grey,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            image: DecorationImage(
                                              image: AssetImage(
                                                'assets/categories/${myCategoriesIcons[i]}.gif',
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                            : Container(),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: categoryColorController,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx2) {
                                return AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SingleChildScrollView(
                                        child: BlockPicker(
                                          pickerColor: categoryColor,
                                          onColorChanged: (Color value) {
                                            setState(() {
                                              categoryColor = value;
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 50.0,
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.pop(ctx2);
                                          },
                                          style: TextButton.styleFrom(
                                            backgroundColor: Colors.black,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                          ),
                                          child: Text(
                                            'Save',
                                            style: TextStyle(
                                              fontSize: 22.0,
                                              color:
                                                  Colors.white.withOpacity(0.7),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          textAlignVertical: TextAlignVertical.center,
                          readOnly: true,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: categoryColor,
                            hintText: 'Color',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        SizedBox(
                          width: double.infinity,
                          height: kToolbarHeight,
                          child: isLoading == true
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : TextButton(
                                  onPressed: () {
                                    setState(() {
                                      category.categoryId = const Uuid().v1();
                                      category.name =
                                          categoryNameController.text;
                                      category.icon = iconSelected;
                                      category.color = categoryColor.value;
                                    });

                                    context
                                        .read<CreateCategoryBloc>()
                                        .add(CreateCategory(category));
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                  child: Text(
                                    'Save',
                                    style: TextStyle(
                                      fontSize: 22.0,
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
