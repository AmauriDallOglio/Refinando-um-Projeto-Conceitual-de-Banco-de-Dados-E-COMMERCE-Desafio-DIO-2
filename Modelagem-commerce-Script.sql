-- Modelagem Ecommerce
-- Criação do banco de dados para o cenário de e-commerce.

-- Criação da database
-- create database ecommerce;
use ecommerce;

-- drop database ecommerce
/*
drop table Clients;
drop table Product;
drop table orders;
drop table ProductStorage;
drop table Supplier;
drop table Seller;
drop table productSeller;
drop table productOrder;
drop table storageLocation;
drop table productSupplier;
*/

-- Criando tabela cliente
create table Clients(
	idClient int auto_increment primary key,
    FName varchar(10),
    Minit char(3),
    LName varchar(20),
    CPF char(11) not null,
    Address varchar(30),
    constraint unique_cpf_client unique (CPF)
);
alter table Clients auto_increment=1;

insert into Clients (Fname, Minit, Lname, CPF, Address) 
values ('Maria','M','Silva', '123456789', 'Rua 1, Brusque'),
	   ('Ana','O','Dall', '12345678901', 'Rua 2, Brusque'),
	   ('Amauri','S','Dall Oglio', '00512282001', 'Rua 3, Brusque');
insert into Clients (Fname, Minit, Lname, CPF, Address) values   ('Amauri 2','S','Dall Oglio', '00512282002', 'Rua 3, Brusque');

-- desc Clients
-- select * from Clients

-- criando a tabela de pagamento
CREATE TABLE payments(
    idPayment int auto_increment primary key,
    typePayment enum('Boleto','Cartão de crédito')
);
ALTER TABLE payments auto_increment=1;
-- drop table payments
insert into payments(typePayment) values ('Boleto'), ('Cartão de crédito');
-- select * from payments



-- Criando tabela produto
create table Product(
	 idProduct int auto_increment primary key,
	 PName varchar(10) not null,
	 classification_kids bool default false,
	 category enum('Eletrônicos', 'Vestuários','Brinquedos','Alimentos','Móveis') not null,
	 avaliação float default 0,
	 size varchar(10)
);
alter table Product auto_increment=1;

insert into Product (PName, classification_kids, category, avaliação, size)
values ('Fone', false, 'Eletrônicos', '4', 'null'),
	   ('Barbie', true, 'Brinquedos', '3', 'null'),
       ('Body Carte', true, 'Vestuários', '5', 'null'),
	   ('Microfone', false, 'Eletrônicos', '4', 'null'),
       ('Sofá', false, 'Móveis', '3', '3x57x80');

-- desc Products
-- drop table Products;
-- select * from Product;



/*
-- Criando tabela de pagamento
create table payments (
	 idclient int,
	 idPayment int,
	 typePayment enum('Boleto', 'Cartão', 'Multiplos Cartões'),
	 limitAvailable float,
	 primary key (idclient, idPayment)
);
*/

-- Criando tabela pedido
create table orders (
	 idOrder int auto_increment primary key,
	 idOrderClient int, 
     idOrderPayment int,
	 orderStatus enum('Cancelado', 'Confirmado', 'Em processamento') default 'Em processamento',
	 orderDescription varchar(255),
	 sendValue float default 10,
	 paymentCash bool default false,
     -- criar as contraint de pagamento
	 constraint fk_orders_clients foreign key (idOrderClient) references Clients(idclient),
     constraint fk_order_payment foreign key (idOrderPayment) references payments(idPayment)
	 on update cascade
 );
 alter table orders auto_increment=1;
 
 insert into orders( idOrderClient, idOrderPayment, orderStatus, orderDescription, sendValue, paymentCash) 
 values (1, 2, default, 'compra via aplicativo', null, 1),
        (2, 2, default, 'compra via aplicativo', 50, 0),
        (3, 2, 'Confirmado', null, null, 1),
        (4, 2, default, 'compra via web', 150, 0);
 
 
 
--  desc orders
-- drop table orders;
-- select * from orders
-- delete from orders where idOrderClient in (1,2,3,4);

-- criando tabela de relacionamento entre produto e pedido (N:N)
 create table productOrder(
      idPOproduct int,
      idPOorder int,
      poQuantity int default 1,
      poStatus enum('Disponível', 'Sem Estoque') default 'Disponível',
      primary key(idPOproduct, idPOorder),
      constraint fk_productOrder_seller foreign key (idPOproduct) references Product(idProduct),
      constraint fk_productOrder_product foreign key (idPOorder) references orders(idOrder)
);
 alter table productOrder auto_increment=1;

