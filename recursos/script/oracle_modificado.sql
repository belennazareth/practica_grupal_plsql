create table Ingredientes
(
 Codigo    varchar2(4),
 Nombre    varchar2(25),
 Tipo    varchar2(25),
 constraint pkIngrediente primary key (Codigo),
 constraint ckNombreIngredientes unique(Nombre)
);

create table CompIngredientesPre
(
 CodigoIngredienteBase  varchar2(4),
 CodigoIngredienteFinal  varchar2(4),
 Cantidad   varchar2(25),
 constraint pkIngredientePre primary key(CodigoIngredienteBase, CodigoIngredienteFinal),
 constraint fkIngredienteBase foreign key(CodigoIngredienteBase) references Ingredientes (Codigo),
 constraint fkIngredienteFinal foreign key(CodigoIngredienteFinal) references Ingredientes (Codigo)
);

create table Investigadores
(
 NIF    varchar2(9),
 Nombre    varchar2(25),
 Apellidos   varchar2(35),
 Direccion   varchar2(50),
 Telefono   varchar2(9) constraint telefonoNecesario not null,
 Especialidad   varchar2(35),
 constraint pkInvestigador primary key(NIF),
 constraint dniValido  check(regexp_like(NIF,'[0-9]{8}[A-z]') or regexp_like(NIF,'[K,L,M,X,Y,Z][0-9]{7}[A-z]')),
 constraint telefonoValido check(regexp_like(Telefono,'^[6,7][0-9]{8}')),
 constraint ckTelefonoInvestiga unique(Telefono)
);

create table Experimentos
(
 Codigo    varchar2(7),
 NIFInvestigador   varchar2(9),
 Nombre    varchar2(30),
 FechaInicio   date,
 FechaFin   date,
 constraint pkExperimento primary key(Codigo),
 constraint fkNIFExperimento foreign key(NIFInvestigador) references Investigadores(NIF),
 constraint nombreValido  check(Nombre = initcap(Nombre)),
 constraint fechaInicioValida check(to_char(FechaInicio,'W')='1'),
 constraint codigoValido  check(regexp_like(Codigo,'[A-z][0-9]{4}-[A-z]')),
 constraint ckNombreExperimentos unique(Nombre)
);

create table Versiones
(
 Codigo    varchar2(9),
 CodigoExperimento  varchar2(7),
 FechaPrueba   date,
 constraint pkVersion  primary key(Codigo,CodigoExperimento),
 constraint fkExperimentoVersion foreign key(CodigoExperimento) references Experimentos (Codigo),
 constraint fechaPruebaValida check(to_char(FechaPrueba,'D') = '7'),
 constraint horaPruebaValida check(to_char(FechaPrueba,'HH24') between '11' and '14'),
 constraint codigoVersionValido check(regexp_like(Codigo,'^[0-9][\d]*(\.[0-9][\d]*)*(.\*)?|\*$'))
);

create table Colaboraciones
(
 CodigoExperimento  varchar2(7),
 CodigoVersion   varchar2(9),
 NIFInvestigador   varchar2(9),
 constraint pkColabora  primary key(CodigoExperimento, CodigoVersion, NIFInvestigador),
 constraint fkVersColabora foreign key(CodigoVersion,CodigoExperimento) references Versiones (Codigo,CodigoExperimento),
 constraint fkNIFColabora foreign key(NIFInvestigador) references Investigadores
);

create table IngredientesPorVersion
(
 CodigoIngrediente  varchar2(4),
 CodigoExperimento  varchar2(7),
 CodigoVersion   varchar2(9),
 Cantidad   number(3,1),
 constraint pkIngredienteVersion primary key(CodigoIngrediente,CodigoExperimento,CodigoVersion),
 constraint fkIngredienteVersion foreign key(CodigoIngrediente) references Ingredientes (Codigo),
 constraint fkVersIngreVersi foreign key(CodigoVersion,CodigoExperimento) references Versiones (Codigo,CodigoExperimento),
 constraint cantidadMaxima check(Cantidad <= 90)
);

create table Catadores
(
 NIF    varchar2(9),
 Nombre    varchar2(25),
 Apellidos   varchar2(35),
 Direccion   varchar2(50),
 Telefono   varchar2(9),
 constraint pkCatador  primary key(NIF),
 constraint dniValidoCatador check(regexp_like(NIF,'[0-9]{8}[A-z]') or regexp_like(NIF,'[K,L,M,X,Y,Z][0-9]{7}[A-z]')),
 constraint telefonoValidoCata check(regexp_like(Telefono,'^[9,6,7][0-9]{8}')),
 constraint ckTelefonoCatadores unique(Telefono)
);


