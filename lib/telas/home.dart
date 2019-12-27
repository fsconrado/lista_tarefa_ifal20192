import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lista_tarefa_ifalnew/servicos/myFile.dart';

/*
* @Fabiano Conrado, comentário realizado para melhor aproveitamento dos alunos da disciplina de Pmovel IFAL
*
* */

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _listaTarefas = []; //Criando uma lista vazia que será preenchida gradativamente conforme formos adicionando tarefas,
  //usamos o _(underline) para que a lista fosse private no dart o "_" significa private
  var textControle = TextEditingController(); //Criando um controller para ligar com o TextField é sempre necessário criar
  // esse textcontroler para ligar com o campo de texto, é por meio dele que pegamos o texto do cmapo de texto(TextField)

  MyFile myFile = MyFile(); //Instanciando a classe MyFile (Meu Arquivo) para salvar a lista no celular.

  //Metodo Criado para Adicionar novas tarefas
  void addTarefa() {
    //Usa o setState para que a tela seja redesenhada exibindo a nova lista
    setState(() {
      Map<String, dynamic> novaTarefa = Map(); //Criamos um objeto novaTarefa para construir essa nova tarefa.
      novaTarefa["titulo"] = textControle.text; //Pegando o texto do TextField e adicionando a nova tarefa
      novaTarefa["ok"] = false; //Adicionando um boletam para verificar se a tarefa está concluida ou não false indica pendência e true que ela está ok, ou seja, concluida.
      textControle.text = ""; //Limpando o campo TextField
      _listaTarefas.add(novaTarefa); //Adicionamos essa nova tarefa com seu titulo e ok na listaTarefas
      myFile.saveData(_listaTarefas);
    });
  }

  /*
  Assim que o App abre a lista _listTarefas ela esta vazia, aqui sobrescrevemos um metodo do flutter chamado initState (estado inicial)
  Nela o objetivo é ler o arquivo salvo no celular e carregar as informações no _listTarefas,
  Sem esse código abaixo o app vai salvar as informações mas quando abrir o app a lista não vai aparecer.
  * */
  @override
  void initState() {
    super.initState(); // Quando usamos o initState sempre vai er necessário usar o super.initState();
    //Aqui chamamos suas ações encadeadas(uma após a outra), primeiro é executado o readData(ler Dados)
    //Daí usamos o .then que pode ser traduzido como "em seguida", ou seja, o then espera o primeiro metodo ser executado para só
    //aí executar o que está dentro dele (dentro do .then) vai uma função anonima que recebe os dados(data) que retornaram do readData
    //decodifica ele pois foi salvo como json, decodifica para List e carrega esses dados na _listaTarefas;
    myFile.readData().then((data) {
      setState(() {
        _listaTarefas = json.decode(data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: textControle,
                    decoration: InputDecoration(
                        labelText: "Nova Tarefa",
                        labelStyle: TextStyle(color: Colors.blue)),
                  ),
                ),
                RaisedButton(
                  child: Text("ADD"),
                  textColor: Colors.white,
                  onPressed: addTarefa, // Ao pressionar o botão ADD ele chama o metodo "addTarefa"
                  color: Colors.blue,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder( // ListView (Criar uma List de Coisas esse Widget literalmente constroí uma lista na tela
                itemCount: _listaTarefas.length, //aqui serve para informar quantos itens terão a lista na tela, por padrão usamos o tamanho de uma List
                itemBuilder: (context, indice) { //O ItemBuilder constroí cada item ele recebe uma metodo anonimo que recebe dois parametros (context que não é usado aqui e o indice)
                  return CheckboxListTile(       //CheckBoxListTile é o responsável em gerar a caixa de checkBox
                    title: Text(_listaTarefas[indice]["titulo"]), //Pegando o título de cada tarefa
                    onChanged: (c) { //O Onchange é usado quando alguém muda o estado do checkBox, o checkbox é boolean (true, false) então se ele estiver true quando clico ele fica false e vice-versa
                      setState(() { //Lembrando que o setState sempre deve ser usado quando queremos que ao atualizar alguma coisa(variável) ele redesenhe a tela.
                        _listaTarefas[indice]["ok"] = c; //_listTarefas recebe o novo C (C=true ou false) e atualiza o ok (status) da tarefa para concluído ou não(true ou false)
                        myFile.saveData(_listaTarefas); //Ao mudar o status de um item da lista para concluído ou não salvamos a nova lista no arquivo.
                      });
                    },
                    value: _listaTarefas[indice]["ok"], //bem o value informa se a caixinha do checkbox vai estar ligada ou delsigada, aqui só informei o status da tarefa que é um boolean se ele for true a caixa vai ficar marcada e vice-versa
                    secondary: CircleAvatar( //O CircleAvatar criar um desenho de um circulo e recebe como filho(child) um outro widget nesse caso recebe um Icone
                      child: Icon(_listaTarefas[indice]["ok"] //Aqui estou usando o ternário se "ok" true muda o icone par acheck, se "ok" false muda para error
                          ? Icons.check
                          : Icons.error),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
