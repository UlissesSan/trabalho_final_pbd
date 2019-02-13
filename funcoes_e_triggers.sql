/* FUNCOES */

/* 
 * Validações
 *  Funcionario {
 * 		- nome nao pode ser vazio nem nulo, nem conter mais de 50 caracteres, nem ser numero
 * 		- cpf nao pode ser vazio nem nulo, deve conter 15 caracteres 
 * 		- telefone, nao pode ser vazio nem nulo, deve conter entre 10 e 11 caracteres
 * 		- endereco nao pode ser vazio nem nulo, deve conter no maximo 100 caracteres
 * 
 * */
CREATE OR REPLACE FUNCTION cadastrarFuncionario(nome_f VARCHAR(50), cpf_f VARCHAR(15), telefone_f VARCHAR(50), endereco_f VARCHAR(100)) RETURNS VOID as $$
declare
	funcionarioID integer;
begin
	select funcionario_id from funcionarios where nome ilike nome_f into funcionarioID;

  IF nome_f IS NULL OR nome_f LIKE ''
  THEN
    RAISE EXCEPTION 'O nome não pode ser nulo ou vazio!';
  elseif funcionarioID is not null then
  	raise exception 'Já existe funcionario cadastrado com esse nome';
  ELSEIF cpf_f IS NULL OR cpf_f LIKE '' THEN
    RAISE EXCEPTION 'O CPF não é nulo ou vazio!';
  ELSEIF telefone_f IS NULL OR telefone_f LIKE '' THEN
    RAISE EXCEPTION 'O telefone não é nulo ou vazio!';
  ELSEIF length(telefone_f) > 11 or length (telefone_f) < 10 THEN
    RAISE EXCEPTION 'Telefone nao pode ter mais de 11 digitos e menos que 10!';
  ELSEIF endereco_f IS NULL OR endereco_f LIKE '' THEN
    RAISE EXCEPTION 'O endereço não pode ser nulo ou vazio!';
  ELSE
    INSERT INTO funcionarios VALUES (default, nome_f, cpf_f, telefone_f, endereco_f);
    RAISE notice 'Funcionario cadastrado com sucesso, Obrigado!';
  END IF;
END
$$
  LANGUAGE PLPGSQL;

/* 
 * - cargo nao pode ser vazio nem nulo
 * - deve ser unico
 * - cargo nao pode ser numerico
 * 
 * */ 
CREATE OR REPLACE FUNCTION cadastrarCargo(cargoNome VARCHAR(50)) RETURNS VOID as $$
declare 
	cargoID integer;
begin
	select cargo_id from cargo where nome_cargo ilike cargoNome into cargoID;

  IF cargo IS NULL OR cargo LIKE '' THEN
    RAISE EXCEPTION 'Cargo não pode ser nulo ou vazio!';
  elseif cargoID is not null then
  	raise exception 'Já existe um cargo cadastrodo com esse nome';
  ELSE
    INSERT INTO cargo VALUES (DEFAULT, cargo);
    RAISE notice 'Funcionario cadastrado com sucesso, Obrigado!';
  END IF;
END
$$ LANGUAGE PLPGSQL;

/* 
 * - categoria nao pode ser vazio nem nulo
 * - no maximo 50 char e nao pode ser numerico
 * */
CREATE OR REPLACE FUNCTION cadastrarCategoria(categoriaNome VARCHAR(50), valor float) RETURNS VOID as $$
declare
	categoriaID integer;
begin
	select categoria_id from categoria where nome_categoria ilike categoriaNome into categoriaID;

  IF categoria IS NULL OR categoria LIKE '' THEN
    RAISE EXCEPTION 'Categoria não pode ser nula ou vazio!';
  elseif categoriaID is not null then
  	raise exception 'Já existe categoria cadastrada com esse nome';
  elseif valor <= 0 or valor is null then
  	raise exception 'Valor incorreto para o valor da categoria';
  ELSE
    INSERT INTO categoria VALUES (DEFAULT, categoria, valor);
    RAISE notice 'Categoria cadastrada com sucesso, Obrigado!';
  END IF;
END
$$ LANGUAGE PLPGSQL;

/* 
 * - nome -> nao pode ser vazio nem nulo, max 50, nao pode numerico, unico
 * - qtd -> nao pode ser negativa e deve ser numerico
 * - descricao -> max 50 char
 * */
CREATE OR REPLACE FUNCTION cadastrarProduto(nome_p VARCHAR(50), tipo_quantidade_p varchar(3), descricao_p varchar(50)) RETURNS VOID as $$
declare
	produtoID integer;