create table Aspectos
(
 Codigo    varchar2(4),
 Descripcion   varchar2(100),
 Importancia   varchar2(8),
 constraint pkAspecto  primary key(Codigo),
 constraint importanciaValida check(Importancia in ('Muy Alta','Alta','Media','Baja')),
 constraint ckDescripcionAspe unique(Descripcion)
);

create table Puntuaciones
(
 NIFCatador   varchar2(9),
 CodigoAspecto   varchar2(4),
 CodigoExperimento  varchar2(7),
 CodigoVersion   varchar2(9),
 Valor    number(3,1),
 constraint pkPuntuacion  primary key(NIFCatador,CodigoAspecto,CodigoExperimento,CodigoVersion),
 constraint fkCatadorPuntua foreign key (NIFCatador) references Catadores (NIF),
 constraint fkAspectoPuntua foreign key (CodigoAspecto) references Aspectos (Codigo),
 constraint fkVersionPuntua foreign key (CodigoVersion,CodigoExperimento) references Versiones (Codigo,CodigoExperimento),
 constraint valorValido  check(Valor <= 10)
);

-- inserts

insert into Ingredientes values('0001','Bacalao','Pescado');
insert into Ingredientes values('0002','Patata','Hortaliza');
insert into Ingredientes values('0003','Harina','Cereal');
insert into Ingredientes values('0004','Huevo','Ovum');
insert into Ingredientes values('0005','Cebolleta','Hortaliza');
insert into Ingredientes values('0006','Ajo','Hortaliza');
insert into Ingredientes values('0007','Levadura','Cereal');
insert into Ingredientes values('0008','Perejil','Planta');
insert into Ingredientes values('0009','Laurel','Planta');
insert into Ingredientes values('0010','Guisante','Legumbre');
insert into Ingredientes values('0011','Vino Blanco','Condimento');
insert into Ingredientes values('0012','Almeja','Molusco');
insert into Ingredientes values('0013','Aceite Oliva','Vegetal');
insert into Ingredientes values('0014','Salsa Verde','Salsa');
insert into Ingredientes values('0015','Platano','Fruta');
insert into Ingredientes values('0016','Nuez','Fruto Seco');
insert into Ingredientes values('0017','Azucar Moreno','Sacarosa');
insert into Ingredientes values('0018','Azucar','Sacarosa');
insert into Ingredientes values('0019','Naranja','Fruta');
insert into Ingredientes values('0020','Maizena','Fecula');
insert into Ingredientes values('0021','Canela','Especia');
insert into Ingredientes values('0022','Zumo Naranja','Zumo');
insert into Ingredientes values('0023','Cordero','Animal');
insert into Ingredientes values('0024','Berenjena','Verdura');
insert into Ingredientes values('0025','Cebolla','Hortaliza');
insert into Ingredientes values('0026','Pimiento Verde','Verdura');
insert into Ingredientes values('0027','Tomate Frito','Verdura');
insert into Ingredientes values('0028','Pasas','Fruto Seco');
insert into Ingredientes values('0029','Queso','Lacteo');
insert into Ingredientes values('0030','Empanadilla','Pasta');
insert into Ingredientes values('0031','Yogur Griego','Lacteo');
insert into Ingredientes values('0032','Mostaza','Salsa');
insert into Ingredientes values('0033','Miel','Dulce');
insert into Ingredientes values('0034','Sal','Condimento');
insert into Ingredientes values('0035','Pimienta','Condimento');
insert into Ingredientes values('0036','Salsa de Miel','Salsa');
insert into Ingredientes values('0037','Zanahoria','Verdura');
insert into Ingredientes values('0038','Atun','Pescado');
insert into Ingredientes values('0039','Aceituna S/H','Fruto');
insert into Ingredientes values('0040','Pimiento Piqui','Hortaliza');
insert into Ingredientes values('0041','Pepinillo','Hortaliza');
insert into Ingredientes values('0042','Leche','Lacteo');
insert into Ingredientes values('0043','Aceite Girasol','Vegetal');
insert into Ingredientes values('0044','Agua','Liquido');
insert into Ingredientes values('0045','Oregano','Especia');
insert into Ingredientes values('0046','Regana','Condimento');
insert into Ingredientes values('0047','Crema Naranja','Crema');

