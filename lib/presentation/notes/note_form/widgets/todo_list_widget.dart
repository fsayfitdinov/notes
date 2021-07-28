import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:kt_dart/collection.dart';
import 'package:provider/provider.dart';

import '../../../../application/notes/note_form/note_form_bloc.dart';
import '../../../../domain/notes/value_objects.dart';
import '../../../core/constants.dart';
import '../../../core/widgets/custom_text.dart';
import '../misc/build_context_x.dart';
import '../misc/todo_item_presentation_classes.dart';

class TodoList extends StatelessWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<NoteFormBloc, NoteFormState>(
      listenWhen: (p, c) => p.note.todos.isFull != c.note.todos.isFull,
      listener: (context, state) {
        if (state.note.todos.isFull) {
          context.showFlashBar(
            backgroundColor: kSecondaryColor,
            duration: const Duration(seconds: 3),
            content: const CustomText(
              'Want longer lists? \nActivate premium 🤩',
            ),
            primaryActionBuilder: (context, controller, child) => TextButton(
              onPressed: () => controller.dismiss(),
              child: const Padding(
                padding: EdgeInsets.only(right: 8),
                child: CustomText(
                  'BUY NOW',
                  color: kAccentColor,
                  weight: FontWeight.w600,
                ),
              ),
            ),
          );
        }
      },
      child: Consumer<FormTodos>(
        builder: (context, formTodos, _) => ImplicitlyAnimatedReorderableList<TodoItemPrimitive>(
          shrinkWrap: true,
          items: formTodos.value.asList(),
          areItemsTheSame: (oldItem, newItem) => oldItem.id == newItem.id,
          onReorderFinished: (item, from, to, newItems) {
            context.formTodos = newItems.toImmutableList();
            context.read<NoteFormBloc>().add(NoteFormEvent.todosChanged(context.formTodos));
          },
          itemBuilder: (context, itemAnimation, item, index) {
            return Reorderable(
              key: ValueKey(item.id),
              builder: (ctx, dragAnimation, inDrag) => ScaleTransition(
                scale: Tween<double>(begin: 1, end: 0.96).animate(dragAnimation),
                child: TodoTile(
                  index: index,
                  elevation: dragAnimation.value * 4,
                ),
              ),
            );
          },
          removeDuration: const Duration(milliseconds: 10),
        ),
      ),
    );
  }
}

class TodoTile extends HookWidget {
  final int index;
  final dynamic elevation;

  const TodoTile({
    Key? key,
    required this.index,
    elevation,
  })  : elevation = elevation ?? 0.0,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final todo = context.formTodos.getOrElse(index, (_) => TodoItemPrimitive.empty());
    final textController = useTextEditingController(text: todo.name);
    final OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: kMainColor),
    );

    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      secondaryActions: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: IconSlideAction(
            icon: Icons.delete,
            caption: 'Delete',
            color: Colors.red,
            onTap: () {
              context.formTodos = context.formTodos.minusElement(todo);
              context.read<NoteFormBloc>().add(NoteFormEvent.todosChanged(context.formTodos));
            },
          ),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Material(
          color: kSecondaryColor.withOpacity(0.6),
          borderRadius: BorderRadius.circular(10),
          animationDuration: const Duration(milliseconds: 50),
          elevation: elevation as double,
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: Checkbox(
                fillColor: MaterialStateProperty.all<Color>(Colors.transparent),
                side: const BorderSide(color: Colors.white),
                value: todo.done,
                onChanged: (val) {
                  context.formTodos = context.formTodos.map(
                    (listTodo) => listTodo == todo ? todo.copyWith(done: val!) : listTodo,
                  );
                  context.read<NoteFormBloc>().add(NoteFormEvent.todosChanged(context.formTodos));
                },
              ),
              title: TextFormField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: 'Todo',
                  fillColor: Colors.transparent,
                  counterText: '',
                  errorBorder: outlineInputBorder,
                ),
                maxLength: TodoName.maxLength,
                onChanged: (val) {
                  context.formTodos = context.formTodos.map(
                    (listTodo) => listTodo == todo ? todo.copyWith(name: val) : listTodo,
                  );
                  context.read<NoteFormBloc>().add(NoteFormEvent.todosChanged(context.formTodos));
                },
                validator: (_) => context.read<NoteFormBloc>().state.note.todos.value.fold(
                      (f) => null,
                      (todoList) => todoList[index].name.value.fold(
                            (f) => f.maybeMap(
                              empty: (_) => 'Cannot be empty',
                              exceedingLength: (_) => 'Too long',
                              multiLine: (_) => 'Has to be a single line',
                              orElse: () => null,
                            ),
                            (_) => null,
                          ),
                    ),
              ),
              trailing: const Handle(child: Icon(Icons.list)),
            ),
          ),
        ),
      ),
    );
  }
}
