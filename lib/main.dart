import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/cubit/cart/cart_cubit.dart';
import 'package:store_app/cubit/product/product_cubit.dart';
import 'package:store_app/cubit/theme/theme_cubit.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/screens/home_page_screen.dart';
import 'package:store_app/screens/shopping_cart_screen.dart';
import 'package:store_app/screens/update_product_screen.dart';
import 'package:store_app/services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init();
  runApp(const StoreApp());
}

class StoreApp extends StatelessWidget {
  const StoreApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CartCubit()),
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => ProductsCubit()), // 🆕
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light().copyWith(
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white, // Light Mode AppBar
                foregroundColor: Colors.black, // Text & Icon colors
                elevation: 0,
              ),
            ),
            darkTheme: ThemeData.dark().copyWith(
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.black, // Dark Mode AppBar
                foregroundColor: Colors.white, // Text & Icon colors
                elevation: 0,
              ),
            ),
            themeMode: themeMode,
            routes: {
              HomePageScreen.id: (context) => const HomePageScreen(),
              UpdateProductScreen.id: (context) {
                final product =
                    ModalRoute.of(context)!.settings.arguments as ProductModel;
                return UpdateProductScreen(product: product);
              },
              ShoppingCartScreen.id: (context) => const ShoppingCartScreen(),
            },
            initialRoute: HomePageScreen.id,
          );
        },
      ),
    );
  }
}
