import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:myeasylist/provider/home_provider.dart';
import 'package:provider/provider.dart';

import '../../../domain/domain.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    loadInfo();
    super.initState();
  }

  loadInfo() async {
    Provider.of<HomeProvider>(context, listen: false).loadPlaces();
  }

  reload() async {
    await loadInfo();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _controllerItem = TextEditingController();
    Color _color = Colors.deepPurple;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
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
                                  Text(
                                      '1- Clique no botão + para adicionar um item.'),
                                  Text(
                                      '2- Arraste um item para a direita para remove-lo ou edita-lo.'),
                                  Text(
                                      '3- Faça um clique longo em um cartão para marca-lo.'),
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
        body: FutureBuilder(
          future: loadInfo(),
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
                  reload();
                },
                child: Consumer<HomeProvider>(
                  builder: ((context, provider, _) {
                    return provider.items.isEmpty
                        ? const Center(
                            child: Text('Lista vazia!'),
                          )
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
                                        Provider.of<HomeProvider>(context,
                                                listen: false)
                                            .removeItem(provider.items[index]);
                                      },
                                      backgroundColor: const Color(0xFFFE4A49),
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Deletar',
                                    ),
                                    SlidableAction(
                                      onPressed: (BuildContext context) async {
                                        _controllerItem.text =
                                            provider.items[index].item;
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Center(
                                                    child: Text('Editar item')),
                                                content: Row(
                                                  children: [
                                                    Flexible(
                                                      child: TextFormField(
                                                        controller:
                                                            _controllerItem,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              "Descrição do item",
                                                          labelStyle: TextStyle(
                                                              color: _color),
                                                          fillColor: _color,
                                                          // prefixIcon: Icon(
                                                          //   Icons.text,
                                                          //   color: _color,
                                                          // ),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(20),
                                                              topLeft: Radius
                                                                  .circular(20),
                                                              topRight: Radius
                                                                  .circular(20),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                            borderSide:
                                                                BorderSide(
                                                              color: _color,
                                                            ),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(20),
                                                              topLeft: Radius
                                                                  .circular(20),
                                                              topRight: Radius
                                                                  .circular(20),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                            borderSide:
                                                                BorderSide(
                                                              color: _color,
                                                            ),
                                                          ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(20),
                                                              topLeft: Radius
                                                                  .circular(20),
                                                              topRight: Radius
                                                                  .circular(20),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                            borderSide:
                                                                BorderSide(
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
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('Voltar'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Item itemToUpdate = Item(
                                                          id: provider
                                                              .items[index].id,
                                                          item: _controllerItem
                                                              .text,
                                                          checked: 0);
                                                      Provider.of<HomeProvider>(
                                                              context,
                                                              listen: false)
                                                          .updateItem(
                                                              itemToUpdate);
                                                      _controllerItem.text = '';
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('Editar'),
                                                  )
                                                ],
                                              );
                                            });
                                      },
                                      backgroundColor: const Color(0xFF21B7CA),
                                      foregroundColor: Colors.white,
                                      icon: Icons.edit,
                                      label: 'Editar',
                                    ),
                                  ],
                                ),
                                child: Card(
                                  child: ListTile(
                                    //leading: const FlutterLogo(size: 56.0),
                                    onLongPress: () {
                                      var isChecked = provider.checked;
                                      if (isChecked == 0) {
                                        isChecked = 1;
                                      } else {
                                        isChecked = 0;
                                      }

                                      Item itemToUpdate = Item(
                                          id: provider.items[index].id,
                                          item: provider.items[index].item,
                                          checked: isChecked);

                                      Provider.of<HomeProvider>(context,
                                              listen: false)
                                          .updateItem(itemToUpdate);
                                      _controllerItem.text = '';
                                    },
                                    leading: const Icon(Icons.start_rounded),
                                    title: Text(
                                      provider.items[index].item,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'ArchitectsDaughter',
                                          fontWeight:
                                              provider.items[index].checked == 0
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                          decoration:
                                              provider.items[index].checked == 1
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none),
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
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Center(child: Text('Novo item')),
                    content: Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            controller: _controllerItem,
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
                          Provider.of<HomeProvider>(context, listen: false)
                              .addItem(itemDescription: _controllerItem.text);
                          _controllerItem.text = '';
                          Navigator.of(context).pop();
                        },
                        child: const Text('Salvar'),
                      )
                    ],
                  );
                });
          },
        ));
  }
}