insert into compingredientespre values('0006','0014','10');
insert into compingredientespre values('0010','0014','30');
insert into compingredientespre values('0008','0014','2');
insert into compingredientespre values('0003','0014','5');
insert into compingredientespre values('0011','0014','10');
insert into compingredientespre values('0012','0014','50');
insert into compingredientespre values('0013','0014','15');
insert into compingredientespre values('0019','0022','5');
insert into compingredientespre values('0022','0047','45');
insert into compingredientespre values('0004','0047','15');
insert into compingredientespre values('0018','0047','5');
insert into compingredientespre values('0020','0047','5');
insert into compingredientespre values('0013','0047','10');
insert into compingredientespre values('0021','0047','10');
insert into compingredientespre values('0031','0036','20');
insert into compingredientespre values('0032','0036','15');
insert into compingredientespre values('0033','0036','10');
insert into compingredientespre values('0013','0036','15');
insert into compingredientespre values('0034','0036','5');
insert into compingredientespre values('0035','0036','5');
insert into compingredientespre values('0003','0046','50');
insert into compingredientespre values('0013','0046','20');
insert into compingredientespre values('0044','0046','30');
insert into compingredientespre values('0045','0046','15');
insert into compingredientespre values('0034','0046','5');
insert into compingredientespre values('0035','0046','5');

insert into investigadores values('41254785F','Pedro','Ramirez Garcia','A/ Cadiz 4, Sevilla','621448552','Postres');
insert into investigadores values('48521484V','Rosa','Perez Odonez','A/ Malaga 9, Sevilla','625588998','Pescados');
insert into investigadores values('52146359T','Anacleto','Dominguez Uruza','C/ Jazmineras 3, Sevilla','622119884','Pescados');
insert into investigadores values('54215869Q','Cristina','Sola Comino','Plaza Alfaro 7, Sevilla','622113336','Postres');
insert into investigadores values('46321475G','Marcos','Tinajero Morata','C/ Agua 1, Sevilla','695842155','Carnes');

insert into experimentos values('A0001-A','48521484V','Bunulao',to_date('02082016','DDMMYYYY'),to_date('10112016','DDMMYYYY'));
insert into experimentos values('A0002-A','41254785F','Bizplanja',to_date('05052016','DDMMYYYY'),to_date('12082016','DDMMYYYY'));
insert into experimentos values('A0003-A','46321475G','Encorel',to_date('04082016','DDMMYYYY'),to_date('28122016','DDMMYYYY'));
insert into experimentos values('A0004-A','54215869Q','Enruna',to_date('02042016','DDMMYYYY'),to_date('10102016','DDMMYYYY'));

insert into versiones values('0.0.1','A0001-A',to_date('13082016 11:25','DDMMYYYY HH24:MI'));
insert into versiones values('0.0.2','A0001-A',to_date('20082016 11:40','DDMMYYYY HH24:MI'));
insert into versiones values('0.0.3','A0001-A',to_date('05112016 11:25','DDMMYYYY HH24:MI'));
insert into versiones values('0.0.1','A0002-A',to_date('14052016 11:25','DDMMYYYY HH24:MI'));
insert into versiones values('0.0.2','A0002-A',to_date('06082016 11:25','DDMMYYYY HH24:MI'));
insert into versiones values('0.0.1','A0003-A',to_date('27082016 13:40','DDMMYYYY HH24:MI'));
insert into versiones values('0.0.2','A0003-A',to_date('24122016 13:40','DDMMYYYY HH24:MI'));
insert into versiones values('0.0.1','A0004-A',to_date('16042016 11:25','DDMMYYYY HH24:MI'));
insert into versiones values('0.0.2','A0004-A',to_date('08102016 12:05','DDMMYYYY HH24:MI'));

insert into colaboraciones values('A0001-A','0.0.1','46321475G');
insert into colaboraciones values('A0001-A','0.0.1','54215869Q');
insert into colaboraciones values('A0001-A','0.0.2','41254785F');
insert into colaboraciones values('A0001-A','0.0.2','52146359T');
insert into colaboraciones values('A0002-A','0.0.1','46321475G');
insert into colaboraciones values('A0002-A','0.0.1','52146359T');
insert into colaboraciones values('A0002-A','0.0.2','46321475G');
insert into colaboraciones values('A0002-A','0.0.2','52146359T');
insert into colaboraciones values('A0003-A','0.0.1','48521484V');
insert into colaboraciones values('A0003-A','0.0.1','52146359T');
insert into colaboraciones values('A0003-A','0.0.2','41254785F');
insert into colaboraciones values('A0003-A','0.0.2','52146359T');
insert into colaboraciones values('A0004-A','0.0.1','46321475G');
insert into colaboraciones values('A0004-A','0.0.1','52146359T');
insert into colaboraciones values('A0004-A','0.0.2','46321475G');
insert into colaboraciones values('A0004-A','0.0.2','52146359T');

