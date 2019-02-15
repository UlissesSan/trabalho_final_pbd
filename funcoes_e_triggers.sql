/* FUNCOES */

/* 
 * Validações
 *  Funcionario {
 * 		- nome nao pode ser vazio nem nulo, nem conter mais de 50 caracteres, nem ser numero
 * 		- cpf nao pode ser vazio nem nulo, deve conter 15 caracteres 
 * 		- telefone, nao pode ser vazio nem nulo, deve conter entre 10 e 11 caracteres
 * 		- endereco nao pode ser vazio nem nulo, deve conter no maximo 100 caracteres
 * */
CREATE OR REPLACE FUNCTION cadastrarFuncionario(nome_f VARCHAR(50), cpf_f VARCHAR(15), telefone_f VARCHAR(50), endereco_f VARCHAR(100)) RETURNS VOID as $$
declare
	funcionarioID integer;
begin
	funcionarioID := pegaIdPorNome('funcionarios', nome_f);

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
END;
$$
  LANGUAGE PLPGSQL;

/* 
 * - cargo nao pode ser vazio nem nulo
 * - deve ser unico
 * - cargo nao pode ser numerico
 * */ 
CREATE OR REPLACE FUNCTION cadastrarCargo(cargoNome VARCHAR(50)) RETURNS VOID as $$
declare 
	cargoID integer;
begin
	cargoID := pegaIdPorNome('cargo', cargoNome);

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
 * - no maximo 50 char
 * */
CREATE OR REPLACE FUNCTION cadastrarCategoria(categoriaNome VARCHAR(50), valor float) RETURNS VOID as $$
declare
	categoriaID integer;
begin
	categoriaID := pegaIdPorNome('categoria', categoriaNome);

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
 * - nome -> nao pode ser vazio nem nulo, max 50, unico
 * - qtd -> nao pode ser negativa e deve ser numerico
 * - descricao -> max 50 char
 * */
CREATE OR REPLACE FUNCTION cadastrarProduto(nome_p VARCHAR(50), tipo_quantidade_p varchar(3), descricao_p varchar(50)) RETURNS VOID as $$
declare
	produtoID integer;
begin
	produtoID := pegaIdPorNome('produtos', nome_p);

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
$$ LANGUAGE PLPGSQL;

/* 
 * numero -  nao pode vazio nem nulo, nem negativo, so numero
 * categoria - deve existir na tabela categoria, nao pode ser vazio ou nulo, max 50
 * */
CREATE OR REPLACE FUNCTION cadastrarQuarto(numero integer, _categoria VARCHAR(50)) RETURNS VOID as $$
declare
  var_categoria_id integer;
	quartoID integer;
begin
  var_categoria_id := pegaIdPorNome('categoria', _categoria);
  quartoID := pegaIdPorNome('quarto', _categoria, numero);
 
  IF numero IS null THEN
    RAISE EXCEPTION 'O nunero do quarto não pode ser nulo ou vazio!';
  ELSEIF _categoria IS NULL OR _categoria LIKE '' THEN
    RAISE EXCEPTION 'A categoria não pode ser nula ou vazio!';
  elseif var_categoria_id is null then
    raise exception 'Categoria nao existe';
  elseif quartoID is not null then
  	raise exception 'Já existe quarto com esse numero e categoria';
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
	motelID := pegaIdPorNome('motel', nome);

	if motelID is null then
		insert into motel values (default, nome);
		raise notice 'Motel inserido com sucesso';
	else
		raise exception 'Já existe motel cadastrado com esse nome.';
	end if;

end;
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
	quartoID integer;
begin
	categoriaID := pegaIdPorNome('categoria', nomeCategoria);
	motelID := pegaIdPorNome('motel', nomeMotel);
	quartoID := pegaIdPorNome('quarto', nomeCategoria, numeroQuarto);

	if nomeCategoria is null or nomeCategoria like '' then
		raise exception 'Categoria nao pode ser vazia';
	elseif nomeMotel is null or nomeMotel like '' then
		raise exception 'Motel nao pode ser vazio';
	elseif categoriaID is null then
		raise exception 'A categoria informada nao existe';
	elseif motelID is null then
		raise exception 'O motel informado nao existe';
	elseif quartoID is null then
		raise exception 'O numero do quarto e a categoria nao existem';
	else
		insert into quarto_motel values (quartoID, motelID);
		raise notice 'Quarto cadastrado no motel';
	end if;
