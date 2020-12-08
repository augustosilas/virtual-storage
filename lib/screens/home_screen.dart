import 'package:flutter/material.dart';
import 'package:virtual_store/tabs/home_tab.dart';
import 'package:virtual_store/tabs/orders_tab.dart';
import 'package:virtual_store/tabs/products_tab.dart';
import 'package:virtual_store/widgets/cart_button.dart';
import 'package:virtual_store/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(pageController: _pageController),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Produtos"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(pageController: _pageController),
          body: ProductsTab(),
          floatingActionButton: CartButton(),
        ),
        Container(color: Colors.blue),
        Scaffold(
          appBar: AppBar(
            title: Text("Meus Pedidos"),
            centerTitle: true,
          ),
          body: OrdersTab(),
          drawer: CustomDrawer(pageController: _pageController,),
        )
      ],
    );
  }
}
