import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/cubit/theme/theme_cubit.dart';
import 'package:store_app/screens/shopping_cart_screen.dart';

class HomeAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: const Text('New Trend'),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, ShoppingCartScreen.id);
          },
          icon: const Icon(Icons.shopping_cart),
        ),
        BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, state) {
            return IconButton(
              icon: Icon(
                state == ThemeMode.light ? Icons.dark_mode : Icons.light_mode,
              ),
              onPressed: () {
                context.read<ThemeCubit>().toggleTheme();
              },
            );
          },
        ),
      ],
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