insert into productOrder (idPOproduct, idPOorder, poQuantity, poStatus)
values (11, 9, 2, null),
       (12, 10, 1, null),
       (13, 11, 1, null);
	
 
-- select * from productOrder
-- delete from productOrder;



-- Criando tabela estoque
create table productStorage(
	idProductStorage int auto_increment primary key,
    storageLocation varchar(255),
    quantity int default 0
);
 alter table productStorage auto_increment=1;
 
  insert into productStorage (storageLocation, quantity)
 values ('Rio de janeiro', 1000),
	    ('Rio de janeiro', 500),
		('São Paulo', 10),
        ('São Paulo', 100),
        ('São Paulo', 10);
 
--  desc ProductStorage;
-- select * from productStorage;

-- local de estoque
create table storageLocation(
     idLproduct int,
     idLstorage int,
     location varchar(255) not null,
     primary key (idLproduct, idLstorage),
     constraint fk_storageLocation_product foreign key (idLproduct) references Product(idProduct),
	 constraint fk_storageLocation_storage foreign key (idLstorage) references productStorage(idProductStorage)
);
 alter table storageLocation auto_increment=1;
insert into storageLocation (idLproduct, idLstorage, location) 
values (11, 2,'RJ'),
       (12, 5,'GO');
       
-- select * from storageLocation;
--  desc orders


-- Criando tabela de fornecedor
create table Supplier(
	idSupplier int auto_increment primary key,
    socialName varchar(255) not null,
    CNPJ char(15) not null,
    contact char(11) not null,
    constraint unique_supplier unique (CNPJ)
);
 alter table Supplier auto_increment=1;
--  desc Supplier
 insert into Supplier (socialName, CNPJ, contact) 
 values ('Almeida e filhos', '123456000101','999332211'),
  ('Almeida e mãe', '123456000102','999332212'),
  ('Almeida e irmão', '000111222000103','999332213');
-- drop table Supplier

-- select * from Supplier


-- Produto fornecedor  Fornecedor_Vende_Produto
create table productSupplier(
	 idproductSupplier int auto_increment primary key,
	 idPsSupplier int,
     idPsProduct int,
     quantity int not null,
   --  primary key(idPsSupplier, idPsProduct),
     constraint fk_product_supplier_supplier foreign key (idPsSupplier) references Supplier(idSupplier),
	 constraint fk_product_supplier_product foreign key (idPsProduct) references Product(idProduct)
);
 alter table productSupplier auto_increment=1;
-- drop table productSupplier
-- select * from Supplier;
-- select * from Product;
insert into productSupplier (idPsSupplier, idPsProduct, quantity)
values (1,1,500),
		(1,1,135),
		(2,2,155),
		(3,3,145),
		(2,4,100);

-- select * from productSupplier

-- Criando a tabela vendedor
create table Seller(
	idSeller int auto_increment primary key,
    SocialName varchar(255) not null, 
	AbstName varchar(255),
	CNPJ char(15) not null,
	CPF char(9) not null,
	location varchar(255),
	contact varchar(11) not null,
	constraint unique_cnpj_seller unique (CNPJ),
	constraint unique_cpf_seller unique (CPF)
);
 alter table Seller auto_increment=1;
--  desc Seller
insert into Seller (SocialName, AbstName, CNPJ, CPF, location, contact)
values ('Amauri Seller', null, '000111222000102', 00122233301, 'Rio de janeiro', 999332211),
       ('Amauri Seller 2', null, '000111222000103', 00122233302, 'Riozinho', 999334455);

-- select * from Seller


-- criando a tabela Produtos_De_Terceiro de relacionamento de terceiro e produto (N:N)
 create table productSeller(
      idPseller int,
      idPproduct int,
      prodQuantity int default 1,
      primary key (idPSeller, idPProduct),
      constraint fk_product_seller foreign key (idPseller) references Seller(idSeller),
      constraint fk_product_product foreign key (idPproduct) references Product(idProduct)
);
 alter table productSeller auto_increment=1;
--  desc productSeller
insert into productSeller (idPseller, idPproduct, prodQuantity)
values (7, 11, 80),
       (8, 12, 10);

