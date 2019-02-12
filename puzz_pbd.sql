/*
	autor: Ulisses Santana
		   Deyvid Yuri
*/


/* TABELAS */
DROP TABLE IF EXISTS funcionario;
CREATE TABLE funcionarios (
	funcionario_id  SERIAL primary key not null,
	nome varchar(50) not null,
	cpf varchar(15) unique not null,
	telefone varchar (20) not null,
	endereco varchar(100) not null
)

DROP TABLE IF EXISTS cargo;
CREATE TABLE cargo (
	cargo_id SERIAL primary key not null,
	nome_cargo varchar(20) not null
)

DROP TABLE IF EXISTS ocupacao;
CREATE TABLE ocupacao(
	ocupacao_id SERIAL primary key not null,
	data_entrada date not null,
	data_saida date,
	funcionarioId integer not null,
	cargoId integer not null,
	motelId integer not null,
	
	foreign key (funcionarioId) references funcionarios (funcionario_id),
	foreign key (cargoId) references cargo (cargo_id),
	foreign key (motelId) references motel (motel_id)
)

DROP TABLE IF EXISTS motel;
CREATE TABLE motel(
	motel_id SERIAL primary key not null,
	nome_motel varchar(50) not null,
	endereco varchar(100) not null,
)

DROP TABLE IF EXISTS estoque;
CREATE TABLE estoque(
	estoque_id SERIAL primary key not null,
	motelId integer not null,
	produtoId integer not null,
	quantidade integer not null,

	foreign key motelId references motel (motel_id),
	foreign key produtoId references produtos (produto_id)
	
)

DROP TABLE IF EXISTS produtos;
CREATE TABLE produtos(
	produto_id SERIAL primary key not null,
	nome_produto varchar(50) not null,
	tipo_quantidade varchar(50) not null,
	descricao varchar(50)
)

DROP TABLE IF EXISTS quarto_motel;
CREATE TABLE quarto_motel(
	quarto_motel_id SERIAL primary key not null,
)

DROP TABLE IF EXISTS quarto;a
CREATE TABLE quarto(
	quarto_id SERIAL primary key not null,
)

DROP TABLE IF EXISTS categoria;
CREATE TABLE categoria (
	categoria_id SERIAL primary key not null,
	nome_categoria varchar(50),
)

DROP TABLE IF EXISTS cliente;
CREATE TABLE cliente (
	cliente_id SERIAL primary key not null,
	ocupacaoId not null,

	foreign key ocupacaoId references ocupacao (ocupacao_id)
)

DROP TABLE IF EXISTS pedido;
CREATE TABLE pedido(
	pedido_id SERIAL primary key not null,
	ocupacaoId not null,

	foreign key ocupacaoId references ocupacao (ocupacao_id)
)

DROP TABLE IF EXISTS item_pedido;
CREATE TABLE item_pedido(
	item_id SERIAL primary key not null,
)


/* FUNCOES */



/* TRIGGERS */



/* VIEWS */


/* Insert test */
insert into funcionarios (nome, telefone, endereco) values ('Maycon', '8612345678', 'Ladeira do Uruguai');
insert into funcionarios (nome, telefone, endereco) values ('Thais', '8687654321', 'Lourival Parente');

insert into cargo (nome_cargo) values ('recepcionista');
insert into cargo (nome_cargo) values ('camarera');
insert into cargo (nome_cargo) values ('gerente');
insert into cargo (nome_cargo) values ('cozinheira');

insert into ocupacao (data_entrada, funcionarioId, cargoId) values ( '2018-10-20', 2, 1);


/* select test*/
select all from ocupacao;