insert into ingredientesporversion values('0001','A0001-A','0.0.1',90);
insert into ingredientesporversion values('0002','A0001-A','0.0.1',50);
insert into ingredientesporversion values('0003','A0001-A','0.0.1',20);
insert into ingredientesporversion values('0004','A0001-A','0.0.1',2);
insert into ingredientesporversion values('0005','A0001-A','0.0.1',10);
insert into ingredientesporversion values('0001','A0001-A','0.0.2',90);
insert into ingredientesporversion values('0002','A0001-A','0.0.2',50);
insert into ingredientesporversion values('0003','A0001-A','0.0.2',20);
insert into ingredientesporversion values('0004','A0001-A','0.0.2',2);
insert into ingredientesporversion values('0005','A0001-A','0.0.2',10);
insert into ingredientesporversion values('0006','A0001-A','0.0.2',1);
insert into ingredientesporversion values('0007','A0001-A','0.0.2',5);
insert into ingredientesporversion values('0008','A0001-A','0.0.2',2);
insert into ingredientesporversion values('0009','A0001-A','0.0.2',4);
insert into ingredientesporversion values('0001','A0001-A','0.0.3',90);
insert into ingredientesporversion values('0002','A0001-A','0.0.3',50);
insert into ingredientesporversion values('0003','A0001-A','0.0.3',20);
insert into ingredientesporversion values('0004','A0001-A','0.0.3',2);
insert into ingredientesporversion values('0005','A0001-A','0.0.3',10);
insert into ingredientesporversion values('0006','A0001-A','0.0.3',1);
insert into ingredientesporversion values('0007','A0001-A','0.0.3',5);
insert into ingredientesporversion values('0008','A0001-A','0.0.3',2);
insert into ingredientesporversion values('0009','A0001-A','0.0.3',4);
insert into ingredientesporversion values('0014','A0001-A','0.0.3',10);
insert into ingredientesporversion values('0015','A0002-A','0.0.1',70);
insert into ingredientesporversion values('0016','A0002-A','0.0.1',20);
insert into ingredientesporversion values('0003','A0002-A','0.0.1',90);
insert into ingredientesporversion values('0004','A0002-A','0.0.1',2);
insert into ingredientesporversion values('0015','A0002-A','0.0.2',70);
insert into ingredientesporversion values('0016','A0002-A','0.0.2',20);
insert into ingredientesporversion values('0003','A0002-A','0.0.2',90);
insert into ingredientesporversion values('0004','A0002-A','0.0.2',2);
insert into ingredientesporversion values('0017','A0002-A','0.0.2',70);
insert into ingredientesporversion values('0007','A0002-A','0.0.2',20);
insert into ingredientesporversion values('0013','A0002-A','0.0.2',15);
insert into ingredientesporversion values('0047','A0002-A','0.0.2',50);
insert into ingredientesporversion values('0023','A0003-A','0.0.1',90);
insert into ingredientesporversion values('0024','A0003-A','0.0.1',1);
insert into ingredientesporversion values('0025','A0003-A','0.0.1',1);
insert into ingredientesporversion values('0006','A0003-A','0.0.1',1);
insert into ingredientesporversion values('0026','A0003-A','0.0.1',1);
insert into ingredientesporversion values('0023','A0003-A','0.0.2',90);
insert into ingredientesporversion values('0024','A0003-A','0.0.2',1);
insert into ingredientesporversion values('0025','A0003-A','0.0.2',1);
insert into ingredientesporversion values('0006','A0003-A','0.0.2',1);
insert into ingredientesporversion values('0026','A0003-A','0.0.2',1);
insert into ingredientesporversion values('0027','A0003-A','0.0.2',30);
insert into ingredientesporversion values('0028','A0003-A','0.0.2',15);
insert into ingredientesporversion values('0016','A0003-A','0.0.2',15);
insert into ingredientesporversion values('0029','A0003-A','0.0.2',15);
insert into ingredientesporversion values('0004','A0003-A','0.0.2',2);
insert into ingredientesporversion values('0030','A0003-A','0.0.2',6);
insert into ingredientesporversion values('0036','A0003-A','0.0.2',25);
insert into ingredientesporversion values('0002','A0004-A','0.0.1',60);
insert into ingredientesporversion values('0037','A0004-A','0.0.1',10);
insert into ingredientesporversion values('0004','A0004-A','0.0.1',1);
insert into ingredientesporversion values('0038','A0004-A','0.0.1',15);
insert into ingredientesporversion values('0039','A0004-A','0.0.1',60);
insert into ingredientesporversion values('0002','A0004-A','0.0.2',60);
insert into ingredientesporversion values('0037','A0004-A','0.0.2',10);
insert into ingredientesporversion values('0004','A0004-A','0.0.2',1);
insert into ingredientesporversion values('0038','A0004-A','0.0.2',15);
insert into ingredientesporversion values('0039','A0004-A','0.0.2',60);
insert into ingredientesporversion values('0010','A0004-A','0.0.2',20);
insert into ingredientesporversion values('0040','A0004-A','0.0.2',1);
insert into ingredientesporversion values('0041','A0004-A','0.0.2',15);
insert into ingredientesporversion values('0042','A0004-A','0.0.2',25);
insert into ingredientesporversion values('0043','A0004-A','0.0.2',20);
insert into ingredientesporversion values('0046','A0004-A','0.0.2',30);

