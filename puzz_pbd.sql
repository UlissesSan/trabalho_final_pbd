/*
  autores:   Ulisses Santana
       Deyvid Yuri
*/

/* TABELAS */
DROP TABLE IF EXISTS funcionarios;
CREATE TABLE funcionarios (
  funcionario_id  SERIAL primary key not null,
  nome varchar(50) not null,
  cpf varchar(15) unique not null,
  telefone varchar (11) not null,
  endereco varchar(100) not null
);

DROP TABLE IF EXISTS cargo;
CREATE TABLE cargo (
  cargo_id SERIAL primary key not null,
  nome_cargo varchar(20) not null
);

DROP TABLE IF EXISTS funcionario_cargo;
CREATE TABLE funcionario_cargo (
  funcionario_id integer references funcionarios(funcionario_id),
  cargo_id integer references cargo(cargo_id),

  primary key (funcionario_id, cargo_id)
);


DROP TABLE IF EXISTS motel;
CREATE TABLE motel(
  motel_id SERIAL primary key not null,
  nome_motel varchar(50) not null
);

DROP TABLE IF EXISTS produtos;
CREATE TABLE produtos(
  produto_id SERIAL primary key not null,
  nome_produto varchar(50) not null,
  tipo_quantidade varchar(3) not null
);

DROP TABLE IF EXISTS estoque;
CREATE TABLE estoque(
  estoque_id SERIAL primary key not null,
  motel_id integer references motel (motel_id),
  produto_id integer references produtos (produto_id),
  quantidade integer not null
);

DROP TABLE IF EXISTS categoria;
CREATE TABLE categoria (
  categoria_id SERIAL primary key not null,
  nome_categoria varchar(50),
  valor_categoria float
);

DROP TABLE IF EXISTS quarto;
CREATE TABLE quarto(
  quarto_id SERIAL primary key not null,
  numero integer not null,
  categoria_id integer references categoria(categoria_id)
);

DROP TABLE IF EXISTS quarto_motel;
CREATE TABLE quarto_motel(
  ocupado boolean default false,
  motel_id integer references motel(motel_id),
  quarto_id integer references quarto(quarto_id),

  primary key (motel_id, quarto_id)
);

DROP TABLE IF EXISTS cliente;
CREATE TABLE cliente (
  cliente_id SERIAL primary key not null
);

DROP TABLE IF EXISTS ocupacao;
CREATE TABLE ocupacao(
  ocupacao_id SERIAL primary key not null,
  entrada timestamp not null,
  saida timestamp,

  funcionario_id integer not null,
  motel_id integer not null,
  quarto_id integer not null,
  cliente_id integer not null,

  foreign key (funcionario_id) references funcionarios(funcionario_id),
  foreign key (motel_id, quarto_id) references quarto_motel(motel_id, quarto_id),
  foreign key (cliente_id) references cliente (cliente_id)
);

DROP TABLE IF EXISTS pedido;
CREATE TABLE pedido(
  pedido_id SERIAL primary key not null,
  total float,
  /* ocupacao_id nao estava declarado*/
  ocupacao_id integer,
  foreign key (ocupacao_id) references ocupacao(ocupacao_id)
);

DROP TABLE IF EXISTS item_pedido;
CREATE TABLE item_pedido(
  pedido_id integer references pedido(pedido_id),
  produto_id integer references produtos(produto_id),
  estoque_id integer references estoque(estoque_id),
  quantidade integer not null,

  primary key(pedido_id, produto_id)
);


/* VIEWS */
/* 1 - mostrar o balanço geral de uma data a outra */

/* 2 - mostrar o balanço da conta do cliente*/

/* TESTS */
select cadastrarQuarto(100, 'luxo');
select cadastrarQuarto(100, 'master luxo');
select * from quarto;

select cadastrarCategoria('Luxo');
select cadastrarCategoria('Apartamento');
select cadastrarCategoria('');
select * from categoria;
select cadastrarCategoria('Luxo');
select cadastrarCategoria('Apartamento');

select * from categoria;

select * from funcionarios;

INSERT INTO funcionarios (nome, cpf, telefone, endereco) VALUES ('PEGA ARROMBADO', '55555555555', '11111111111', 'puta que pariu');
insert into funcionarios (nome, cpf, telefone, endereco) values ('Maycon','60000000000', '8612345678', 'Ladeira do Uruguai');

insert into ocupacao (data_entrada, funcionarioId, cargoId) values ( '2018-10-20', 2, 1);

select cadastrarFuncionario('Ulissdses', '60045262360', '12345678912', 'longe pra caralho');