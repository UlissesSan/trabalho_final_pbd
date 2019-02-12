/*
	autores:   Ulisses Santana
		   Deyvid Yuri
*/

/* TABELAS */
DROP TABLE IF EXISTS funcionario;
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


DROP TABLE IF EXISTS motel;
CREATE TABLE motel(
	motel_id SERIAL primary key not null,
	nome_motel varchar(50) not null,
	endereco varchar(100) not null
);


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
);

DROP TABLE IF EXISTS estoque;
CREATE TABLE estoque(
	estoque_id SERIAL primary key not null,
	motelId integer not null,
	produtoId integer not null,
	quantidade integer not null,

	foreign key motelId references motel (motel_id),
	foreign key produtoId references produtos (produto_id)
	
);

DROP TABLE IF EXISTS produtos;
CREATE TABLE produtos(
	produto_id SERIAL primary key not null,
	nome_produto varchar(50) not null,
	tipo_quantidade varchar(50) not null,
	descricao varchar(50)
);

DROP TABLE IF EXISTS quarto_motel;
CREATE TABLE quarto_motel(
	quarto_motel_id SERIAL primary key not null,
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
	nome_categoria varchar(50),
);

DROP TABLE IF EXISTS cliente;
CREATE TABLE cliente (
	cliente_id SERIAL primary key not null,
	ocupacaoId not null,

	foreign key ocupacaoId references ocupacao (ocupacao_id)
);

DROP TABLE IF EXISTS pedido;
CREATE TABLE pedido(
	pedido_id SERIAL primary key not null,
	ocupacaoId not null,

	foreign key ocupacaoId references ocupacao (ocupacao_id)
);

DROP TABLE IF EXISTS item_pedido;
CREATE TABLE item_pedido(
	item_id SERIAL primary key not null
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
    INSERT INTO funcionarios(nome, cpf, telefone, endereco) VALUES (nome_f, cpf_f, telefone_f, endereco_f);
    RAISE EXCEPTION 'Funcionario cadastrado com sucesso, Obrigado!';
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
    RAISE notice 'Funcionario cadastrado com sucesso, Obrigado!';
  END IF;
END
$$ LANGUAGE PLPGSQL;

select cadastrarCategoria('Luxo');
select cadastrarCategoria('Apartamento');
select cadastrarCategoria('');
select * from categoria;





/* TRIGGERS */
t


/* VIEWS */


/* TESTS */
insert into funcionarios (nome, cpf, telefone, endereco) values ('Maycon','60000000000', '8612345678', 'Ladeira do Uruguai');
insert into funcionarios (nome, telefone, endereco) values ('Thais', '8687654321', 'Lourival Parente');
insert into funcionarios (nome, telefone, endereco) values ('zezin', '8687654322', 'puta merda Parente');

insert into cargo (nome_cargo) values ('recepcionista');
insert into cargo (nome_cargo) values ('camarera');
insert into cargo (nome_cargo) values ('gerente');
insert into cargo (nome_cargo) values ('cozinheira');

insert into ocupacao (data_entrada, funcionarioId, cargoId) values ( '2018-10-20', 2, 1);

select cadastrarFuncionario('Ulisses', '60045162360', '123456789012', 'longe pra caralho');

DO $$ BEGIN
    PERFORM cadastrarFuncionario('Ulisses', '60045162360', '123456789012', 'longe pra caralho');
END $$;