-- select * from productSeller
 

select * from 
clients as cliente, orders as pedido
where
cliente.idClient = idOrderClient;

-- Quantos pedidos foram feitos por cada cliente?
select 
	CONCAT(cliente.Fname, ' ', cliente.Lname) as 'Cliente', count(pedido.idOrderClient) as 'Quantidade_de_pedido'
from 
	orders as pedido
    inner join clients as cliente on pedido.idOrderClient = cliente.idClient
group by 
	cliente.idClient
order by 
	count(pedido.idOrderClient) desc, cliente.Fname;


-- Quantidade de compras feitas via aplicaitvo e pagamento feito em cartão de crédito
-- select * from orders
-- select * from payments
select pedido.orderDescription as 'Origem', pagamento.typePayment as 'TipoPagameto',  sum(1) as 'Qtd'
from orders as pedido
	inner join payments as pagamento on pagamento.idPayment = pedido.idOrderPayment	
where pedido.idOrderPayment = 2 and pedido.orderDescription like 'compra via aplicativo'
group by pedido.orderDescription;
 
 
 -- Vendedores quem também são fornecedores
 -- select * from seller;
 -- select * from supplier;
 select distinct 
	vendedor.socialName
from 
	seller as vendedor 
	join supplier as fornecedor on vendedor.CNPJ = fornecedor.CNPJ
order by vendedor.socialName;
 
 
 
 -- Relação de produtos fornecedores e estoques
 select * from product;
 select * from productSupplier;
 select * from supplier;
 select 
	Produto.pName as 'Produto' ,Fornecedor.socialName as 'Fornecedor' ,ProdutoForncedor.quantity as 'Quantidade'
from 
	productSupplier as ProdutoForncedor 
    inner join product as Produto on Produto.idProduct = ProdutoForncedor.idPsProduct
	inner join supplier as Fornecedor on Fornecedor.idSupplier = ProdutoForncedor.idPsSupplier
order by Produto.pName;
 
 
 -- Relação de produtos fornecedores que possurm em estoque entre 130 e 160
 select * from product;
 select * from productSupplier;
 select * from supplier;
 select 
	Produto.pName as 'Produto' ,Fornecedor.socialName as 'Fornecedor' ,ProdutoForncedor.quantity as 'Quantidade'
from 
	productSupplier as ProdutoForncedor 
    inner join product as Produto on Produto.idProduct = ProdutoForncedor.idPsProduct
	inner join supplier as Fornecedor on Fornecedor.idSupplier = ProdutoForncedor.idPsSupplier
where 
	ProdutoForncedor.quantity >= 130 and ProdutoForncedor.quantity <= 160
order by Produto.pName;


 
 
 
/*
desc productSupplier;
show tables;

clients
orders
product
productorder
products
productseller
productstorage
productsupplier
seller
storagelocation
supplier

*/



/*
use information_schema;
show tables;


CHECK_CONSTRAINTS
REFERENTIAL_CONSTRAINTS
TABLE_CONSTRAINTS
TABLE_CONSTRAINTS_EXTENSIONS

*/



/*
show tables;
desc table_constraints;

CONSTRAINT_CATALOG
CONSTRAINT_SCHEMA
CONSTRAINT_NAME
TABLE_SCHEMA
TABLE_NAME
CONSTRAINT_TYPE
ENFORCED

*/




/*
show tables;
desc referential_constraints;


UPDATE_RULE	enum('NO ACTION','RESTRICT','CASCADE','SET NULL','SET DEFAULT')	NO			
UNIQUE_CONSTRAINT_SCHEMA	varchar(64)	NO			
UNIQUE_CONSTRAINT_NAME	varchar(64)	YES			
UNIQUE_CONSTRAINT_CATALOG	varchar(64)	NO			
TABLE_NAME	varchar(64)	NO			
REFERENCED_TABLE_NAME	varchar(64)	NO			
MATCH_OPTION	enum('NONE','PARTIAL','FULL')	NO			
DELETE_RULE	enum('NO ACTION','RESTRICT','CASCADE','SET NULL','SET DEFAULT')	NO			
CONSTRAINT_SCHEMA	varchar(64)	NO			
CONSTRAINT_NAME	varchar(64)	YES			
CONSTRAINT_CATALOG	varchar(64)	NO			



select * from referential_constraints where constraint_schema = 'ecommerce'

*/





