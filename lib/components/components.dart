import 'package:botcamp_flutter_challenge/shared/cubit/cubit.dart';
import 'package:flutter/material.dart';

Widget textFormField({
  required TextEditingController controller,
  required TextInputType inputType,
  required Function validate,
  required String label,
  required IconData prefixIconData,
  Function? onSubmit,
  Function? onPressed,
  Function? onChange,
}) {
  return TextFormField(
    onChanged: (value) {
      onChange!(value);
    },
    controller: controller,
    keyboardType: inputType,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      prefixIcon: Icon(prefixIconData),
    ),
    onTap: () {
      onPressed!();
    },
    validator: (value) {
      validate(value!);
    },
  );
}

//this widget for build item to tasks
Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 9.0,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.blue.shade200,
                  radius: 40.0,
                  child: Text('${model['time']}'),
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${model['title']}',
                      style: const TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      '${model['date']}',
                      style: const TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(status: 'done', id: model['id']);
                },
                icon: const Icon(Icons.check_box),
                color: Colors.green,
              ),
              IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(status: 'archive', id: model['id']);
                },
                icon: const Icon(Icons.archive),
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
      onDismissed: (direction) {
        AppCubit.get(context).deleteData(id: model['id']);
      },
    );