begin
	select produto_id from produtos where nome_produto ilike nome_p into produtoID;

  IF nome_p IS NULL OR nome_p LIKE '' THEN
    RAISE EXCEPTION 'Nome não pode ser nulo ou vazio!';
  elseif produtoID is not null then
  	raise exception 'Já existe produto cadastrado com esse nome';
  ELSEIF tipo_quantidade_p IS NULL OR tipo_quantidade_p LIKE '' THEN
    RAISE EXCEPTION 'Tipo quantidade não pode ser nulo ou vazio!';
  ELSEIF descricao_p IS NULL OR descricao_p LIKE '' THEN
    RAISE EXCEPTION 'Descricao não pode ser nula ou vazia!';
  ELSE
    INSERT INTO produtos VALUES (DEFAULT, nome_p, tipo_quantidade_p, descricao_p);
    RAISE notice 'Produto cadstrado com sucesso, Obrigado!';
    END IF;
END
$$ LANGUAGE PLPGSQL

/* 
 * numero -  nao pode vazio nem nulo, nem negativo, so numero
 * categoria - deve existir na tabela categoria, nao pode ser vazio ou nulo, max 50
 * */
CREATE OR REPLACE FUNCTION cadastrarQuarto(numero integer, _categoria VARCHAR(50)) RETURNS VOID as $$
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

/*
 * Cadastrar Motel
 * - nome motel
 * */
create or replace function cadastrarMotel(nome varchar(50)) returns void as $$
declare
	motelID integer;
begin
	select motel_id from motel where nome_motel ilike nome into motelID;

	if motelID is null then
		insert into motel values (default, nome);
		raise notice 'Motel inserido com sucesso';
	else
		raise exception 'Já existe motel cadastrado com esse nome.'
	end if;

end
$$ language PLPGSQL;


/* funcao criar_quarto_motel
 * numero do quarto
 * categoria
 * motel
 * 
 */
create or replace function cadastrarQuartoMotel(numeroQuarto integer, nomeCategoria varchar(50), nomeMotel varchar(50)) returns void as $$
declare
	categoriaID integer;
	motelID integer;
begin
	
end
$$ language PLPGSQL;


/* funcao ocupar_quarto
 * 		- Quarto, Categoria, funcionario responsavel, motel (CHECAR SE TODOS EXISTEM)
 * 		- Antes do insert criar o Cliente
 * 		- Verficar se o quarto ta livre
 * 		- Muda o estado do quarto para true
 * 
 * 
 *  */

/* funcao libera_quarto
 * 		- Quarto, motel
 * 		- Verificar se esta ocupado o quarto_motel 
 * 		- Muda o status do quarto
 * 
 *  */

/* funcao - interditar quarto */

/* funcao baixa_estoque 
 * 	- vai ser chamada ao usar a funcao adicionar_item_pedido
 * 
 * */

/* funcao adicionar_item_pedido - (nome_produto, quantidade_produto, pedido_id)
 * 		- criar ou atualizar o pedido 
 * 		- verifica se tem no estoque
 *  */


/* TRIGGERS */

/*  1 -  Antes de inserir  quarto verificar se ja existe quarto com aquele exato numero e categoria, nao pode ser inserido */
CREATE OR REPLACE FUNCTION checarNumeroQuartoECategoria() RETURNS TRIGGER as $$
declare
	quartoID integer;
	categoriaID varchar(50);
begin
	select categoria_id from categoria where nome_categoria ilike new.nome_categoria into categoriaID;
  	select quarto_id from quarto where numero = new.numero and categoria_id = categoriaID into quartoID;
  
  	if quarto_id is null then
  		return new;
  	else
    	RAISE exception 'Já existe quarto para essa categoria';
   	end if;
END;
$$ LANGUAGE PLPGSQL;
 
CREATE TRIGGER TGR_checarNumeroQuartoECategoria
  before INSERT
  ON quarto
  FOR EACH ROW
EXECUTE PROCEDURE checarNumeroQuartoECategoria();
/*  2 -  Apos inserir e update (inserir o mesmo item aumentando a quantidade) na tabela item_pedido, 
 * 		atualizar valor total na tabela pedido  */

/* FUNCOES AUXILIARES */
create or replace function pegaIdPorNome(tabela varchar(50), nome_pesquisado varchar(50), valor_pesquisado integer default 0) return integer as $$
declare
	categoriaID integer;
begin
	case
		when tabela = 'funcionarios' then
			return select funcionario_id from funcionarios where nome ilike nome_pesquisado;
		when tabela = 'cargo' then
			return select cargo_id from cargo where nome_nome ilike nome_pesquisado;
		when tabela = 'categoria' then
			return select categoria_id from categoria where nome_categoria ilike nome_pesquisado;
		when tabela = 'motel' then
			return select motel_id from motel where nome_motel ilike nome_pesquisado;
		when tabela = 'produtos' then
			return select produto_id from produtos where nome_produto ilike nome_pesquisado;
		when tabela = 'quarto' then
			categoriaID := pegaIdPorNome('categoria', nome_pesquisado);
			if categoriaID is not null then
				return select quarto_id from quarto where numero = valor_pesquisado and categoria_id = categoriaID;
			else
				raise exception 'Quarto nao existe';
			end if;
	return null;
	end case;
end;