end
$$ language PLPGSQL;


/* funcao ocupar_quarto
 * 		- Quarto, Categoria, funcionario responsavel, motel (CHECAR SE TODOS EXISTEM)
 * 		- Antes do insert criar o Cliente
 * 		- Verficar se o quarto ta livre
 * 		- Muda o estado do quarto para true
 *  */
create or replace function ocuparQuarto(numeroQuarto integer, nomeCategoria varchar(50), nomeFuncionario varchar(50), nomeMotel varchar(50))
returns void as $$
declare
	quartoID integer;
	categoriaID integer;
	funcionarioID integer;
	motelID integer;
	quartoExiste boolean;
	quartoLivre boolean;
	clienteID integer;
begin
	categoriaID := pegaIdPorNome('categoria', nomeCategoria);
	motelID:= pegaIdPorNome('motel', nomeMotel);
	funcionarioID := pegaIdPorNome('functionarios', nomeFuncionario);
	quartoID := pegaIdPorNome('quarto', nomeCategoria, numeroQuarto);

	if funcionarioID is null then
		raise exception 'Funcionario nao existe';
	elseif motelID is null then
		raise exception 'Motel nao existe';
	end if;

	select case when count(*) = 1 then true else false end from quarto_motel where motel_id = motelID and quarto_id = quartoID into quartoExiste;
	select ocupado from quarto_motel where quarto_id = quartoID and motel_id = motelID into quartoLivre;

	if quartoExiste then
		if quartoLivre then
			clienteID := insert into cliente values (default) returning cliente_id;
			insert into ocupacao (ocupacao_id, entrada, funcionario_id, motel_id, quarto_id, cliente_id)
						  values (default, now(), funcionarioID, motelID, quartoID, clienteID);
			update quarto_motel set ocupado = true where motel_id = motelID and quarto_id = quartoID;
			raise notice 'Quarto ocupado com sucesso';
		else
			raise exception 'Quarto ocupado';
		end if;
	else
		raise exception 'Quarto nao exite';
	end if;
end
$$ language PLPGSQL;

/* funcao liberar_quarto
 * 		- Quarto, motel
 * 		- Verificar se esta ocupado o quarto_motel 
 * 		- Muda o status do quarto 
 *  */
create or replace function liberar_quarto(motelID integer, quartoID integer) returns void as $$
declare
	quarto_ocupado boolean default false;
begin
	select ocupado from quarto_motel where quarto_id = quartoID and motel_id = motelID into quarto_ocupado;

	if quarto_ocupado = true then
		raise exception 'Quarto já esta livre!';
	else
		/* colocando a hora da saida*/
		update ocupacao set saida = now() where motel_id = motelID and quartoID = quartoID;
		update quarto_motel set ocupado = true where motel_id = motelID and quarto_id = quartoID;
		raise notice 'Quarto liberado com sucesso!'
	end if;
end
$$ language PLPGSQL;

/* funcao baixa_estoque 
 * 	- vai ser chamada ao usar a funcao adicionar_item_pedido
 * */
create or replace FUNCTION baixaEstoque(nomeProduto varchar(50), quantidade integer, nomeMotel varchar(50)) returns boolean as $$
declare
	produtoID integer;
	motelID integer;
	estoqueID integer;
	quantidadeNoEstoque integer;
begin
	produtoID := pegaIdPorNome('produtos', nomeProduto);
	motelID := pegaIdPorNome('motel', nomeMotel);

	if produtoID is null then
		raise exception 'Produto nao existe';
	elseif motelID is null then
		raise exception 'Motel nao existe';
	else
		-- checar se produto existe no estoque do motel na quantidade necessaria
		select estoque_id, quantidade from estoque where produto_id = produtoID and motel_id = motelID into estoqueID, quantidadeNoEstoque;
		if estoqueID is not null then
			if quantidadeNoEstoque >= quantidade then
				update estoque set quantidade = quantidadeNoEstoque - quantidade where produto_id = produtoID and motel_id = motelID;
				raise notice 'Estoque atualizado.';
				return true;
			else
				raise exception 'Produto em quantidade insuficiente. Quantidade em estoque: %', quantidadeNoEstoque;
		else
			raise exception 'Produto nao existe no estoque deste motel';
	end if;
	return false;
