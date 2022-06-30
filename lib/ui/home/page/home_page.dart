// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:myeasylist/provider/home_provider.dart';
import 'package:myeasylist/ui/home/controller/controller.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../domain/domain.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

final BannerAd myBanner = BannerAd(
  adUnitId: 'ca-app-pub-7865824435572987/3962924379', //'ca-app-pub-3940256099942544/6300978111',
  //adUnitId: 'ca-app-pub-3940256099942544/6300978111',
  size: AdSize.banner,
  request: const AdRequest(),
  listener: const BannerAdListener(),
);

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    //for (int i = 0; i < 1000; i++) {
    myBanner.load();
    //}
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _controllerItem = TextEditingController();

    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    final _formKey = GlobalKey<FormState>();
    HomePageController controller = HomePageController(context: context);

    Color _color = Colors.deepPurple;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: _color,
        title: const Text('Lista de itens'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Center(
                        child: Text('Guia de uso'),
                      ),
                      actions: [
                        Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: const [
                                Text('1- Clique no botão + para adicionar um item.'),
                                Text('2- Arraste um item para a direita para remove-lo ou edita-lo.'),
                                Text('3- Faça um clique longo em um cartão para marca-lo.'),
                              ],
                            )),
                      ],
                    );
                  });
            },
            icon: const Icon(Icons.help),
          )
        ],
      ),
      body: Stack(children: [
        Container(
          color: Colors.white,
          child: FutureBuilder(
            future: controller.loadInfo(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Ocorreu um erro!'),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return RefreshIndicator(
                  onRefresh: () async {
                    controller.reload();
                  },
                  child: Consumer<HomeProvider>(
                    builder: ((context, provider, _) {
                      return provider.items.isEmpty
                          ? Center(
                              child: SizedBox(
                              width: _width / 0.2,
                              height: _height / 2,
                              child: Image.asset('assets/errors/empty.gif'),
                            ))
                          : ListView.builder(
                              itemCount: provider.items.length,
                              itemBuilder: (context, index) {
                                return Slidable(
                                  key: const ValueKey(1),
                                  startActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (BuildContext context) async {
                                          controller.removeItem(item: provider.items[index]);
                                        },
                                        backgroundColor: const Color(0xFFFE4A49),
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: 'Deletar',
                                      ),
                                      SlidableAction(
                                        onPressed: (BuildContext context) async {
                                          _controllerItem.text = provider.items[index].item;
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Form(
                                                  key: _formKey,
                                                  child: AlertDialog(
                                                    title: const Center(child: Text('Editar item')),
                                                    content: Row(
                                                      children: [
                                                        Flexible(
                                                          child: TextFormField(
                                                            maxLines: 3,
                                                            controller: _controllerItem,
                                                            validator: (value) {
                                                              if (value == null || value.isEmpty) {
                                                                return "Digite uma descrição para o item.";
                                                              } else {
                                                                return null;
                                                              }
                                                            },
                                                            decoration: InputDecoration(
                                                              labelText: "Descrição do item",
                                                              labelStyle: TextStyle(color: _color),
                                                              fillColor: _color,
                                                              border: OutlineInputBorder(
                                                                borderRadius: const BorderRadius.only(
                                                                  bottomLeft: Radius.circular(20),
                                                                  topLeft: Radius.circular(20),
                                                                  topRight: Radius.circular(20),
                                                                  bottomRight: Radius.circular(20),
                                                                ),
                                                                borderSide: BorderSide(
                                                                  color: _color,
                                                                ),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderRadius: const BorderRadius.only(
                                                                  bottomLeft: Radius.circular(20),
                                                                  topLeft: Radius.circular(20),
                                                                  topRight: Radius.circular(20),
                                                                  bottomRight: Radius.circular(20),
                                                                ),
                                                                borderSide: BorderSide(
                                                                  color: _color,
                                                                ),
                                                              ),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderRadius: const BorderRadius.only(
                                                                  bottomLeft: Radius.circular(20),
                                                                  topLeft: Radius.circular(20),
                                                                  topRight: Radius.circular(20),
                                                                  bottomRight: Radius.circular(20),
                                                                ),
                                                                borderSide: BorderSide(
                                                                  color: _color,
                                                                ),
                                                              ),
                                                            ),
                                                            style: const TextStyle(
                                                              fontFamily: "Poppins",
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    actions: [
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: const Text('Voltar'),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          bool? _formOk = _formKey.currentState!.validate();
                                                          if (!_formOk) {
                                                            return;
                                                          }
                                                          Item itemToUpdate = Item(id: provider.items[index].id, item: _controllerItem.text, checked: 0);
                                                          controller.updateItem(item: itemToUpdate);
                                                          _controllerItem.text = '';
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: const Text('Editar'),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              });
                                        },
                                        backgroundColor: const Color.fromARGB(255, 126, 228, 241),
                                        foregroundColor: Colors.white,
                                        icon: Icons.edit,
                                        label: 'Editar',
                                      ),
                                    ],
                                  ),
                                  child: Card(
                                    child: ListTile(
                                      onLongPress: () async {
                                        var isChecked = provider.checked;
                                        if (isChecked == 0) {
                                          isChecked = 1;
                                        } else {
                                          isChecked = 0;
                                        }

                                        Item itemToUpdate = Item(id: provider.items[index].id, item: provider.items[index].item, checked: isChecked);
                                        controller.updateItem(item: itemToUpdate);

                                        _controllerItem.text = '';
                                      },
                                      leading: const Icon(Icons.start_rounded),
                                      title: Text(
                                        provider.items[index].item,
                                        style: TextStyle(fontSize: 18, fontFamily: 'ArchitectsDaughter', fontWeight: provider.items[index].checked == 0 ? FontWeight.bold : FontWeight.normal, decoration: provider.items[index].checked == 1 ? TextDecoration.lineThrough : TextDecoration.none),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                    }),
                  ),
                );
              }
            },
          ),
        ),
        Positioned(
          //top: 20,
          bottom: 1,
          right: 0.1,
          child: Container(
            height: 50,
            width: _width,
            child: AdWidget(ad: myBanner),
          ),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          _controllerItem.text = '';

          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Form(
                  key: _formKey,
                  child: AlertDialog(
                    title: const Center(child: Text('Novo item')),
                    content: Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            maxLines: 3,
                            controller: _controllerItem,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Digite uma descrição para o item.";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: "Descrição do item",
                              labelStyle: TextStyle(color: _color),
                              fillColor: _color,
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                borderSide: BorderSide(
                                  color: _color,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                borderSide: BorderSide(
                                  color: _color,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                borderSide: BorderSide(
                                  color: _color,
                                ),
                              ),
                            ),
                            style: const TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Voltar'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          bool? _formOk = _formKey.currentState!.validate();
                          if (!_formOk) {
                            return;
                          }
                          controller.addItem(itemDescription: _controllerItem.text);
                          _controllerItem.text = '';
                          Navigator.of(context).pop();
                        },
                        child: const Text('Salvar'),
                      )
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}
