# BASE DE DATOS PARA SUPERMERCADO 
DROP TABLE IF EXISTS `cliente`;

CREATE TABLE `cliente` (
  `cedula` int NOT NULL DEFAULT '0',
  `nombre` varchar(45) DEFAULT NULL,
  `puntos` int DEFAULT NULL,
  PRIMARY KEY (`cedula`)
);



LOCK TABLES `cliente` WRITE;

INSERT INTO `cliente` VALUES (1002234571,'Andres',20),
                             (1022344532,'Monica',100),
                             (1033530200,'Manuela',50),
                             (1089965400,'Ines',10),
                             (1123450087,'Juan',22),
                             (1130877432,'Luis',55),
                             (1134033122,'Isabel',77);

UNLOCK TABLES;
 


DROP TABLE IF EXISTS `factura`;
CREATE TABLE `factura` (
  `numeroFactura` int NOT NULL DEFAULT '0',
  `idProducto` int DEFAULT NULL,
  `idCliente` int DEFAULT NULL,
  `cantidad` int DEFAULT NULL,
  `fechaVenta` datetime DEFAULT NULL,
  PRIMARY KEY (`numeroFactura`),
  KEY `FK_PRODUCTO_idx` (`idProducto`),
  KEY `FK_CLIENTE_idx` (`idCliente`),
  CONSTRAINT `FK_CLIENTE` FOREIGN KEY (`idCliente`) REFERENCES `cliente` (`cedula`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_PRODUCTOFAC` FOREIGN KEY (`idProducto`) REFERENCES `productos` (`idProducto`) ON DELETE CASCADE ON UPDATE CASCADE
) 




LOCK TABLES `factura` WRITE;
INSERT INTO `factura` VALUES (10001,101,1002234571,2,'2023-03-23 10:36:23');
UNLOCK TABLES;


DROP TABLE IF EXISTS `inventario`;
CREATE TABLE `inventario` (
  `idProducto` int NOT NULL,
  `cantidad` int DEFAULT NULL,
  `valor` int DEFAULT NULL,
  PRIMARY KEY (`idProducto`),
  CONSTRAINT `FK_PRODUCTO` FOREIGN KEY (`idProducto`) REFERENCES `productos` (`idProducto`) ON DELETE CASCADE ON UPDATE CASCADE
) 



LOCK TABLES `inventario` WRITE;
INSERT INTO `inventario` VALUES (100,54,13990),(101,45,2000);
UNLOCK TABLES;

DROP TABLE IF EXISTS `productos`;
CREATE TABLE `productos` (
  `idProducto` int NOT NULL,
  `idTipoProducto` int DEFAULT NULL,
  `nombreProducto` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `valorVenta` int DEFAULT NULL,
  PRIMARY KEY (`idProducto`),
  KEY `FK_TIPOPRODUCTO_idx` (`idTipoProducto`),
  CONSTRAINT `FK_TIPOPRODUCTO` FOREIGN KEY (`idTipoProducto`) REFERENCES `tipo_producto` (`idTipoProducto`) ON DELETE CASCADE ON UPDATE CASCADE
) 

LOCK TABLES `productos` WRITE;
INSERT INTO `productos` VALUES (100,1,'Bandeja de carne de cerdo',13990),(101,2,'Manzana',2000);
UNLOCK TABLES;


DROP TABLE IF EXISTS `tipo_producto`;
CREATE TABLE `tipo_producto` (
  `idTipoProducto` int NOT NULL DEFAULT '0',
  `nombreTipoProducto` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`idTipoProducto`)
) 


LOCK TABLES `tipo_producto` WRITE;
INSERT INTO `tipo_producto` VALUES (1,'Carnes'),(2,'Frutas'),(3,'Dulces'),(4,'verduras');
UNLOCK TABLES;

# TABLA DONDE SE ALMACENARAN LOS NUEVOS CLIENTES INGRESADOS, QUIEN LOS INGRESA Y LA HORA DE INGRESO 

DROP TABLE IF EXISTS `audicliente`;
CREATE TABLE `audicliente` (
  `idAudi` int NOT NULL AUTO_INCREMENT,
  `usuario` varchar(45) DEFAULT NULL,
  `fechaHora` datetime DEFAULT NULL,
  `accion` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`idAudi`)
) ;


LOCK TABLES `audicliente` WRITE;
INSERT INTO `audicliente` VALUES (1,'root@localhost','2023-03-23 11:04:59','Se ingreso un nuevo cliente: Juan1123450087'),
                                 (2,'root@localhost','2023-03-23 11:06:47','Se ingreso un nuevo cliente: MonicaCon Id:1022344532'),
                                 (3,'root@localhost','2023-03-23 11:21:12','Se ingreso un nuevo cliente:  IsabelCon Id:  1134033122'),
                                 (4,'root@localhost','2023-03-23 11:44:27','Se ingreso un nuevo cliente:  LuisCon Id:  1130877432'),
                                 (5,'root@localhost','2023-03-23 11:46:46','Se ingreso un nuevo cliente:  LuisCon Id:  1130877432');
                                 (6,'root@localhost','2023-03-23 13:34:44','Se ingreso un nuevo cliente:  LuisaCon Id:223432122');
                                 (7,'root@localhost','2023-03-23 13:40:05','Se borro un cliente:  LuisaCon Id:223432122');
UNLOCK TABLES;

#Informes de auditoría para determinar qué usuario realizó determinada operación
delimiter //
create trigger nuevocliente
after insert on cliente
for each row 
   begin 
   insert into audicliente (usuario,fechaHora,accion) 
   values (user(),now(),(concat('Se ingreso un nuevo cliente:  ',new.nombre,"", 'Con Id:', new.cedula)));
   
   end;
//
delimiter //
create trigger borrarcliente
after delete on cliente
for each row 
   begin 
   insert into audicliente (usuario,fechaHora,accion) 
   values (user(),now(),(concat('Se borro un cliente:  ',old.nombre,"", 'Con Id:', old.cedula)));
   
   end;
//


insert into cliente(cedula, nombre, puntos) values (223432122, 'Luisa', 155);
delete from sumerca.cliente where cedula = 223432122;
update sumerca.cliente set nombre = 'Juan Felipe' where cedula = 1123450087;