insert into catadores values('14425879A','Lorena','Garcia Rosas','C/ Nina 9, Sevilla','688877492');
insert into catadores values('51478236G','Antonio','Mesa Soria','C/ Arroyo 45, Sevilla','612479345');
insert into catadores values('52148637R','Marta','Sobrino Dolo','C/ Pinta 2, Sevilla','622578216');
insert into catadores values('52824638D','David','Silva Gomez','C/ Venecia 15, Sevilla','621483625');
insert into catadores values('22457825G','Julio','Resines Matutano','C/ Goya 29, Sevilla','622444852');
insert into catadores values('41253246D','Francisco','Tosco Varela','C/ Pirineos 9, Sevilla','621854123');

insert into aspectos values('0001','Sabor','Muy Alta');
insert into aspectos values('0002','Textura','Alta');
insert into aspectos values('0003','Olor','Alta');
insert into aspectos values('0004','Presentacion','Media');
insert into aspectos values('0005','Cantidad','Media');
insert into aspectos values('0006','Coccion','Muy Alta');
insert into aspectos values('0007','Materia Prima','Muy Alta');
insert into aspectos values('0008','Valor nutricional','Baja');

insert into puntuaciones values('14425879A','0001','A0001-A','0.0.1',2.5);
insert into puntuaciones values('14425879A','0001','A0001-A','0.0.2',7.5);
insert into puntuaciones values('14425879A','0001','A0001-A','0.0.3',9.5);
insert into puntuaciones values('51478236G','0002','A0001-A','0.0.1',1);
insert into puntuaciones values('51478236G','0002','A0001-A','0.0.2',6.7);
insert into puntuaciones values('51478236G','0002','A0001-A','0.0.3',10);
insert into puntuaciones values('52148637R','0003','A0001-A','0.0.1',5);
insert into puntuaciones values('52148637R','0003','A0001-A','0.0.2',6);
insert into puntuaciones values('52148637R','0003','A0001-A','0.0.3',8);
insert into puntuaciones values('52824638D','0004','A0001-A','0.0.1',6);
insert into puntuaciones values('52824638D','0004','A0001-A','0.0.2',2);
insert into puntuaciones values('52824638D','0004','A0001-A','0.0.3',9.9);
insert into puntuaciones values('22457825G','0005','A0001-A','0.0.1',3.2);
insert into puntuaciones values('22457825G','0005','A0001-A','0.0.2',4.9);
insert into puntuaciones values('22457825G','0005','A0001-A','0.0.3',7);
insert into puntuaciones values('14425879A','0006','A0001-A','0.0.1',2.7);
insert into puntuaciones values('51478236G','0006','A0001-A','0.0.2',7.5);
insert into puntuaciones values('52148637R','0006','A0001-A','0.0.3',10);
insert into puntuaciones values('52824638D','0007','A0001-A','0.0.1',6);
insert into puntuaciones values('14425879A','0007','A0001-A','0.0.2',7);
insert into puntuaciones values('22457825G','0007','A0001-A','0.0.3',9.5);
insert into puntuaciones values('14425879A','0008','A0001-A','0.0.1',3);
insert into puntuaciones values('52148637R','0008','A0001-A','0.0.2',1.7);
insert into puntuaciones values('14425879A','0008','A0001-A','0.0.3',8.9);

commit;