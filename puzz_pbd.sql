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


DROP TABLE IF EXISTS ocupacao;
CREATE TABLE ocupacao(
	ocupacao_id SERIAL primary key not null,
	data_entrada date not null,
	data_saida date,

	funcionario_id integer not null,
  cargo_id integer not null,
  motel_id integer not null,
  quarto_id integer not null,
  cliente_id integer not null,
  pedido_id integer not null,


  foreign key (funcionario_id, cargo_id) references funcionario_cargo(funcionario_id, cargo_id),
  foreign key (motel_id, quarto_id) references quarto_motel(motel_id, quarto_id),
  foreign key (cliente_id) references cliente (cliente_id),
  foreign key (pedido_id) references pedido (pedido_id)	
);

DROP TABLE IF EXISTS estoque;
CREATE TABLE estoque(
	estoque_id SERIAL primary key not null,
	motel_id integer references motel (motel_id),
	produto_id integer references produtos (produto_id),
	quantidade integer not null
);

DROP TABLE IF EXISTS produtos;
CREATE TABLE produtos(
	produto_id SERIAL primary key not null,
	nome_produto varchar(50) not null,
	tipo_quantidade varchar(3) not null
);

DROP TABLE IF EXISTS quarto_motel;
CREATE TABLE quarto_motel(
	motel_id integer references motel(motel_id),
	quarto_id integer references quarto(quarto_id),

  primary key (motel_id, quarto_id)
);

DROP TABLE IF EXISTS quarto;
CREATE TABLE quarto(
	quarto_id SERIAL primary key not null,
	numero integer not null,
	categoria_id integer references categoria(categoria_id)
);

DROP TABLE IF EXISTS categoria;
CREATE TABLE categoria (
	categoria_id SERIAL primary key not null,
	nome_categoria varchar(50)
);

DROP TABLE IF EXISTS cliente;
CREATE TABLE cliente (
	cliente_id SERIAL primary key not null
);

DROP TABLE IF EXISTS pedido;
CREATE TABLE pedido(
	pedido_id SERIAL primary key not null,
	total float
);

DROP TABLE IF EXISTS item_pedido;
CREATE TABLE item_pedido(
  pedido_id integer references pedido(pedido_id),
  produto_id integer references produtos(produto_id),
  estoque_id integer references estoque(estoque_id),
  quantidade integer not null,

  primary key(pedido_id, produto_id)
);


/* FUNCOES */
CREATE OR REPLACE FUNCTION cadastrarFuncionario(nome_f VARCHAR(50), cpf_f VARCHAR(15),
	telefone_f VARCHAR(50), endereco_f VARCHAR(100))
  RETURNS VOID AS
$$
BEGIN
  IF nome_f IS NULL OR nome_f LIKE ''
  THEN
    RAISE EXCEPTION 'O nome não pode ser nulo ou vazio!';
  ELSEIF cpf_f IS NULL OR cpf_f LIKE ''
  THEN
    RAISE EXCEPTION 'O CPF não é nulo ou vazio!';
  ELSEIF telefone_f IS NULL OR telefone_f LIKE ''
  THEN
    RAISE EXCEPTION 'O telefone não é nulo ou vazio!';
  ELSEIF endereco_f IS NULL OR endereco_f LIKE ''
  THEN
    RAISE EXCEPTION 'O endereço não pode ser nulo ou vazio!';
  ELSE
    INSERT INTO funcionarios (nome, cpf, telefone, endereco) VALUES (nome_f, cpf_f, telefone_f, endereco_f);
    RAISE notice 'Funcionario cadastrado com sucesso, Obrigado!';
  END IF;
END
$$
  LANGUAGE PLPGSQL;

 
CREATE OR REPLACE FUNCTION cadastrarCargo(cargo VARCHAR(50))
  RETURNS VOID as $$
BEGIN
  IF cargo IS NULL OR cargo LIKE ''
  THEN
    RAISE EXCEPTION 'Cargo não pode ser nulo ou vazio!';
  ELSE
    INSERT INTO cargo VALUES (DEFAULT, cargo);
    RAISE notice 'Funcionario cadastrado com sucesso, Obrigado!';
  END IF;
END
$$ LANGUAGE PLPGSQL;


CREATE OR REPLACE FUNCTION cadastrarCategoria(categoria VARCHAR(50))
  RETURNS VOID as $$
BEGIN
  IF categoria IS NULL OR categoria LIKE ''
  THEN
    RAISE EXCEPTION 'Categoria não pode ser nula ou vazio!';
  ELSE
    INSERT INTO categoria VALUES (DEFAULT, categoria);
    RAISE notice 'Categoria cadastrada com sucesso, Obrigado!';
  END IF;
END
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION cadastrarProduto(nome_p VARCHAR(50), tipo_quantidade_p varchar(3), descricao_p varchar(50))
  RETURNS VOID as $$
BEGIN
  IF nome_p IS NULL OR nome_p LIKE ''
  THEN
  	RAISE EXCEPTION 'Nome não pode ser nulo ou vazio!';
  ELSEIF tipo_quantidade_p IS NULL OR tipo_quantidade_p LIKE ''
  THEN
    RAISE EXCEPTION 'Tipo quantidade não pode ser nulo ou vazio!';
  ELSEIF descricao_p IS NULL OR descricao_p LIKE ''
  THEN
    RAISE EXCEPTION 'Descricao não pode ser nula ou vazia!';
  ELSE
    INSERT INTO produtos VALUES (DEFAULT, nome_p, tipo_quantidade_p, descricao_p);
    RAISE notice 'Produto cadstrado com sucesso, Obrigado!';
    END IF;
END
$$ LANGUAGE PLPGSQL

CREATE OR REPLACE FUNCTION cadastrarQuarto(numero integer, _categoria VARCHAR(50))
  RETURNS VOID as $$
declare
	var_categoria_id integer;
begin
	select categoria_id from categoria where nome_categoria ilike _categoria into var_categoria_id;
	
  IF numero IS NULL
  THEN
    RAISE EXCEPTION 'O nunero do quarto não pode ser nulo ou vazio!';
  ELSEIF _categoria IS NULL OR _categoria LIKE ''
  THEN
    RAISE EXCEPTION 'A categoria não pode ser nula ou vazio!';
  elseif var_categoria_id is null
  then
  	raise exception 'Categoria nao existe';
  ELSE
    INSERT INTO quarto VALUES (default,numero, var_categoria_id);
    RAISE NOTICE 'Quarto cadastrado com sucesso, Obrigado!';
  END IF;
END
$$ LANGUAGE PLPGSQL;


/* TRIGGERS */

/* VIEWS */


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

select cadastrarFuncionario('Ulisses', '60045162360', '123456789012', 'longe pra caralho');