end;
$$ language PLPGSQL;


/*
	Fazer pedido
	- quarto
	- produto
	- quantidade produto
	- motel
*/
create or replace function fazerPedido(numeroQuarto integer, nomeCategoria varchar(50), nomeProduto varchar(50), quantidadeProduto integer, nomeFuncionario varchar(50), nomeMotel varchar(50)) returns void as $$
declare
	quartoID integer;
	categoriaID integer;
	produtoID integer;
	motelID integer;
	ocupacaoID integer;
	clienteID integer;
	funcionarioID integer;
begin
	motelID := pegaIdPorNome('motel', nomeMotel);
	produtoID := pegaIdPorNome('produtos', nomeProduto);
	categoriaID := pegaIdPorNome('categoria', nomeCategoria);
	quartoID := pegaIdPorNome('quarto', categoriaID, numeroQuarto);
	funcionarioID := pegaIdPorNome('funcionarios', nomeFuncionario);

	select ocupacao_id from ocupacao where motel_id = motelID and quarto_id = quartoID and funcionario_id = funcionarioID into ocupacaoID;

	
end;
$$ language PLPGSQL;

/* funcao adicionar_item_pedido - (nome_produto, quantidade_produto, pedido_id)
 * 		- criar ou atualizar o pedido 
 * 		- verifica se tem no estoque
 *  */
create or replace function adicionarItemPedido(nomeProduto varchar(50), quantidadeProduto integer, pedidoID integer) returns void as $$
declare
	produtoID integer;
	motelID integer;
	motelNome varchar(50);
begin
	produtoID := pegaIdPorNome('produtos', nomeProduto);

	select m.motel_id, m.nome_motel
	from motel m 
	inner join ocupacao o on m.motel_id = o.motel_id
	inner join pedido p on p.ocupacao_id = p.ocupacao_id
	where p.pedido_id = pedidoID into motelID, motelNome;

	if (select count(*) from item_pedido where pedido_id = pedidoID and produto_id = produto_id) = 0 then
		if (baixaEstoque(nomeProduto, quantidadeProduto, nomeMotel)) then
			insert into item_pedido values (pedidoID, produtoID, quantidadeProduto);
		end if;
	else
		if (baixaEstoque(nomeProduto, quantidadeProduto, nomeMotel)) then
			update item_pedido set quantidade = quantidade + quantidadeProduto where pedido_id = pedidoID and produto_id = produtoID;
		end if;
	end if;
end;
$$ language PLPGSQL;


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
create or replace function pegaIdPorNome(tabela varchar(50), nome_pesquisado varchar(50), valor_pesquisado integer default 0) returns integer as $$
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
		else
			raise exception 'Tabela nao existe';
	end case;
end;
$$ language PLPGSQL;

/* soma das horas no quarto + consumo = seria dt_entrada - dt_saida + valor */
create or replace function conta_cliente(clienteID integer) returns void as $$
declare
	clienteID integer;
	motelID integer;
	quartoID varchar(50);
	categoriaID integer;

	entrada timestamp;
	saida timestamp;
	tempo_utilizado float;
	categoria_valor float;

	total_pedido float;
	
	total_conta float;
	
begin
	select quarto_id from ocupacao where cliente_id = clienteID into quartoID;
	
	select categoria from quarto where quarto_id = quartoID into categoriaID;
	select valor_categoria from categoria where categoria_id = categoriaID into categoria_valor;

	select entrada from ocupacao where cliente_id = clienteID into entrada;
	select saida from ocupacao where cliente_id = clienteID into saida;
	select datediff(hour, entrada, saida) into tempo_utilizado;
	
	select ocupacao_id from ocupacao where cliente_id = clienteID into ocupacaoID;	
	select total from pedido where ocupacao_id = ocupacaoID into total_pedido;

	total_conta = total_pedido + (tempo_utilizado * categoria_valor);

	update ocupacao set conta_valor = total_conta where cliente_id = clienteID;
end;
$$ language PLPGSQL;