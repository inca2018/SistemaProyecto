-- phpMyAdmin SQL Dump
-- version 4.7.9
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 23-10-2018 a las 02:09:38
-- Versión del servidor: 5.7.21
-- Versión de PHP: 5.6.35

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `sistemaproyecto`
--

DELIMITER $$
--
-- Procedimientos
--
DROP PROCEDURE IF EXISTS `SP_ACTIVIDAD_ACTUALIZAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ACTIVIDAD_ACTUALIZAR` (IN `idTareaU` INT(11), IN `nombreTareaU` VARCHAR(200), IN `DescripcionU` TEXT, IN `costoU` DECIMAL(7,2), IN `idProyecto` INT(11), IN `estadoU` INT(11), IN `creador` INT(11))  NO SQL
BEGIN


UPDATE `actividad` SET `NombreTarea`=nombreTareaU,`Descripcion`=DescripcionU, `Costo`=costoU,`Proyecto_idProyecto`=idProyecto,`Estado_idEstado`=estadoU WHERE `idActividad`=idTareaU;

/* ------ REGISTRO DE BITACORA ------ */
SET @NombreUsuario=(SELECT u.usuario FROM usuario u WHERE u.idUsuario=creador);

INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'ACTUALIZACION','ACTIVIDAD',CONCAt("SE ACTUALIZO ACTIVIDAD:",nombreTareaU),NOW());
END$$

DROP PROCEDURE IF EXISTS `SP_ACTIVIDAD_AGREGAR_EMPLEADO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ACTIVIDAD_AGREGAR_EMPLEADO` (IN `idActividadU` INT(11), IN `idEmpleadi` INT(11))  NO SQL
BEGIN

INSERT INTO `participacion`(`idParticipacion`, `Actividad_idActividad`, `Persona_idPersona`, `fechaRegistro`) VALUES (NULL,idActividadU,idEmpleadi,NOW());

END$$

DROP PROCEDURE IF EXISTS `SP_ACTIVIDAD_ELIMINAR_EMPLEADO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ACTIVIDAD_ELIMINAR_EMPLEADO` (IN `idAsignacionU` INT(11), IN `idParti` INT(11))  NO SQL
BEGIN

DELETE FROM `participacion` WHERE `idParticipacion`=idParti;

END$$

DROP PROCEDURE IF EXISTS `SP_ACTIVIDAD_HABILITACION`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ACTIVIDAD_HABILITACION` (IN `idTareaU` INT(11), IN `codigo` INT(11), IN `creador` INT(11))  NO SQL
BEGIN

if (codigo=1) then

 UPDATE `actividad` SET `Estado_idEstado`=4  WHERE `idActividad`=idTareaU;
  SET @Mensaje=("TAREA DESHABILITADO");
else
   UPDATE `actividad` SET `Estado_idEstado`=1  WHERE `idActividad`=idTareaU;
 SET  @Mensaje=("TAREA HABILITADO");
end if;

 /* ------ REGISTRO DE BITACORA ------ */

set @usuario=(SELECT u.usuario FROM usuario u  WHERE u.idUsuario=creador);

set @tipotar=(SELECT s.NombreTarea FROM tarea s WHERE s.idTarea=idTareaU);

INSERT INTO `bitacora`(`usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (@usuario,@Mensaje,'TAREA',CONCAT(@Mensaje," :", @tipotar),NOW());

END$$

DROP PROCEDURE IF EXISTS `SP_ACTIVIDAD_LISTAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ACTIVIDAD_LISTAR` (IN `idProyectioU` INT(11))  NO SQL
BEGIN

SELECT t.idActividad,t.NombreTarea,t.Costo,t.fechaRegistro,pro.NombreProyecto,t.Estado_idEstado,e.nombreEstado,
(SELECT COUNT(*) FROM tarea ss WHERE ss.Actividad_idActividad=t.idActividad) as CantiSubtareas,
(SELECT COUNT(*) FROM participacion par WHERE par.Actividad_idActividad=t.idActividad) as CantiParticipantes,
DATE_FORMAT(t.fechaInicio,"%d/%m/%Y") as fechaInicio ,DATE_FORMAT(t.fechaFin,"%d/%m/%Y") as fechaFin
FROM actividad t INNER JOIN proyecto pro ON pro.idProyecto=t.Proyecto_idProyecto INNER JOIN estado e On e.idEstado=t.Estado_idEstado where t.Proyecto_idProyecto=idProyectioU;

END$$

DROP PROCEDURE IF EXISTS `SP_ACTIVIDAD_LISTAR_AGREGADOS`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ACTIVIDAD_LISTAR_AGREGADOS` (IN `idActividadU` INT(11))  NO SQL
BEGIN

SELECT par.idParticipacion,per.idPersona,CONCAT(per.nombrePersona,' ',per.apellidoPaterno,' ',per.apellidoMaterno) as NombreEmpleado,per.DNI FROM actividad ac INNER JOIN participacion par ON par.Actividad_idActividad=ac.idActividad INNER JOIN persona per ON per.idPersona=par.Persona_idPersona INNER JOIN usuario u On u.Persona_idPersona=per.idPersona WHERE ac.idActividad=idActividadU and u.Perfil_idPerfil=10;

END$$

DROP PROCEDURE IF EXISTS `SP_ACTIVIDAD_LISTAR_NOAGREGADO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ACTIVIDAD_LISTAR_NOAGREGADO` (IN `idActividadU` INT(11))  NO SQL
BEGIN

SELECT per.idPersona,CONCAT(per.nombrePersona,' ',per.apellidoPaterno,' ',per.apellidoMaterno) as NombrePersona,per.DNI FROM persona per
INNER JOIN usuario usu
ON usu.Persona_idPersona=per.idPersona
WHERE usu.Perfil_idPerfil=10 AND NOT EXISTS (SELECT per2.idPersona FROM persona per2 INNER JOIN usuario usu2 ON usu2.Persona_idPersona=per2.idPersona INNER JOIN participacion par ON par.Persona_idPersona=per2.idPersona WHERE per2.idPersona=per.idPersona and par.Actividad_idActividad=idActividadU );




END$$

DROP PROCEDURE IF EXISTS `SP_ACTIVIDAD_RECUPERAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ACTIVIDAD_RECUPERAR` (IN `idTareaU` INT(11))  NO SQL
BEGIN

SELECT * FROM actividad t WHERE t.idActividad=idTareaU;

END$$

DROP PROCEDURE IF EXISTS `SP_ACTIVIDAD_RECUPERAR_INFORMACION`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ACTIVIDAD_RECUPERAR_INFORMACION` (IN `idActividadU` INT(11))  NO SQL
BEGIN


SELECT pro.idProyecto,pro.NombreProyecto,ac.Costo,ac.NombreTarea FROM actividad ac INNER JOIN proyecto pro ON pro.idProyecto=ac.Proyecto_idProyecto WHERE ac.idActividad=idActividadU;

END$$

DROP PROCEDURE IF EXISTS `SP_ACTIVIDAD_RECUPERAR_PROYECTO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ACTIVIDAD_RECUPERAR_PROYECTO` (IN `idProyectoU` INT(11))  NO SQL
BEGIN


SELECT p.NombreProyecto,cli.NombreCliente,CONCAT(per.nombrePersona,' ',per.apellidoPaterno,' ',per.apellidoMaterno) as NombreJefe FROM proyecto p INNER JOIN cliente cli On cli.idCliente=p.Cliente_idCliente LEFT JOIN persona per ON per.idPersona=p.Persona_idPersona WHERE p.idProyecto=idProyectoU;


END$$

DROP PROCEDURE IF EXISTS `SP_ACTIVIDAD_REGISTRO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ACTIVIDAD_REGISTRO` (IN `nomTarea` VARCHAR(200), IN `descTarea` TEXT, IN `costoU` DECIMAL(7,2), IN `idProyecto` INT(11), IN `estado` INT(11), IN `creador` INT(11))  NO SQL
BEGIN

INSERT INTO `actividad`(`idActividad`, `NombreTarea`, `Descripcion`, `Costo`, `fechaRegistro`, `Proyecto_idProyecto`,`Estado_idEstado`) VALUES (NULL,nomTarea,descTarea,costoU,NOW(),idProyecto,estado);


SET @NombreUsuario=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM usuario u inner join persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=creador);


INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'INSERTAR','SE REGISTRO ACTIVIDAD','ACTIVIDAD',NOW());

END$$

DROP PROCEDURE IF EXISTS `SP_CLIENTE_ACTUALIZAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_CLIENTE_ACTUALIZAR` (IN `Nombre` VARCHAR(200), IN `Direccion` TEXT, IN `Contacto` CHAR(11), IN `estado` INT(11), IN `creador` INT(11), IN `idClienteU` INT(11))  NO SQL
BEGIN

UPDATE `cliente` SET `NombreCliente`=Nombre,`Direccion`=Direccion,`Contacto`=Contacto, `Estado_idEstado`=estado WHERE `idCliente`=idClienteU;

/* ------ REGISTRO DE BITACORA ------ */
SET @NombreUsuario=(SELECT u.usuario FROM usuario u WHERE u.idUsuario=creador);

INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'ACTUALIZACION','CLIENTE',CONCAt("SE ACTUALIZO cliente:",Nombre),NOW());
END$$

DROP PROCEDURE IF EXISTS `SP_CLIENTE_HABILITACION`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_CLIENTE_HABILITACION` (IN `idClienteU` INT(11), IN `codigo` INT(11), IN `creador` INT(11))  NO SQL
BEGIN

if (codigo=1) then

    UPDATE `cliente` SET `Estado_idEstado`=4  WHERE `idCliente`=idClienteU;
  SET @Mensaje=("CLIENTE DESHABILITADO");


else
   UPDATE `cliente` SET `Estado_idEstado`=1  WHERE `idCliente`=idClienteU;
 SET  @Mensaje=("CLIENTE HABILITADO");
end if;

 /* ------ REGISTRO DE BITACORA ------ */

set @usuario=(SELECT u.usuario FROM usuario u  WHERE u.idUsuario=creador);

set @tipotar=(SELECT g.NombreCliente FROM cliente g WHERE g.idCliente=idClienteU);

INSERT INTO `bitacora`(`usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (@usuario,@Mensaje,'CLIENTE',CONCAT(@Mensaje," :", @tipotar),NOW());

END$$

DROP PROCEDURE IF EXISTS `SP_CLIENTE_LISTAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_CLIENTE_LISTAR` ()  NO SQL
BEGIN

SELECT * FROM cliente INNER JOIN estado ON estado.idEstado=cliente.Estado_idEstado;

END$$

DROP PROCEDURE IF EXISTS `SP_CLIENTE_RECUPERAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_CLIENTE_RECUPERAR` (IN `idCLienteC` INT(11))  NO SQL
BEGIN

SELECT * FROM cliente c WHERE c.idCliente=idCLienteC;

END$$

DROP PROCEDURE IF EXISTS `SP_CLIENTE_REGISTRO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_CLIENTE_REGISTRO` (IN `nombreC` VARCHAR(200), IN `DireccionC` TEXT, IN `ContactoC` CHAR(11), IN `estadoC` INT(11), IN `creador` INT(11))  NO SQL
BEGIN

INSERT INTO `cliente`(`idCliente`, `NombreCliente`, `Direccion`, `Contacto`, `fechaRegistro`, `Estado_idEstado`) VALUES (NULL,nombreC,DireccionC,ContactoC,NOW(),estadoC);

SET @NombreUsuario=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM usuario u inner join persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=creador);


INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'INSERTAR','SE REGISTRO CLIENTE','CLIENTE',NOW());

END$$

DROP PROCEDURE IF EXISTS `SP_ESTADO_LISTAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ESTADO_LISTAR` (IN `Tipo` INT(11))  NO SQL
BEGIN

Select * FROM estado e WHERE e.tipoEstado=Tipo;

END$$

DROP PROCEDURE IF EXISTS `SP_GESTION_INFORMACION_AVANCE`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GESTION_INFORMACION_AVANCE` ()  NO SQL
BEGIN

SELECT pro.NombreProyecto,
(SELECT COUNT(DISTINCT(par.Persona_idPersona)) FROM participacion par INNER JOIN actividad act ON act.idActividad=par.Actividad_idActividad where act.Proyecto_idProyecto=pro.idProyecto) as CantidadParticipantes,

(SELECT COUNT(*) FROM actividad ac1 where ac1.Proyecto_idProyecto=pro.idProyecto) as CantidadActividades,

(SELECT COUNT(*) FROM actividad ac2 inner join tarea ta2 ON ta2.Actividad_idActividad=ac2.idActividad where ac2.Proyecto_idProyecto=pro.idProyecto) as CantidadTareas,

(TIMESTAMPDIFF(DAY,pro.fechaInicio,pro.fechaFin)) as Diasproyecto,

IFNULL((SELECT SUM(tg.DiasGestion) FROM actividad ac3 INNER JOIN tarea ta3 On ta3.Actividad_idActividad=ac3.idActividad INNER JOIN tareagestion tg On tg.Tarea_idTarea=ta3.idTarea where ac3.Proyecto_idProyecto=pro.idProyecto),'0')as DiasGestion,

(SELECT SUM(ac5.Costo) FROM actividad ac5 WHERE ac5.Proyecto_idProyecto=pro.idProyecto) as CostoTotalProyecto

FROM proyecto pro LEFT JOIN actividad ac ON ac.Proyecto_idProyecto=pro.idProyecto GROUP BY pro.idProyecto ;
 

END$$

DROP PROCEDURE IF EXISTS `SP_GESTION_LISTAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GESTION_LISTAR` (IN `idTareaU` INT(11))  NO SQL
BEGIN

SELECT ta.idTarea,ta.NombreTarea,tg.Detalle,tg.idGestionTarea,tg.DiasTotales,tg.DiasGestion,DATE_FORMAT(tg.fechaRegistro,"%d/%m/%Y") as fechaRegistro FROM tareagestion tg INNER JOIN tarea ta ON ta.idTarea=tg.Tarea_idTarea WHERE ta.idTarea=idTareaU;
END$$

DROP PROCEDURE IF EXISTS `SP_GESTION_RECUPERAR_FECHAS`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GESTION_RECUPERAR_FECHAS` (IN `idTareaU` INT(11))  NO SQL
BEGIN

DECLARE PASO INT(11);
DECLARE FechaInicio VARCHAR(100);
DECLARE FechaFin VARCHAR(100);

SET PASO=(SELECT COUNT(*) FROM tareagestion tg WHERE tg.Tarea_idTarea=idTareaU);

if(PASO>0)THEN

SET FechaInicio=(SELECT DATE_FORMAT(MAX(tg.fechaFin),"%d/%m/%Y") as fechaInicio FROM tareagestion tg INNER JOIN tarea ta ON ta.idTarea=tg.Tarea_idTarea where tg.Tarea_idTarea=idTareaU
                GROUP BY ta.idTarea);

SET FechaFin=(SELECT DATE_FORMAT(ta.fechaFin,"%d/%m/%Y") as fechaFin FROM tarea ta WHERE ta.idTarea=idTareaU);

else


SET FechaInicio=(SELECT DATE_FORMAT(ta.fechaInicio,"%d/%m/%Y") as fechaInicio FROM tarea ta WHERE ta.idTarea=idTareaU);

SET FechaFin=(SELECT DATE_FORMAT(ta.fechaFin,"%d/%m/%Y") as fechaFin FROM tarea ta WHERE ta.idTarea=idTareaU);


end if;

SELECT FechaInicio,FechaFin;
END$$

DROP PROCEDURE IF EXISTS `SP_GESTION_REGISTRO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GESTION_REGISTRO` (IN `idTareaE` INT(11), IN `detalleE` TEXT, IN `inicioE` DATE, IN `finE` DATE, IN `creador` INT(11))  NO SQL
BEGIN
DECLARE idPersona INT(11);
DECLARE dias_gestion INT(11);
DECLARE dias_total INT(11);
DECLARE inicioTarea VARCHAR(100);
DECLARE finTarea VARCHAR(100);

DECLARE total_recuperado INT(100);
DECLARE suma_recuperado INT(100);

SET idPersona=(SELECT per.idPersona FROM persona per INNER JOIN usuario u ON u.Persona_idPersona=per.idPersona where u.idUsuario=creador);

SET inicioTarea=(SELECT ta.fechaInicio FROM tarea ta WHERE ta.idTarea=idTareaE);

SET finTarea=(SELECT ta.fechaFin FROM tarea ta WHERE ta.idTarea=idTareaE);

SET dias_total=(SELECT TIMESTAMPDIFF(DAY,inicioTarea,finTarea));

SET dias_gestion=(SELECT TIMESTAMPDIFF(DAY,inicioE,finE));


INSERT INTO `tareagestion`(`idGestionTarea`, `Tarea_idTarea`, `Persona_idPersona`, `DiasTotales`, `DiasGestion`, `fechaInicio`, `fechaFin`, `Detalle`, `fechaRegistro`) VALUES (NULL,idTareaE,idPersona,dias_total,dias_gestion,inicioE,finE,detalleE,NOW());


SET total_recuperado=(SELECT tar.DiasTotales FROM tareagestion tar WHERE tar.Tarea_idTarea=idTareaE LIMIT 1);

SET suma_recuperado=(SELECT SUM(tar.DiasGestion) FROM tareagestion tar INNER JOIN tarea t ON t.idTarea=tar.Tarea_idTarea where t.idTarea=idTareaE GROUP BY t.idTarea);

IF(total_recuperado=suma_recuperado)THEN
UPDATE `tarea` SET `Estado_idEstado`=7 WHERE `idTarea`=idTareaE;
ELSE
    IF(total_recuperado>suma_recuperado) THEN
    UPDATE `tarea` SET `Estado_idEstado`=6 WHERE `idTarea`=idTareaE;
    ELSE
    UPDATE `tarea` SET `Estado_idEstado`=5 WHERE `idTarea`=idTareaE;
    END IF;
END IF;

END$$

DROP PROCEDURE IF EXISTS `SP_LISTAR_PERFILES`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_PERFILES` ()  NO SQL
BEGIN

SELECT * FROM perfil p WHERE p.Estado_idEstado=1 or p.Estado_idEstado=3;

END$$

DROP PROCEDURE IF EXISTS `SP_LISTA_DISPONIBILIDAD`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTA_DISPONIBILIDAD` (IN `idUserU` INT(11))  NO SQL
BEGIN

SELECT
pro.idProyecto,
pro.NombreProyecto,
ac.idActividad,
ac.NombreTarea as NombreActividad,
t.idTarea,
t.NombreTarea,
e.nombreEstado,
t.Estado_idEstado
FROM proyecto pro
INNER JOIN actividad ac
On ac.Proyecto_idProyecto=pro.idProyecto
INNER JOIN tarea t
On t.Actividad_idActividad=ac.idActividad
INNER JOIN participacion par ON par.Actividad_idActividad=ac.idActividad
INNER JOIN persona per
ON per.idPersona=par.Persona_idPersona
INNER JOIN usuario u
ON u.Persona_idPersona=per.idPersona
INNER JOIN estado e
ON e.idEstado=t.Estado_idEstado
LEFT JOIN tareagestion tar
ON tar.Tarea_idTarea=t.idTarea
where u.idUsuario=idUserU
GROUP BY t.idTarea;


END$$

DROP PROCEDURE IF EXISTS `SP_LOGIN_REGISTRO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LOGIN_REGISTRO` (IN `idUsuario` INT(11), IN `usuario` VARCHAR(100), IN `passwordLog` TEXT, IN `perfil` VARCHAR(100))  NO SQL
BEGIN


INSERT INTO `login`(`idLogin`, `Usuario_idUsuario`, `usuarioLog`, `passwordLog`, `perfilLog`, `fechaLog`) VALUES (null,idUsuario,usuario,passwordLog,perfil,NOW());


END$$

DROP PROCEDURE IF EXISTS `SP_OPERACIONES_LISTAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_OPERACIONES_LISTAR` ()  NO SQL
BEGIN


SELECT
al.idAlumno,
pla.idPlanPago,
CONCAT(per.nombrePersona,' ',per.apellidoPaterno,' ',per.apellidoMaterno) as AlumnoNombre,
per.DNI,

IFNULL((SELECT CONCAT(per2.nombrePersona,' ',per2.apellidoPaterno,' ',per2.apellidoMaterno) FROM relacionhijos rel INNER JOIN apoderado apo ON apo.idApoderado=rel.Apoderado_idApoderado INNER JOIN persona per2 ON per2.idPersona=apo.Persona_idPersona  WHERE rel.Alumno_idAlumno=al.idAlumno),'-') as ApoderadoNombre,

IFNULL((SELECT  per2.DNI FROM relacionhijos rel INNER JOIN apoderado apo ON apo.idApoderado=rel.Apoderado_idApoderado INNER JOIN persona per2 ON per2.idPersona=apo.Persona_idPersona  WHERE rel.Alumno_idAlumno=al.idAlumno),'-') as ApoderadoDNI,

(SELECT COUNT(cuu2.idCuota) FROM alumno alu2 INNER JOIN planpago plan2 ON alu2.idAlumno=plan2.Alumno_idAlumno LEFT JOIN cuota cuu2 ON cuu2.PlanPago_idPlanPago=plan2.idPlanPago where alu2.idAlumno=al.idAlumno) as NumCuota,

(SELECT COUNT(cuu2.idCuota) FROM alumno alu2 INNER JOIN planpago plan2 ON alu2.idAlumno=plan2.Alumno_idAlumno LEFT JOIN cuota cuu2 ON cuu2.PlanPago_idPlanPago=plan2.idPlanPago where alu2.idAlumno=al.idAlumno and (cuu2.Estado_idEstado=5 or cuu2.Estado_idEstado=6)) as CuotaPendiente,

(SELECT COUNT(cuu3.idCuota) FROM alumno alu3 INNER JOIN planpago pla3 ON alu3.idAlumno=pla3.Alumno_idAlumno LEFT JOIN cuota cuu3 ON cuu3.PlanPago_idPlanPago=pla3.idPlanPago where alu3.idAlumno=al.idAlumno and cuu3.Estado_idEstado=7) as CuotasPagadas,


(SELECT COUNT(cuu5.idCuota) FROM alumno alu5 INNER JOIN planpago plan5 ON alu5.idAlumno=plan5.Alumno_idAlumno LEFT JOIN cuota cuu5 ON cuu5.PlanPago_idPlanPago=plan5.idPlanPago where alu5.idAlumno=al.idAlumno and (cuu5.Estado_idEstado=5 or cuu5.Estado_idEstado=6) and cuu5.fechaVencimiento<=DATE_FORMAT(NOW(), "%Y-%m-%d") ) as CuotasVencidas

FROM persona per
LEFT JOIN alumno al
ON al.Persona_idPersona=per.idPersona
LEFT JOIN planpago pla
ON pla.Alumno_idAlumno=al.idAlumno
LEFT JOIN cuota cu
ON cu.PlanPago_idPlanPago=pla.idPlanPago WHERE (al.idAlumno) IS NOT NULL
GROUP BY al.idAlumno;

END$$

DROP PROCEDURE IF EXISTS `SP_OPERACION_RECUPERAR_INFO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_OPERACION_RECUPERAR_INFO` (IN `idPlanE` INT(11), IN `idAlumnoE` INT(11))  NO SQL
BEGIN


SELECT
al.idAlumno,
pla.idPlanPago,
pla.montoMatricula,
pla.pagoM as Estado1,
pla.otroPago1,
pla.pagoOtro1 as Estado2,
pla.otroPago2,
pla.pagoOtro2 as Estado3,
CONCAT(per.nombrePersona,' ',per.apellidoPaterno,' ',per.apellidoMaterno) as AlumnoNombre,
per.DNI,

IFNULL((SELECT CONCAT(per2.nombrePersona,' ',per2.apellidoPaterno,' ',per2.apellidoMaterno) FROM relacionhijos rel INNER JOIN apoderado apo ON apo.idApoderado=rel.Apoderado_idApoderado INNER JOIN persona per2 ON per2.idPersona=apo.Persona_idPersona  WHERE rel.Alumno_idAlumno=al.idAlumno),'-') as ApoderadoNombre,

IFNULL((SELECT  per2.DNI FROM relacionhijos rel INNER JOIN apoderado apo ON apo.idApoderado=rel.Apoderado_idApoderado INNER JOIN persona per2 ON per2.idPersona=apo.Persona_idPersona  WHERE rel.Alumno_idAlumno=al.idAlumno),'-') as ApoderadoDNI,

IFNULL((SELECT  tipo.idTipoTarjeta FROM relacionhijos rel INNER JOIN apoderado apod ON apod.idApoderado=rel.Apoderado_idApoderado INNER JOIN persona per2 ON per2.idPersona=apod.Persona_idPersona LEFT JOIN tipotarjeta tipo ON tipo.idTipoTarjeta=apod.TipoTarjeta_idTipoTarjeta  WHERE rel.Alumno_idAlumno=al.idAlumno),'-') as idTipoTarjetaApoderado,

IFNULL((SELECT  tipo.Descripcion FROM relacionhijos rel INNER JOIN apoderado apo ON apo.idApoderado=rel.Apoderado_idApoderado INNER JOIN persona per2 ON per2.idPersona=apo.Persona_idPersona LEFT JOIN tipotarjeta tipo ON tipo.idTipoTarjeta=apo.TipoTarjeta_idTipoTarjeta  WHERE rel.Alumno_idAlumno=al.idAlumno),'-') as TipoTarjetaApoderado

FROM persona per
LEFT JOIN alumno al
ON al.Persona_idPersona=per.idPersona
LEFT JOIN planpago pla
ON pla.Alumno_idAlumno=al.idAlumno
LEFT JOIN cuota cu
ON cu.PlanPago_idPlanPago=pla.idPlanPago WHERE (al.idAlumno) IS NOT NULL and pla.idPlanPago=idPlanE and al.idAlumno=idAlumnoE
GROUP BY pla.idPlanPago
;

END$$

DROP PROCEDURE IF EXISTS `SP_PERFIL_ACTUALIZAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PERFIL_ACTUALIZAR` (IN `nombre` VARCHAR(50), IN `descripcion` TEXT, IN `estado` INT(11), IN `idperfilE` INT(11), IN `creador` INT(11))  NO SQL
BEGIN

if(descripcion=-1)then
SET descripcion=null;
end if;

UPDATE `perfil` SET `nombrePerfil`=UPPER(nombre),`descripcionPerfil`=UPPER(descripcion),`Estado_idEstado`=estado WHERE `idPerfil`=idperfilE;

/* ------ REGISTRO DE BITACORA ------ */
SET @NombreUsuario=(SELECT u.usuario FROM usuario u WHERE u.idUsuario=creador);

INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'ACTUALIZACION','Perfil',CONCAt("SE ACTUALIZO PERFIL:",nombre),NOW());
END$$

DROP PROCEDURE IF EXISTS `SP_PERFIL_ELIMINAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PERFIL_ELIMINAR` (IN `idPerfilEnviado` INT(11), IN `idUsuario` INT(11), OUT `Mensaje` TEXT)  NO SQL
BEGIN
DECLARE CantidadPerfil INT(11);

SET CantidadPerfil=(SELECT COUNT(*) FROM usuario u WHERE u.Perfil_idPerfil=idPerfilEnviado);

SELECT CantidadPerfil;

if(CantidadPerfil>0) then
    SET Mensaje="No se Puede Eliminar,Existen Usuarios usando el Perfil Seleccionado.";
else
 	DELETE FROM `perfil`  WHERE `idPerfil`=idPerfilEnviado;
    SET Mensaje="Perfil Elimino Correctamente.";
end if;

/* ------ REGISTRO DE BITACORA ------ */
SET @NombreUsuario=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM usuario u inner join persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=idUsuario);

INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`, `fechaRegistro`) VALUES (null,@NombreUsuario,'ELIMINAR','Perfil',NOW());


END$$

DROP PROCEDURE IF EXISTS `SP_PERFIL_HABILITACION`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PERFIL_HABILITACION` (IN `idPerfilE` INT(11), IN `codigo` INT(11), IN `idUsuarioE` INT(11))  NO SQL
BEGIN

SET @NombrePerfil=(SELECT pe.nombrePerfil FROM perfil pe WHERE pe.idPerfil=idPerfilE);


if (codigo=1) then
 	UPDATE `perfil` SET  `Estado_idEstado`=4 WHERE `idPerfil`=idPerfilE;
  SET @Mensaje=("PERFIL DESHABILITADO");
else
    UPDATE `perfil` SET  `Estado_idEstado`=1  WHERE `idPerfil`=idPerfilE;
 SET  @Mensaje=("PERFIL HABILITADO");
end if;

 /* ------ REGISTRO DE BITACORA ------ */

set @usuario=(SELECT u.usuario FROM usuario u  WHERE u.idUsuario=idUsuarioE);

INSERT INTO `bitacora`(`usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (@usuario,@Mensaje,'PERFIL',CONCAT("SE",@Mensaje," :", @NombrePerfil),NOW());

END$$

DROP PROCEDURE IF EXISTS `SP_PERFIL_LISTAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PERFIL_LISTAR` ()  NO SQL
BEGIN

SELECT * FROM perfil;

END$$

DROP PROCEDURE IF EXISTS `SP_PERFIL_LISTAR_TODOS`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PERFIL_LISTAR_TODOS` ()  NO SQL
BEGIN

SELECT * FROM perfil p INNER JOIN estado e on e.idEstado=p.Estado_idEstado;
END$$

DROP PROCEDURE IF EXISTS `SP_PERFIL_RECUPERAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PERFIL_RECUPERAR` (IN `idPerfilE` INT(11))  NO SQL
BEGIN

SELECT * FROM perfil p WHERE p.idPerfil=idPerfilE;
END$$

DROP PROCEDURE IF EXISTS `SP_PERFIL_REGISTRO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PERFIL_REGISTRO` (IN `nombrePerfil` VARCHAR(50), IN `descripcion` TEXT, IN `estado` INT(11), IN `idUsuarioE` INT(11))  NO SQL
BEGIN

DECLARE idPerfil INT(11);

-- REGISTRAR PERFIL --
INSERT INTO `perfil`(`idPerfil`, `nombrePerfil`, `descripcionPerfil`, `Estado_idEstado`, `fechaRegistro`) VALUES (null,UPPER(nombrePerfil),UPPER(descripcion),estado,NOW());
-- RECUPERAR ID DE PERFIL REGISTRADO --
SET idPerfil=(SELECT LAST_INSERT_ID());
-- REGISTRAR PERMISOS ASIGNADOS A PERFIL --
INSERT INTO `permisos`(`idPermisos`, `perfil_idPerfil`, `permiso1`, `permiso2`, `permiso3`) VALUES (null,idPerfil,1,1,1);




SET @NombreUsuario=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM usuario u inner join persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=idUsuarioE);


INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'INSERTAR','SE REGISTRO PERFIL','Perfil',NOW());

INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'INSERTAR','SE REGISTRO PERMISOS DE PERFIL','Permisos',NOW());

END$$

DROP PROCEDURE IF EXISTS `SP_PERMISOS_ACTUALIZAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PERMISOS_ACTUALIZAR` (IN `idPermisosE` INT(11), IN `perm1` INT(11), IN `perm2` INT(11), IN `perm3` INT(11), IN `idPerfilE` INT(11), IN `idUsuarioE` INT(11))  NO SQL
BEGIN

UPDATE `permisos` SET `Permiso1`=perm1,`Permiso2`=perm2,`Permiso3`=perm3 WHERE `idPermisos`=idPermisosE;

set @perfil=(SELECT perfil.nombrePerfil FROM perfil WHERE perfil.idPerfil=idPerfilE);

/* ------ REGISTRO DE BITACORA ------ */

set @usuario=(SELECT u.usuario FROM usuario u  WHERE u.idUsuario=idUsuarioE);

INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@usuario,'SE ACTUALIZO PERMISOS','PERMISOS',CONCAT("SE ACTUALIZO PERMISOS DE PERFIL:",@perfil),NOW());

END$$

DROP PROCEDURE IF EXISTS `SP_PERMISOS_RECUPERAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PERMISOS_RECUPERAR` (IN `idPerfilE` INT(11))  NO SQL
BEGIN

SELECT per.idPermisos,per.Permiso1,per.Permiso2,per.Permiso3,perf.nombrePerfil FROM permisos per INNER JOIN perfil perf ON perf.idPerfil=per.Perfil_idPerfil WHERE perf.idPerfil=idPerfilE;

END$$

DROP PROCEDURE IF EXISTS `SP_PERSONAS_LISTAR_JEFE_PROYECTO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PERSONAS_LISTAR_JEFE_PROYECTO` ()  NO SQL
BEGIN

SELECT p.idPersona,CONCAT(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombreJefeProyecto FROM persona p INNER JOIN usuario u  ON u.Persona_idPersona=p.idPersona WHere u.Perfil_idPerfil=9;
END$$

DROP PROCEDURE IF EXISTS `SP_PERSONAS_LISTAR_SIN_USUARIOS`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PERSONAS_LISTAR_SIN_USUARIOS` ()  NO SQL
BEGIN

SELECT * FROM persona p WHERE NOT EXISTS (SELECT * FROM usuario u WHERE u.Persona_idPersona=p.idPersona);


END$$

DROP PROCEDURE IF EXISTS `SP_PERSONA_ACTUALIZAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PERSONA_ACTUALIZAR` (IN `nombre` VARCHAR(50), IN `apellidoP` VARCHAR(50), IN `apellidoM` VARCHAR(50), IN `DNI` CHAR(10), IN `fechaNacimiento` DATE, IN `correo` VARCHAR(100), IN `telefono` CHAR(10), IN `Direccion` TEXT, IN `estado` INT(11), IN `idPersonaU` INT(11), IN `idUsuario` INT(11))  NO SQL
BEGIN


if(correo='0')then
SET correo=null;
end if;
if(telefono='0')then
SET telefono=null;
end if;
if(Direccion='0')then
SET Direccion=null;
end if;

UPDATE `persona` SET `nombrePersona`=UPPER(nombre),`apellidoPaterno`=UPPER(apellidoP),`apellidoMaterno`=UPPER(apellidoM),`DNI`=DNI,`fechaNacimiento`=fechaNacimiento,`correo`=UPPER(correo),`telefono`=telefono,`direccion`=UPPER(Direccion),`Estado_idEstado`=estado WHERE `idPersona`=idPersonaU;

/* ------ REGISTRO DE BITACORA ------ */
SET @NombreUsuario=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM usuario u inner join persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=idUsuario);

INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'ACTUALIZACION','Persona',CONCAT('SE ACTUALIZO PERSONA:',nombre,' ',apellidoP,' ',apellidoM),NOW());
END$$

DROP PROCEDURE IF EXISTS `SP_PERSONA_HABILITACION`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PERSONA_HABILITACION` (IN `idPersonaE` INT(11), IN `codigo` INT(11), IN `idUsuarioE` INT(11))  NO SQL
BEGIN

SET @NombrePersona=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM persona p WHERE p.idPersona=idPersonaE);


if (codigo=1) then
 	UPDATE `persona` SET  `Estado_idEstado`=4 WHERE `idPersona`=idPersonaE;
  SET @Mensaje=("PERSONA DESHBILITADO");
else
    UPDATE `persona` SET  `Estado_idEstado`=1  WHERE `idPersona`=idPersonaE;
 SET  @Mensaje=("PERSONA HABILITADO");
end if;

 /* ------ REGISTRO DE BITACORA ------ */

set @usuario=(SELECT u.usuario FROM usuario u  WHERE u.idUsuario=idUsuarioE);

INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@usuario,@Mensaje,'USUARIO',CONCAT("SE",@Mensaje," :", @NombrePersona),NOW());

END$$

DROP PROCEDURE IF EXISTS `SP_PERSONA_LISTAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PERSONA_LISTAR` ()  NO SQL
BEGIN


SELECT * FROM persona p INNER JOIN estado e ON e.idEstado=p.Estado_idEstado;


END$$

DROP PROCEDURE IF EXISTS `SP_PERSONA_LISTAR_TODO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PERSONA_LISTAR_TODO` ()  NO SQL
BEGIN

SELECT * FROM persona;

END$$

DROP PROCEDURE IF EXISTS `SP_PERSONA_RECUPERAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PERSONA_RECUPERAR` (IN `idPersonaU` INT)  NO SQL
begin

SELECT * FROM persona p WHERE p.idPersona=idPersonaU;

end$$

DROP PROCEDURE IF EXISTS `SP_PERSONA_REGISTRO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PERSONA_REGISTRO` (IN `nombre` VARCHAR(50), IN `apellidoP` VARCHAR(50), IN `apellidoM` VARCHAR(50), IN `DNI` CHAR(10), IN `fechaNacimiento` DATE, IN `correo` VARCHAR(100), IN `telefono` CHAR(10), IN `Direccion` TEXT, IN `estado` INT(11), IN `idUsuario` INT(11))  NO SQL
BEGIN

if(correo='0')THEN
SET correo=null;
end if;
if(telefono='0')THEN
SET telefono=null;
end if;
if(Direccion='0')THEN
SET Direccion=null;
end if;

INSERT INTO `persona`(`idPersona`, `nombrePersona`, `apellidoPaterno`, `apellidoMaterno`, `DNI`, `fechaNacimiento`, `correo`, `telefono`, `direccion`, `Estado_idEstado`, `fechaRegistro`) VALUES (NULL,UPPER(nombre),UPPER(apellidoP),UPPER(apellidoM),DNI,fechaNacimiento,UPPER(correo),telefono,UPPER(Direccion),estado,NOW());


/* ------ REGISTRO DE BITACORA ------ */
SET @NombreUsuario=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM usuario u inner join persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=idUsuario);

INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'REGISTRO','Persona',CONCAT('SE REGISTRO PERSONA:',nombre,' ',apellidoP,' ',apellidoM),NOW());


END$$

DROP PROCEDURE IF EXISTS `SP_PROYECTO_ACTUALIZAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PROYECTO_ACTUALIZAR` (IN `idProyectoU` INT(11), IN `NombreProyecto` VARCHAR(200), IN `idCliente` INT(11), IN `DescripcionProyecto` TEXT, IN `estado` INT(11), IN `creador` INT(11), IN `idJefe` INT)  NO SQL
BEGIN

UPDATE `proyecto` SET `NombreProyecto`=NombreProyecto,`Cliente_idCliente`=idCliente,`Descripcion`=DescripcionProyecto,`Estado_idEstado`=estado,`Persona_idPersona`=idJefe WHERE `idProyecto`=idProyectoU;

/* ------ REGISTRO DE BITACORA ------ */
SET @NombreUsuario=(SELECT u.usuario FROM usuario u WHERE u.idUsuario=creador);

INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'ACTUALIZACION','PROEYCTO',CONCAt("SE ACTUALIZO PROYECTO:",NombreProyecto),NOW());
END$$

DROP PROCEDURE IF EXISTS `SP_PROYECTO_HABILITACION`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PROYECTO_HABILITACION` (IN `idProyectoE` INT(11), IN `codigo` INT(11), IN `creador` INT(11))  NO SQL
BEGIN

if (codigo=1) then

    UPDATE `proyecto` SET `Estado_idEstado`=4  WHERE `idProyecto`=idProyectoE;
  SET @Mensaje=("PROYECTO DESHABILITADO");
else
   UPDATE `proyecto` SET `Estado_idEstado`=1  WHERE `idProyecto`=idProyectoE;
 SET  @Mensaje=("PROYECTO HABILITADO");
end if;

 /* ------ REGISTRO DE BITACORA ------ */

set @usuario=(SELECT u.usuario FROM usuario u  WHERE u.idUsuario=creador);

set @tipotar=(SELECT pro.NombreProyecto FROM proyecto pro WHERE pro.idProyecto=idProyectoE);

INSERT INTO `bitacora`(`usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (@usuario,@Mensaje,'PROYECTO',CONCAT(@Mensaje," :", @tipotar),NOW());

END$$

DROP PROCEDURE IF EXISTS `SP_PROYECTO_LISTAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PROYECTO_LISTAR` ()  NO SQL
BEGIN

SELECT pro.idProyecto,pro.NombreProyecto,cli.NombreCliente,pro.Descripcion,pro.Estado_idEstado,e.nombreEstado,pro.fechaRegistro,(SELECT COUNT(*) FROM actividad t WHERE t.Proyecto_idProyecto=pro.idProyecto) as CantidadTarea,
CONCAT(per.nombrePersona,' ',per.apellidoPaterno,' ',per.apellidoMaterno) as NombreJefe,
IFNULL((SELECT SUM(ac.Costo) FROM actividad ac WHERE ac.Proyecto_idProyecto=pro.idProyecto),'0.00') as CostoTotal,
DATE_FORMAT(pro.fechaInicio,"%d/%m/%Y") as fechaInicio,DATE_FORMAT(pro.fechaFin,"%d/%m/%Y") as fechaFin
FROM proyecto pro
INNER JOIN estado e
ON e.idEstado=pro.Estado_idEstado
INNER JOIN cliente cli
ON cli.idCliente=pro.Cliente_idCliente
LEFT JOIN persona per ON per.idPersona=pro.Persona_idPersona;

END$$

DROP PROCEDURE IF EXISTS `SP_PROYECTO_RECUPERAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PROYECTO_RECUPERAR` (IN `idProyectoE` INT(11))  NO SQL
BEGIN

SELECT * FROM proyecto pro WHERE pro.idProyecto=idProyectoE;
END$$

DROP PROCEDURE IF EXISTS `SP_PROYECTO_REGISTRO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PROYECTO_REGISTRO` (IN `nombreProyecto` VARCHAR(200), IN `idCliente` INT(11), IN `Descripcionproyecto` TEXT, IN `estado` INT(11), IN `creador` INT(11), IN `idJefe` INT(11))  NO SQL
BEGIN

INSERT INTO `proyecto`(`idProyecto`, `NombreProyecto`, `Cliente_idCliente`, `Descripcion`, `fechaRegistro`,`Persona_idPersona`,`Estado_idEstado`) VALUES (NULL,nombreProyecto,idCliente,Descripcionproyecto,NOW(),idJefe,estado);


SET @NombreUsuario=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM usuario u inner join persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=creador);


INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'INSERTAR','SE REGISTRO PROYECTO','PROYECTO',NOW());

END$$

DROP PROCEDURE IF EXISTS `SP_RECUPERAR_ACTIVIDADES_DISPONIBLES`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_RECUPERAR_ACTIVIDADES_DISPONIBLES` (IN `idProyectoU` INT(11), IN `idUsuarioU` INT(11))  NO SQL
BEGIN

SELECT ac.idActividad,ac.NombreTarea,e.nombreEstado FROM proyecto pro INNER JOIN actividad ac On ac.Proyecto_idProyecto=pro.idProyecto INNER JOIN participacion par ON par.Actividad_idActividad=ac.idActividad INNER JOIN persona per ON per.idPersona=par.Persona_idPersona INNER JOIN usuario u ON u.Persona_idPersona=per.idPersona INNER JOIN estado e ON e.idEstado=ac.Estado_idEstado
where u.idUsuario=idUsuarioU and pro.idProyecto=idProyectoU
GROUP BY ac.idActividad ORDER BY ac.idActividad ASC;

END$$

DROP PROCEDURE IF EXISTS `SP_RECUPERAR_INDICADORES`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_RECUPERAR_INDICADORES` (IN `idProyec` INT(11))  NO SQL
BEGIN

SELECT pro.NombreProyecto,
(SELECT COUNT(DISTINCT(par.Persona_idPersona)) FROM participacion par INNER JOIN actividad act ON act.idActividad=par.Actividad_idActividad where act.Proyecto_idProyecto=pro.idProyecto) as CantidadParticipantes,

(SELECT COUNT(*) FROM actividad ac1 where ac1.Proyecto_idProyecto=pro.idProyecto) as CantidadActividades,

(SELECT COUNT(*) FROM actividad ac2 inner join tarea ta2 ON ta2.Actividad_idActividad=ac2.idActividad where ac2.Proyecto_idProyecto=pro.idProyecto) as CantidadTareas,

(TIMESTAMPDIFF(DAY,pro.fechaInicio,pro.fechaFin)) as HorasProgramadas,

IFNULL((SELECT SUM(tg.DiasGestion) FROM actividad ac3 INNER JOIN tarea ta3 On ta3.Actividad_idActividad=ac3.idActividad INNER JOIN tareagestion tg On tg.Tarea_idTarea=ta3.idTarea where ac3.Proyecto_idProyecto=pro.idProyecto),'0')as HorasRealizadas,

(SELECT SUM(ac5.Costo) FROM actividad ac5 WHERE ac5.Proyecto_idProyecto=pro.idProyecto) as CostoPresupuestado,

IFNULL(((SELECT SUM(tg.DiasGestion) FROM actividad ac3 INNER JOIN tarea ta3 On ta3.Actividad_idActividad=ac3.idActividad INNER JOIN tareagestion tg On tg.Tarea_idTarea=ta3.idTarea where ac3.Proyecto_idProyecto=pro.idProyecto)*100)/(TIMESTAMPDIFF(DAY,pro.fechaInicio,pro.fechaFin)),'0') as PorcentajeAvance,

IFNULL(100-((SELECT SUM(tg.DiasGestion) FROM actividad ac3 INNER JOIN tarea ta3 On ta3.Actividad_idActividad=ac3.idActividad INNER JOIN tareagestion tg On tg.Tarea_idTarea=ta3.idTarea where ac3.Proyecto_idProyecto=pro.idProyecto)*100)/(TIMESTAMPDIFF(DAY,pro.fechaInicio,pro.fechaFin)),'0') as PorcentajeNoAvance

FROM proyecto pro LEFT JOIN actividad ac ON ac.Proyecto_idProyecto=pro.idProyecto
WHERE pro.idProyecto=idProyec
GROUP BY pro.idProyecto ;
 

END$$

DROP PROCEDURE IF EXISTS `SP_RECUPERAR_INDICADOR_FECHAS`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_RECUPERAR_INDICADOR_FECHAS` ()  NO SQL
BEGIN 


SELECT pro.NombreProyecto,ac.NombreTarea FROM proyecto pro INNER JOIN actividad ac ON ac.Proyecto_idProyecto=pro.idProyecto;


END$$

DROP PROCEDURE IF EXISTS `SP_RECUPERAR_PARAMETROS`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_RECUPERAR_PARAMETROS` (OUT `Proyectos` INT(11), OUT `Tareas` INT(11), OUT `Empleados` INT(11), OUT `Usuarios` INT(11))  NO SQL
BEGIN


SET Proyectos=(SELECT COUNT(*) FROM proyecto);
SET Tareas=(SELECT COUNT(*) FROM tarea);
SET Empleados=(SELECT COUNT(*) FROM usuario u WHERE u.Perfil_idPerfil=10);

SET Usuarios=(SELECT COUNT(*) FROM usuario);

END$$

DROP PROCEDURE IF EXISTS `SP_RECUPERAR_PROYECTOS`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_RECUPERAR_PROYECTOS` ()  NO SQL
BEGIN

SELECT pro.idProyecto,
pro.NombreProyecto,
IFNULL((SELECT COUNT(*) FROM tarea tt WHERE tt.Proyecto_idProyecto=pro.idProyecto) ,'0')as NumeroTareas,

IFNULL(ta.CantidadHoras,'0') as HorasProgramadas,
IFNULL(SUM(sub.CantidadHora),'0')as HorasRealizadas,

IFNULL(ta.Costo,'0.00') as CostoPresupuestado,
IFNULL((ROUND((ta.Costo/ta.CantidadHoras)*SUM(sub.CantidadHora),2)) ,'0')as CostoRealizado,

IFNULL(CONCAT(ROUND((SUM(sub.CantidadHora)*100)/ta.CantidadHoras ,2),'%'),'0') as PorcentajeAvance

FROM proyecto pro LEFT JOIN tarea ta ON ta.idTarea=pro.idProyecto LEFT JOIN subtarea sub ON sub.Tarea_idTarea=ta.idTarea  GROUP BY pro.idProyecto;


END$$

DROP PROCEDURE IF EXISTS `SP_RECUPERAR_PROYECTOS_ASIGNADOS`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_RECUPERAR_PROYECTOS_ASIGNADOS` (IN `idUsU` INT(11))  NO SQL
BEGIN

SELECT pro.idProyecto,pro.NombreProyecto,cli.NombreCliente,ta.idTarea,ta.NombreTarea,ta.CantidadHoras,ta.fechaRegistro,ta.Estado_idEstado,e.nombreEstado FROM proyecto pro INNER JOIN tarea ta ON pro.idProyecto=ta.Proyecto_idProyecto INNER JOIN cliente cli ON cli.idCliente=pro.Cliente_idCliente INNER JOIN estado e ON e.idEstado=ta.Estado_idEstado INNER JOIN usuario u ON u.Persona_idPersona=ta.Persona_idPersona WHERE u.idUsuario=idUsU;

END$$

DROP PROCEDURE IF EXISTS `SP_RECUPERAR_PROYECTOS_DISPONIBLES`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_RECUPERAR_PROYECTOS_DISPONIBLES` (IN `idUsuarioE` INT(11))  NO SQL
BEGIN

SELECT pro.idProyecto,pro.NombreProyecto FROM proyecto pro INNER JOIN actividad ac On ac.Proyecto_idProyecto=pro.idProyecto INNER JOIN participacion par ON par.Actividad_idActividad=ac.idActividad INNER JOIN persona per ON per.idPersona=par.Persona_idPersona INNER JOIN usuario u ON u.Persona_idPersona=per.idPersona where u.idUsuario=idUsuarioE
GROUP BY pro.idProyecto ORDER BY pro.idProyecto ASC;

END$$

DROP PROCEDURE IF EXISTS `SP_RECUPERAR_TAREAS_DISPONIBLES`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_RECUPERAR_TAREAS_DISPONIBLES` (IN `idActividadU` INT(11), IN `idProyectoU` INT(11), IN `idUsuarioU` INT(11))  NO SQL
BEGIN

SELECT
t.idTarea,
t.NombreTarea,
e.nombreEstado
FROM proyecto pro
INNER JOIN actividad ac
On ac.Proyecto_idProyecto=pro.idProyecto
INNER JOIN tarea t
On t.Actividad_idActividad=ac.idActividad
INNER JOIN participacion par ON par.Actividad_idActividad=ac.idActividad
INNER JOIN persona per
ON per.idPersona=par.Persona_idPersona
INNER JOIN usuario u
ON u.Persona_idPersona=per.idPersona
INNER JOIN estado e
ON e.idEstado=t.Estado_idEstado

where u.idUsuario=idUsuarioU and pro.idProyecto=idProyectoU and ac.idActividad=idActividadU
GROUP BY t.idTarea ORDER BY t.idTarea ASC;

END$$

DROP PROCEDURE IF EXISTS `SP_RELACION_AGREGAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_RELACION_AGREGAR` (IN `idApoderadoE` INT(11), IN `idAlumnoE` INT(11), IN `creador` INT)  NO SQL
BEGIN

INSERT INTO `relacionhijos`(`idRelacionHijos`, `Apoderado_idApoderado`, `Alumno_idAlumno`, `Estado_idEstado`, `fechaRegistro`) VALUES (NULL,idApoderadoE,idAlumnoE,1,NOW());


/* ------ REGISTRO DE BITACORA ------ */
SET @NombreUsuario=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM usuario u inner join persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=creador);


INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'REGISTRO','Relacion',CONCAT('SE AGREGO ALUMNO:',idAlumnoE,' A APODERADO:',idApoderadoE),NOW());

END$$

DROP PROCEDURE IF EXISTS `SP_RELACION_ELIMINAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_RELACION_ELIMINAR` (IN `idRelacion` INT(11), IN `creador` INT(11))  NO SQL
BEGIN

UPDATE `relacionhijos` SET  `Estado_idEstado`=2 WHERE `idRelacionHijos`=idRelacion;

/* ------ REGISTRO DE BITACORA ------ */
SET @NombreUsuario=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM usuario u inner join persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=creador);


INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'ELIMINAR','Relacion','SE QUITO RELACION',NOW());

END$$

DROP PROCEDURE IF EXISTS `SP_RELACION_LISTAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_RELACION_LISTAR` (IN `idApoderadoE` INT(11))  NO SQL
BEGIN


SELECT rel.idRelacionHijos,
concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NomAlumno,
p.DNI ,
rel.Estado_idEstado,e.nombreEstado,rel.fechaRegistro
FROM relacionhijos rel
INNER JOIN alumno al
ON al.idAlumno=rel.Alumno_idAlumno
INNER JOIN persona p
ON p.idPersona=al.Persona_idPersona
INNER JOIN estado e
ON e.idEstado=rel.Estado_idEstado
WHERE rel.Apoderado_idApoderado=idApoderadoE;


END$$

DROP PROCEDURE IF EXISTS `SP_RELACION_RECUPERAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_RELACION_RECUPERAR` (IN `idRelacionU` INT(11), IN `creador` INT(11))  NO SQL
BEGIN

UPDATE `relacionhijos` SET  `Estado_idEstado`=1 WHERE `idRelacionHijos`=idRelacionU;

/* ------ REGISTRO DE BITACORA ------ */
SET @NombreUsuario=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM usuario u inner join persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=creador);


INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'ELIMINAR','Relacion','SE QUITO RELACION',NOW());

END$$

DROP PROCEDURE IF EXISTS `SP_SUBTAREA_ACTUALIZAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_SUBTAREA_ACTUALIZAR` (IN `idTareaU` INT(11), IN `DescripcionU` TEXT, IN `Inicio` DATE, IN `Fin` DATE, IN `estado` INT(11), IN `idActividadU` INT(11), IN `idProyectoU` INT(11), IN `creador` INT(11), IN `Nombre` INT)  NO SQL
BEGIN

UPDATE `tarea` SET `Descripcion`=DescripcionU,`NombreTarea`=Nombre,`Estado_idEstado`=estado WHERE `idTarea`=idTareaU;

/* ------ REGISTRO DE BITACORA ------ */
SET @NombreUsuario=(SELECT u.usuario FROM usuario u WHERE u.idUsuario=creador);

INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'ACTUALIZACION','SUBTAREA',CONCAt("SE ACTUALIZO SUBTAREA:",descri),NOW());
END$$

DROP PROCEDURE IF EXISTS `SP_SUBTAREA_HABILITACION`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_SUBTAREA_HABILITACION` (IN `idSubtareaA` INT(11), IN `codigo` INT(11), IN `creador` INT(11))  NO SQL
BEGIN

if (codigo=1) then

    UPDATE `tarea` SET `Estado_idEstado`=4  WHERE `idTarea`=idSubtareaA;
  SET @Mensaje=("SUBTAREA DESHABILITADO");
else
   UPDATE `tarea` SET `Estado_idEstado`=1  WHERE `idTarea`=idSubtareaA;
 SET  @Mensaje=("SUBTAREA HABILITADO");
end if;

 /* ------ REGISTRO DE BITACORA ------ */

set @usuario=(SELECT u.usuario FROM usuario u  WHERE u.idUsuario=creador);

set @tipotar=(SELECT tip.Descripcion FROM subtarea tip WHERE tip.idSubTarea=idSubtareaA);

INSERT INTO `bitacora`(`usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (@usuario,@Mensaje,'SUBTAREA',CONCAT(@Mensaje," :", @tipotar),NOW());

END$$

DROP PROCEDURE IF EXISTS `SP_SUBTAREA_LISTAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_SUBTAREA_LISTAR` (IN `idActividadU` INT(11))  NO SQL
BEGIN

SELECT t.idTarea,t.NombreTarea,t.Descripcion,t.fechaRegistro,DATE_FORMAT(t.fechaInicio,"%d/%m/%Y") as fechaInicio,DATE_FORMAT(t.fechaFin,"%d/%m/%Y") as fechaFin,ac.NombreTarea as NombreActividad,t.Estado_idEstado,e.nombreEstado FROM tarea t INNER JOIN actividad ac ON ac.idActividad=t.Actividad_idActividad INNER JOIN estado e ON e.idEstado=t.Estado_idEstado WHERE ac.idActividad=idActividadU;

END$$

DROP PROCEDURE IF EXISTS `SP_SUBTAREA_RECUPERAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_SUBTAREA_RECUPERAR` (IN `idTareaE` INT(11))  NO SQL
BEGIN

SELECT * FROM tarea tip WHERE tip.idTarea=idTareaE;

END$$

DROP PROCEDURE IF EXISTS `SP_SUBTAREA_RECUPERAR_FECHA`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_SUBTAREA_RECUPERAR_FECHA` (IN `idActividadE` INT(11))  NO SQL
BEGIN

DECLARE encontro DATE;
DECLARE fecha VARCHAR(50);

SET encontro=(SELECT pro.fechaFin as Fecha FROM actividad ac INNER JOIN proyecto pro ON pro.idProyecto=ac.Proyecto_idProyecto where ac.idActividad=idActividadE);

IF(encontro IS NULL)then
SET fecha="NO ENCONTRO";
else
SET fecha=(DATE_FORMAT(encontro,"%d/%m/%Y"));
end if;

SELECT fecha;

END$$

DROP PROCEDURE IF EXISTS `SP_SUBTAREA_REGISTRO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_SUBTAREA_REGISTRO` (IN `DescU` TEXT, IN `Inicio` DATE, IN `Fin` DATE, IN `estado` INT(11), IN `idActividadU` INT(11), IN `idProyectoU` INT(11), IN `creador` INT(11), IN `Nombre` VARCHAR(150))  NO SQL
BEGIN

DECLARE FechaInicioProyecto DATE ;
DECLARE FechaInicioActividad DATE;

INSERT INTO `tarea`(`idTarea`,`NombreTarea`, `Descripcion`,`fechaRegistro`,`fechaInicio`,`fechaFin`, `Actividad_idActividad`, `Estado_idEstado`) VALUES (NULL,Nombre,DescU,NOW(),Inicio,Fin,idActividadU,estado);

SET FechaInicioProyecto=(SELECT pro.fechaInicio FROM proyecto pro WHERE pro.idProyecto=idProyectoU);
SET FechaInicioActividad=(SELECT act.fechaInicio FROM actividad act WHERE act.idActividad=idActividadU);

IF(FechaInicioProyecto IS NULL)THEN
   UPDATE proyecto p SET p.fechaInicio=Inicio,p.fechaFin=Fin WHERE p.idProyecto=idProyectoU;
ELSE
	UPDATE proyecto p SET p.fechaFin=Fin WHERE p.idProyecto=idProyectoU;
END IF;

 IF(FechaInicioActividad IS NULL)THEN
   UPDATE actividad a SET a.fechaInicio=Inicio,a.fechaFin=Fin WHERE a.idActividad=idActividadU;
   ELSE
    UPDATE actividad a SET a.fechaFin=Fin WHERE a.idActividad=idActividadU;
   END IF;

SET @NombreUsuario=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM usuario u inner join persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=creador);


INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'INSERTAR','SE REGISTRO TAREA','TAREA',NOW());

END$$

DROP PROCEDURE IF EXISTS `SP_TIPO_TARJETA_LISTAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_TIPO_TARJETA_LISTAR` ()  NO SQL
BEGIN


SELECT * FROM tipotarjeta t where t.Estado_idEstado=1 or t.Estado_idEstado=3;
END$$

DROP PROCEDURE IF EXISTS `SP_USUARIO_ACTUALIZAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_USUARIO_ACTUALIZAR` (IN `usuarioE` VARCHAR(50), IN `passE` TEXT, IN `idPerfil` INT(11), IN `idEstado` INT(11), IN `idUsuarioU` INT(11), IN `idCreador` INT(11))  NO SQL
BEGIN

DECLARE Mensaje VARCHAR(100);

-- ACTUALIZAR USUARIO
if(pass='-1')then

UPDATE `usuario` SET 		`usuario`=usuarioE,`Perfil_idPerfil`=idPerfil,`Estado_idEstado`=idEstado WHERE  `idUsuario`= idUsuarioU;
set Mensaje="SE ACTUALIZO EL USUARIO:";

else

UPDATE `usuario` SET 		`usuario`=usuarioE,`pass`=passE,`Perfil_idPerfil`=idPerfil,`Estado_idEstado`=idEstado WHERE  `idUsuario`= idUsuarioU;
set Mensaje="SE ACTUALIZO EL USUARIO:";
end if;



-- REGISTRAR BITACORA
SET @NombreUsuario=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM usuario u inner join persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=idCreador);

INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'ACTUALIZACION','USUARIO',CONCAT(Mensaje,usuarioE),NOW());



END$$

DROP PROCEDURE IF EXISTS `SP_USUARIO_HABILITACION`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_USUARIO_HABILITACION` (IN `idUsuarioE` INT(11), IN `codigo` INT(11), IN `idUsuarioM` INT(11))  NO SQL
BEGIN

SET @NombreUsuario=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM usuario u inner join persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=idUsuarioM);


if (codigo=1) then
 	UPDATE `usuario` SET  `Estado_idEstado`=4 WHERE `idUsuario`=idUsuarioE;
  SET @Mensaje=("USUARIO DESHBILITADO");
else
    UPDATE `usuario` SET  `Estado_idEstado`=1  WHERE `idUsuario`=idUsuarioE;
 SET  @Mensaje=("USAURIO HABILITADO");
end if;

 /* ------ REGISTRO DE BITACORA ------ */

set @usuario=(SELECT u.usuario FROM usuario u  WHERE u.idUsuario=idUsuarioE);

INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@usuario,@Mensaje,'USUARIO',CONCAT("SE",@Mensaje," :", @NombreUsuario),NOW());

END$$

DROP PROCEDURE IF EXISTS `SP_USUARIO_LISTAR_TODO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_USUARIO_LISTAR_TODO` ()  NO SQL
BEGIN

SELECT
u.idUsuario,
u.usuario,
DATE_FORMAT(u.fechaRegistro,'%d/%m/%Y') as fechaRegistro,
CONCAT(pes.nombrePersona,' ',pes.apellidoPaterno,' ',pes.apellidoMaterno) as NombrePersona,
e.nombreEstado,
e.idEstado as Estado_idEstado,
per.nombrePerfil
FROM usuario u INNER JOIN estado e ON e.idEstado=u.Estado_idEstado INNER JOIN perfil per ON per.idPerfil=u.Perfil_idPerfil INNER JOIN persona pes ON pes.idPersona=u.Persona_idPersona;

END$$

DROP PROCEDURE IF EXISTS `SP_USUARIO_RECUPERAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_USUARIO_RECUPERAR` (IN `idUsuarioE` INT)  NO SQL
BEGIN


SELECT * FROM usuario u WHERE u.idUsuario=idUsuarioE;


END$$

DROP PROCEDURE IF EXISTS `SP_USUARIO_RECUPERAR_TOTALES`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_USUARIO_RECUPERAR_TOTALES` ()  NO SQL
BEGIN

DECLARE Total1 INT(11);
DECLARE Total2 INT(11);
DECLARE Total3 INT(11);
DECLARE Total4 INT(11);

SET Total1=(SELECT COUNT(*) FROM usuario u WHERE u.Perfil_idPerfil=1);
SET Total2=(SELECT COUNT(*) FROM usuario u WHERE u.Perfil_idPerfil=9);
SET Total3=(SELECT COUNT(*) FROM usuario u WHERE u.Perfil_idPerfil=10);
SET Total4=(SELECT COUNT(*) FROM usuario u);

SELECT Total1,Total2,Total3,Total4;
END$$

DROP PROCEDURE IF EXISTS `SP_USUARIO_REGISTRO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_USUARIO_REGISTRO` (IN `usuarioE` VARCHAR(50), IN `passE` TEXT, IN `idPerfil` INT(11), IN `idPersona` INT(11), IN `idEstado` INT(11), IN `idCreador` INT(11))  NO SQL
BEGIN

DECLARE Mensaje VARCHAR(100);

-- REGISTRO USUARIO --
INSERT INTO `usuario`(`usuario`, `pass`, `Perfil_idPerfil`, `Persona_idPersona`, `Estado_idEstado`, `fechaRegistro`) VALUES (usuarioE,passE,idPerfil,idPersona,idEstado,NOW());

set Mensaje="SE REGISTRO EL USUARIO:";


-- REGISTRAR BITACORA
SET @NombreUsuario=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM usuario u inner join persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=idCreador);

INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'REGISTRO','USUARIO',CONCAT(Mensaje,usuarioE),NOW());

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `actividad`
--

DROP TABLE IF EXISTS `actividad`;
CREATE TABLE IF NOT EXISTS `actividad` (
  `idActividad` int(11) NOT NULL AUTO_INCREMENT,
  `NombreTarea` varchar(200) NOT NULL,
  `Descripcion` text NOT NULL,
  `Costo` decimal(10,2) NOT NULL,
  `fechaRegistro` datetime NOT NULL,
  `fechaInicio` date DEFAULT NULL,
  `fechaFin` date DEFAULT NULL,
  `Proyecto_idProyecto` int(11) NOT NULL,
  `Participacion_idParticipacion` int(11) DEFAULT NULL,
  `Estado_idEstado` int(11) NOT NULL,
  PRIMARY KEY (`idActividad`),
  KEY `FK_Tarea_Proyecto` (`Proyecto_idProyecto`),
  KEY `FK_Tarea_Perona` (`Participacion_idParticipacion`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `actividad`
--

INSERT INTO `actividad` (`idActividad`, `NombreTarea`, `Descripcion`, `Costo`, `fechaRegistro`, `fechaInicio`, `fechaFin`, `Proyecto_idProyecto`, `Participacion_idParticipacion`, `Estado_idEstado`) VALUES
(11, 'Iniciación', 'Fase de inicio del proyecto', '6000.00', '2018-10-20 17:17:21', '2018-10-01', '2018-11-10', 5, NULL, 3),
(12, 'Planificación', 'Fase de Planificación del Proyecto', '8000.00', '2018-10-20 17:17:55', '2018-11-10', '2018-11-29', 5, NULL, 3),
(13, 'Ejecución', 'Fase de Ejecución del Proyecto', '20000.00', '2018-10-20 17:18:32', '2018-11-29', '2018-12-20', 5, NULL, 3),
(14, 'Control', 'Fase de Control del Proyecto', '4000.00', '2018-10-20 17:18:54', '2018-12-20', '2018-12-31', 5, NULL, 3),
(15, 'Cierre', 'Fase de Cierre del Proyecto', '5000.00', '2018-10-20 17:19:12', '2018-12-31', '2019-01-19', 5, NULL, 3),
(16, 'Iniciación', 'Fase de Iniciación del Proyecto', '3500.00', '2018-10-20 17:20:37', '2018-10-01', '2018-10-31', 6, NULL, 3),
(17, 'Planificación', 'Fase de   Planificación del Proyecto', '4500.00', '2018-10-20 17:21:03', '2018-10-31', '2018-11-16', 6, NULL, 3),
(18, 'Ejecución', 'Fase de   Ejecución  del Proyecto', '35000.00', '2018-10-20 17:21:33', '2018-11-16', '2018-11-23', 6, NULL, 3),
(19, 'Control', 'Fase de Control del Proyecto', '5000.00', '2018-10-20 17:21:57', '2018-11-23', '2018-11-30', 6, NULL, 3),
(20, 'Cierre', 'Fase de Cierre del Proyecto', '3600.00', '2018-10-20 17:22:19', '2018-11-30', '2018-12-14', 6, NULL, 3),
(21, 'Iniciación', 'Fase de    Iniciación del Proyecto', '4000.00', '2018-10-20 17:22:55', '2018-10-01', '2018-10-04', 7, NULL, 3),
(22, 'Planificación', 'Fase de    Planificación del Proyecto', '6500.00', '2018-10-20 17:23:17', '2018-10-04', '2018-10-11', 7, NULL, 3),
(23, 'Ejecución', 'Fase de Ejecución del Proyecto', '45000.00', '2018-10-20 17:23:43', '2018-10-11', '2018-10-30', 7, NULL, 3),
(24, 'Control', 'Fase de Control del Proyecto', '4000.00', '2018-10-20 17:24:12', '2018-10-31', '2018-11-02', 7, NULL, 3),
(25, 'Cierre', 'Fase de Cierre del Proyecto', '4500.00', '2018-10-20 17:24:28', '2018-11-02', '2018-11-28', 7, NULL, 3),
(26, 'Iniciación', 'Fase de        Iniciación  del Proyecto', '3500.00', '2018-10-20 17:24:59', '2018-10-10', '2018-10-31', 8, NULL, 3),
(27, 'Planificación', 'Fase de    Planificación del Proyecto', '6500.00', '2018-10-20 17:25:19', '2018-10-31', '2018-11-16', 8, NULL, 3),
(28, 'Ejecución', 'Fase de Ejecución del Proyecto', '25500.00', '2018-10-20 17:25:41', '2018-11-16', '2018-11-22', 8, NULL, 3),
(29, 'Control', 'Fase de Control del Proyecto', '2500.00', '2018-10-20 17:26:03', '2018-11-22', '2018-11-30', 8, NULL, 3),
(30, 'Cierre', 'Fase de Cierre del Proyecto', '3500.00', '2018-10-20 17:26:21', '2018-11-30', '2018-12-13', 8, NULL, 3),
(31, 'Iniciación', 'Fase de Iniciación  del Proyecto', '8500.00', '2018-10-20 17:26:51', '2018-10-16', '2018-10-30', 9, NULL, 3),
(32, 'Planificación', 'Fase de   Planificación  del Proyecto', '15000.00', '2018-10-20 17:27:14', '2018-10-30', '2018-11-06', 9, NULL, 3),
(33, 'Ejecución', 'Fase de Ejecución del Proyecto', '65000.00', '2018-10-20 17:27:41', '2018-11-06', '2018-11-14', 9, NULL, 3),
(34, 'Control', 'Fase de Control del Proyecto', '5500.00', '2018-10-20 17:27:59', '2018-11-14', '2018-11-17', 9, NULL, 3),
(35, 'Cierre', 'Fase de Cierre del Proyecto', '4500.00', '2018-10-20 17:28:15', '2018-11-17', '2018-11-22', 9, NULL, 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bitacora`
--

DROP TABLE IF EXISTS `bitacora`;
CREATE TABLE IF NOT EXISTS `bitacora` (
  `idBitacora` int(11) NOT NULL AUTO_INCREMENT,
  `usuarioAccion` varchar(100) NOT NULL,
  `Accion` varchar(100) NOT NULL,
  `tablaAccion` varchar(100) NOT NULL,
  `Detalle` text NOT NULL,
  `fechaRegistro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idBitacora`)
) ENGINE=InnoDB AUTO_INCREMENT=581 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `bitacora`
--

INSERT INTO `bitacora` (`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`, `Detalle`, `fechaRegistro`) VALUES
(1, 'JESUS INCA CARDENAS', 'INSERTAR', 'USUARIO', 'SE REGISTRO EL USUARIO:admin3', '2018-09-29 19:53:29'),
(2, 'JESUS INCA CARDENAS', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:usuaricambia', '2018-09-29 19:56:41'),
(3, 'JESUS INCA CARDENAS', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba', '2018-09-29 20:00:24'),
(4, 'JESUS INCA CARDENAS', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:nuevo', '2018-09-29 20:01:47'),
(5, 'JESUS INCA CARDENAS', 'USUARIO DESHBILITADO', 'USUARIO', 'SEUSUARIO DESHBILITADO :admin', '2018-10-03 00:56:59'),
(6, 'JESUS INCA CARDENAS', 'USUARIO DESHBILITADO', 'USUARIO', 'SEUSUARIO DESHBILITADO :admin', '2018-10-03 01:04:58'),
(7, 'JESUS INCA CARDENAS', 'USAURIO HABILITADO', 'USUARIO', 'SEUSAURIO HABILITADO :admin', '2018-10-03 01:09:40'),
(8, 'JESUS INCA CARDENAS', 'USUARIO DESHBILITADO', 'USUARIO', 'SEUSUARIO DESHBILITADO :admin', '2018-10-03 01:09:44'),
(9, 'JESUS INCA CARDENAS', 'USAURIO HABILITADO', 'USUARIO', 'SEUSAURIO HABILITADO :admin', '2018-10-03 01:09:47'),
(10, 'JESUS INCA CARDENAS', 'ACTUALIZO', 'USUARIO', 'SE REGISTRO EL USUARIO:wdqw', '2018-10-03 02:00:09'),
(11, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE REGISTRO EL USUARIO:msilva', '2018-10-04 13:29:08'),
(12, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE REGISTRO EL USUARIO:JLOPEZ', '2018-10-04 13:35:15'),
(13, 'MAJE SILVA SILVA', 'USUARIO DESHBILITADO', 'USUARIO', 'SEUSUARIO DESHBILITADO :JLOPEZ', '2018-10-04 13:35:27'),
(14, 'MAJE SILVA SILVA', 'USAURIO HABILITADO', 'USUARIO', 'SEUSAURIO HABILITADO :JLOPEZ', '2018-10-04 13:35:36'),
(15, 'MAJE SILVA SILVA', 'USUARIO DESHBILITADO', 'USUARIO', 'SEUSUARIO DESHBILITADO :JLOPEZ', '2018-10-04 13:35:40'),
(16, 'MAJE SILVA SILVA', 'USAURIO HABILITADO', 'USUARIO', 'SEUSAURIO HABILITADO :JLOPEZ', '2018-10-04 13:35:42'),
(17, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba', '2018-10-04 16:38:33'),
(18, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:msilva2', '2018-10-04 16:39:27'),
(19, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin', '2018-10-04 16:45:08'),
(20, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba2', '2018-10-04 16:45:17'),
(21, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba2', '2018-10-04 16:45:47'),
(22, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba2', '2018-10-04 16:46:08'),
(23, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba3', '2018-10-04 16:47:16'),
(24, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba1', '2018-10-04 16:47:56'),
(25, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba1', '2018-10-04 16:48:23'),
(26, 'JESUS INCA CARDENAS', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba3', '2018-10-04 16:50:18'),
(27, 'JESUS INCA CARDENAS', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba3', '2018-10-04 16:51:20'),
(28, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin2', '2018-10-04 16:52:32'),
(29, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba3', '2018-10-04 16:55:17'),
(30, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba3', '2018-10-04 16:55:33'),
(31, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba3', '2018-10-04 16:55:53'),
(32, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba2', '2018-10-04 16:56:02'),
(33, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba2', '2018-10-04 16:56:09'),
(34, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba2', '2018-10-04 16:56:32'),
(35, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba2', '2018-10-04 16:58:27'),
(36, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba2', '2018-10-04 16:59:13'),
(37, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba2', '2018-10-04 17:01:09'),
(38, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba2', '2018-10-04 17:03:37'),
(39, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba2', '2018-10-04 17:04:28'),
(40, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba2', '2018-10-04 17:04:43'),
(41, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba2', '2018-10-04 17:05:07'),
(42, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba2', '2018-10-04 17:05:52'),
(43, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba2', '2018-10-04 17:06:14'),
(44, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba', '2018-10-04 17:07:12'),
(45, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba', '2018-10-04 17:08:37'),
(46, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba', '2018-10-04 17:09:29'),
(47, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba', '2018-10-04 17:10:33'),
(48, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba', '2018-10-04 17:11:14'),
(49, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba', '2018-10-04 17:12:14'),
(50, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba', '2018-10-04 17:12:22'),
(51, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba', '2018-10-04 17:13:03'),
(52, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba', '2018-10-04 17:13:14'),
(53, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba', '2018-10-04 17:14:09'),
(54, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba', '2018-10-04 17:14:50'),
(55, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba', '2018-10-04 17:14:50'),
(56, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba', '2018-10-04 17:15:39'),
(57, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba', '2018-10-04 17:15:47'),
(58, 'JESUS INCA CARDENAS', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba', '2018-10-04 17:17:05'),
(59, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin2', '2018-10-04 17:19:14'),
(60, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin2', '2018-10-04 17:19:43'),
(61, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin2', '2018-10-04 17:22:44'),
(62, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin2', '2018-10-04 17:23:08'),
(63, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin2', '2018-10-04 17:24:49'),
(64, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin', '2018-10-04 17:29:52'),
(65, 'JESUS INCA CARDENAS', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin', '2018-10-04 17:31:53'),
(66, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin', '2018-10-04 17:32:14'),
(67, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin', '2018-10-04 17:48:50'),
(68, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin', '2018-10-04 17:49:27'),
(69, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin', '2018-10-04 17:53:16'),
(70, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin', '2018-10-04 17:54:56'),
(71, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin', '2018-10-04 17:55:24'),
(72, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin', '2018-10-04 17:56:52'),
(73, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin', '2018-10-04 18:00:31'),
(74, 'JESUS INCA CARDENAS', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin', '2018-10-04 18:03:17'),
(75, 'JESUS INCA CARDENAS', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin', '2018-10-04 18:04:41'),
(76, 'JESUS INCA CARDENAS', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin', '2018-10-04 18:06:15'),
(77, 'JESUS INCA CARDENAS', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba2', '2018-10-05 10:02:27'),
(78, 'JESUS INCA CARDENAS', 'ACTUALIZO', 'USUARIO', 'SE REGISTRO EL USUARIO:persona', '2018-10-05 10:14:26'),
(79, 'JESUS INCA CARDENAS', 'ACTUALIZO', 'USUARIO', 'SE REGISTRO EL USUARIO:persona2', '2018-10-05 10:16:34'),
(80, 'JESUS INCA CARDENAS', 'ACTUALIZO', 'USUARIO', 'SE REGISTRO EL USUARIO:prueba', '2018-10-05 10:17:48'),
(81, 'JESUS INCA CARDENAS', 'ACTUALIZO', 'USUARIO', 'SE REGISTRO EL USUARIO:prueba1', '2018-10-05 10:18:17'),
(82, 'JESUS INCA CARDENAS', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba2', '2018-10-05 10:39:30'),
(83, 'JESUS INCA CARDENAS', 'INSERTAR', 'Persona', 'SE REGISTRO PERSONA:jesu werfwe fefwe', '2018-10-05 10:51:36'),
(84, 'JESUS INCA CARDENAS', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:jesus inca cardenas', '2018-10-05 11:11:11'),
(85, 'JESUS INCA CARDENAS', 'REGISTRO', 'Persona', 'SE REGISTRO PERSONA:wfwefwe werfwef frefwef', '2018-10-05 12:48:34'),
(86, 'JESUS INCA CARDENAS', 'USUARIO DESHBILITADO', 'USUARIO', 'SEUSUARIO DESHBILITADO :admin', '2018-10-05 13:36:40'),
(87, 'JESUS INCA CARDENAS', 'USUARIO DESHBILITADO', 'USUARIO', 'SEUSUARIO DESHBILITADO :admin', '2018-10-05 13:36:46'),
(88, 'admin', 'PERSONA DESHBILITADO', 'USUARIO', 'SEPERSONA DESHBILITADO :JESUS INCA CARDENAS', '2018-10-05 13:38:27'),
(89, 'admin', 'PERSONA HABILITADO', 'USUARIO', 'SEPERSONA HABILITADO :JESUS INCA CARDENAS', '2018-10-05 13:38:30'),
(90, 'admin', 'PERSONA DESHBILITADO', 'USUARIO', 'SEPERSONA DESHBILITADO :JESUS INCA CARDENAS', '2018-10-05 13:38:32'),
(91, 'admin', 'PERSONA DESHBILITADO', 'USUARIO', 'SEPERSONA DESHBILITADO :LUCIA TABOADA GUZMAN', '2018-10-05 13:59:32'),
(92, 'admin', 'PERSONA HABILITADO', 'USUARIO', 'SEPERSONA HABILITADO :JESUS INCA CARDENAS', '2018-10-05 14:00:13'),
(93, 'JESUS23 INCA23 CARDENAS', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:JESUS23 INCA23 CARDENAS', '2018-10-05 14:42:15'),
(94, 'JESUS233 INCA233 CARDENAS', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:JESUS233 INCA233 CARDENAS', '2018-10-05 14:43:49'),
(95, 'JESUS23331 INCA23314 CARDENAS', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:JESUS23331 INCA23314 CARDENAS', '2018-10-05 14:45:17'),
(96, 'JESUS23331 INCA23314 CARDENAS', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:JESUS23331 INCA23314 CARDENAS', '2018-10-05 14:46:03'),
(97, 'JESUS INCA CARDENAS', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:JESUS INCA CARDENAS', '2018-10-05 14:48:34'),
(98, 'JESUS2 INCA2 CARDENAS', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:JESUS2 INCA2 CARDENAS', '2018-10-05 14:49:29'),
(99, 'admin', 'PERSONA DESHBILITADO', 'USUARIO', 'SEPERSONA DESHBILITADO :JESUS2 INCA2 CARDENAS', '2018-10-05 14:49:35'),
(100, 'JESUS2 INCA2 CARDENAS', 'INSERTAR', 'SE REGISTRO PERFIL', 'Perfil', '2018-10-05 15:42:18'),
(101, 'JESUS2 INCA2 CARDENAS', 'INSERTAR', 'SE REGISTRO PERMISOS DE PERFIL', 'Permisos', '2018-10-05 15:42:18'),
(102, 'JESUS2 INCA2 CARDENAS', 'INSERTAR', 'SE REGISTRO PERFIL', 'Perfil', '2018-10-05 15:42:43'),
(103, 'JESUS2 INCA2 CARDENAS', 'INSERTAR', 'SE REGISTRO PERMISOS DE PERFIL', 'Permisos', '2018-10-05 15:42:43'),
(104, 'admin', 'PERSONA DESHBILITADO', 'USUARIO', 'SEPERSONA DESHBILITADO :MAJE SILVA SILVA', '2018-10-05 15:42:51'),
(105, 'admin', 'ACTUALIZACION', 'Perfil', 'SE ACTUALIZO PERFIL:fweefw', '2018-10-05 15:53:04'),
(106, 'admin', 'ACTUALIZACION', 'Perfil', 'SE ACTUALIZO PERFIL:ADMINISTRADOR', '2018-10-05 15:53:22'),
(107, 'admin', 'ACTUALIZACION', 'Perfil', 'SE ACTUALIZO PERFIL:wefwefew', '2018-10-05 15:54:03'),
(108, 'admin', 'ACTUALIZACION', 'Perfil', 'SE ACTUALIZO PERFIL:wfgwf', '2018-10-05 15:54:11'),
(109, 'admin', 'PERSONA DESHBILITADO', 'USUARIO', 'SEPERSONA DESHBILITADO :JESUS2 INCA2 CARDENAS', '2018-10-05 15:56:36'),
(110, 'admin', 'PERSONA DESHBILITADO', 'USUARIO', 'SEPERSONA DESHBILITADO :JESUS2 INCA2 CARDENAS', '2018-10-05 15:56:44'),
(111, 'admin', 'PERFIL DESHBILITADO', 'PERFIL', 'SEPERFIL DESHBILITADO :ADMINISTRADOR', '2018-10-05 16:02:49'),
(112, 'admin', 'PERFIL HABILITADO', 'PERFIL', 'SEPERFIL HABILITADO :ADMINISTRADOR', '2018-10-05 16:03:01'),
(113, 'admin', 'PERFIL HABILITADO', 'PERFIL', 'SEPERFIL HABILITADO :wefwefew', '2018-10-05 16:03:02'),
(114, 'admin', 'PERFIL HABILITADO', 'PERFIL', 'SEPERFIL HABILITADO :wfgwf', '2018-10-05 16:03:05'),
(115, 'JESUS2 INCA2 CARDENAS', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:jinca', '2018-10-05 20:43:36'),
(116, 'JESUS2 INCA2 CARDENAS', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:jlopez', '2018-10-05 20:52:52'),
(117, 'JESUS2 INCA2 CARDENAS', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:prueba', '2018-10-05 20:54:56'),
(118, 'admin', 'USAURIO HABILITADO', 'USUARIO', 'SEUSAURIO HABILITADO :JESUS2 INCA2 CARDENAS', '2018-10-05 21:09:26'),
(119, 'JESUS2 INCA2 CARDENAS', 'ACTUALIZACION', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba3', '2018-10-05 21:11:21'),
(120, 'admin', 'USUARIO DESHBILITADO', 'USUARIO', 'SEUSUARIO DESHBILITADO :JESUS2 INCA2 CARDENAS', '2018-10-05 21:51:00'),
(121, 'admin', 'USAURIO HABILITADO', 'USUARIO', 'SEUSAURIO HABILITADO :JESUS2 INCA2 CARDENAS', '2018-10-05 21:51:06'),
(122, 'JESUS2 INCA2 CARDENAS', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:jesus', '2018-10-06 12:46:55'),
(123, 'JESUS2 INCA2 CARDENAS', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:jesusinca', '2018-10-06 12:56:12'),
(124, 'JESUS2 INCA2 CARDENAS', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:test', '2018-10-06 16:19:49'),
(125, 'prueba inca fwef', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:test2', '2018-10-06 16:34:20'),
(126, 'prueba inca fwef', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:test3', '2018-10-06 16:34:40'),
(127, 'rtjtyjty yjhrtyj tyjtyj', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:test10', '2018-10-06 16:44:45'),
(128, 'rtjtyjty yjhrtyj tyjtyj', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:test20', '2018-10-06 16:46:13'),
(129, 'rtjtyjty yjhrtyj tyjtyj', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:test30', '2018-10-06 16:47:40'),
(130, 'rtjtyjty yjhrtyj tyjtyj', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:test40', '2018-10-06 16:49:24'),
(131, 'rtjtyjty yjhrtyj tyjtyj', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:test50', '2018-10-06 16:50:10'),
(132, 'JESUS2 INCA2 CARDENAS', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:prueba', '2018-10-06 17:06:26'),
(133, 'LUCIA TABOADA GUZMAN', 'INSERTAR', 'SE REGISTRO PERFIL', 'Perfil', '2018-10-07 11:50:05'),
(134, 'LUCIA TABOADA GUZMAN', 'INSERTAR', 'SE REGISTRO PERMISOS DE PERFIL', 'Permisos', '2018-10-07 11:50:05'),
(135, 'prueba', 'PERFIL DESHABILITADO', 'PERFIL', 'SEPERFIL DESHABILITADO :INVITADO', '2018-10-07 11:53:24'),
(136, 'prueba', 'PERFIL HABILITADO', 'PERFIL', 'SEPERFIL HABILITADO :NUEVO', '2018-10-07 11:53:27'),
(137, 'prueba', 'PERFIL HABILITADO', 'PERFIL', 'SEPERFIL HABILITADO :INVITADO', '2018-10-07 11:53:29'),
(138, 'LUCIA TABOADA GUZMAN', 'INSERTAR', 'SE REGISTRO PERFIL', 'Perfil', '2018-10-07 11:54:28'),
(139, 'LUCIA TABOADA GUZMAN', 'INSERTAR', 'SE REGISTRO PERMISOS DE PERFIL', 'Permisos', '2018-10-07 11:54:28'),
(140, 'prueba', 'PERFIL DESHABILITADO', 'PERFIL', 'SEPERFIL DESHABILITADO :USUARIO', '2018-10-07 11:54:34'),
(141, 'prueba', 'PERFIL HABILITADO', 'PERFIL', 'SEPERFIL HABILITADO :USUARIO', '2018-10-07 11:54:36'),
(142, 'prueba', 'USUARIO DESHBILITADO', 'USUARIO', 'SEUSUARIO DESHBILITADO :LUCIA TABOADA GUZMAN', '2018-10-07 11:59:20'),
(143, 'prueba', 'USAURIO HABILITADO', 'USUARIO', 'SEUSAURIO HABILITADO :LUCIA TABOADA GUZMAN', '2018-10-07 11:59:22'),
(144, 'prueba', 'USUARIO DESHBILITADO', 'USUARIO', 'SEUSUARIO DESHBILITADO :LUCIA TABOADA GUZMAN', '2018-10-07 11:59:24'),
(145, 'prueba', 'USAURIO HABILITADO', 'USUARIO', 'SEUSAURIO HABILITADO :LUCIA TABOADA GUZMAN', '2018-10-07 11:59:26'),
(146, 'JESUS INCA CARDENAS', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:JESUS INCA CARDENAS', '2018-10-07 12:11:52'),
(147, 'admin', 'USUARIO DESHBILITADO', 'USUARIO', 'SEUSUARIO DESHBILITADO :JESUS INCA CARDENAS', '2018-10-07 12:12:41'),
(148, 'admin', 'USAURIO HABILITADO', 'USUARIO', 'SEUSAURIO HABILITADO :JESUS INCA CARDENAS', '2018-10-07 12:12:43'),
(149, 'admin', 'PERSONA DESHBILITADO', 'USUARIO', 'SEPERSONA DESHBILITADO :JESUS INCA CARDENAS', '2018-10-07 12:12:56'),
(150, 'admin', 'PERSONA HABILITADO', 'USUARIO', 'SEPERSONA HABILITADO :JESUS INCA CARDENAS', '2018-10-07 12:12:58'),
(151, 'JESUS INCA CARDENAS', 'REGISTRO', 'Persona', 'SE REGISTRO PERSONA:PERSONA APELLIDO1 APELLIDO2', '2018-10-07 12:13:51'),
(152, 'JESUS INCA CARDENAS', 'REGISTRO', 'Persona', 'SE REGISTRO PERSONA:prueba apellido uno apellido dos', '2018-10-07 12:38:20'),
(153, 'JESUS INCA CARDENAS', 'REGISTRO', 'Persona', 'SE REGISTRO PERSONA:prueba apepa apema', '2018-10-07 12:39:47'),
(154, 'JESUS INCA CARDENAS', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:prueba apepa apema', '2018-10-07 12:39:59'),
(155, 'JESUS INCA CARDENAS', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:prueba apepa apema', '2018-10-07 12:41:04'),
(156, 'JESUS INCA CARDENAS', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:prueba apepa apema', '2018-10-07 12:41:16'),
(157, 'JESUS INCA CARDENAS', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:prueba apepa apema', '2018-10-07 12:41:22'),
(158, 'JESUS INCA CARDENAS', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:prueba apepa apema', '2018-10-07 12:41:28'),
(159, 'JESUS INCA CARDENAS', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:prueba apepa apema', '2018-10-07 12:41:37'),
(160, 'JESUS INCA CARDENAS', 'REGISTRO', 'Persona', 'SE REGISTRO PERSONA:feeqfwe ewfwef wefwef', '2018-10-07 18:35:21'),
(161, 'JESUS INCA CARDENAS', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:feeqfwe ewfwef wefwef', '2018-10-07 18:35:31'),
(162, 'admin', 'PERSONA DESHBILITADO', 'USUARIO', 'SEPERSONA DESHBILITADO :feeqfwe ewfwef wefwef', '2018-10-07 18:35:51'),
(163, 'admin', 'PERSONA HABILITADO', 'USUARIO', 'SEPERSONA HABILITADO :feeqfwe ewfwef wefwef', '2018-10-07 18:35:53'),
(164, 'admin', 'ACTUALIZACION', 'Perfil', 'SE ACTUALIZO PERFIL:USUARIO', '2018-10-07 19:32:06'),
(165, 'JESUS INCA CARDENAS', 'INSERTAR', 'SE REGISTRO PERFIL', 'Perfil', '2018-10-07 20:14:07'),
(166, 'JESUS INCA CARDENAS', 'INSERTAR', 'SE REGISTRO PERMISOS DE PERFIL', 'Permisos', '2018-10-07 20:14:07'),
(167, 'admin', 'SE ACTUALIZO PERMISOS', 'PERMISOS', 'SE ACTUALIZO PERMISOS DE PERFIL:ADMINISTRADOR', '2018-10-07 22:43:04'),
(168, 'admin', 'SE ACTUALIZO PERMISOS', 'PERMISOS', 'SE ACTUALIZO PERMISOS DE PERFIL:ADMINISTRADOR', '2018-10-07 22:44:38'),
(169, 'admin', 'SE ACTUALIZO PERMISOS', 'PERMISOS', 'SE ACTUALIZO PERMISOS DE PERFIL:ADMINISTRADOR', '2018-10-07 22:46:43'),
(170, 'admin', 'SE ACTUALIZO PERMISOS', 'PERMISOS', 'SE ACTUALIZO PERMISOS DE PERFIL:ADMINISTRADOR', '2018-10-07 22:48:24'),
(171, 'admin', 'SE ACTUALIZO PERMISOS', 'PERMISOS', 'SE ACTUALIZO PERMISOS DE PERFIL:ADMINISTRADOR', '2018-10-07 22:48:30'),
(172, 'admin', 'SE ACTUALIZO PERMISOS', 'PERMISOS', 'SE ACTUALIZO PERMISOS DE PERFIL:USUARIO', '2018-10-07 22:48:47'),
(173, 'admin', 'SE ACTUALIZO PERMISOS', 'PERMISOS', 'SE ACTUALIZO PERMISOS DE PERFIL:ADMINISTRADOR', '2018-10-07 22:49:01'),
(174, 'admin', 'SE ACTUALIZO PERMISOS', 'PERMISOS', 'SE ACTUALIZO PERMISOS DE PERFIL:ADMINISTRADOR', '2018-10-07 22:53:20'),
(175, 'admin', 'SE ACTUALIZO PERMISOS', 'PERMISOS', 'SE ACTUALIZO PERMISOS DE PERFIL:USUARIO', '2018-10-07 22:53:35'),
(176, 'JESUS INCA CARDENAS', 'INSERTAR', 'SE REGISTRO PERFIL', 'Perfil', '2018-10-08 00:59:45'),
(177, 'JESUS INCA CARDENAS', 'INSERTAR', 'SE REGISTRO PERMISOS DE PERFIL', 'Permisos', '2018-10-08 00:59:45'),
(178, 'admin', 'ACTUALIZACION', 'Perfil', 'SE ACTUALIZO PERFIL:EMPLEADO', '2018-10-08 01:00:20'),
(179, 'admin', 'SE ACTUALIZO PERMISOS', 'PERMISOS', 'SE ACTUALIZO PERMISOS DE PERFIL:EMPLEADO', '2018-10-08 01:00:55'),
(180, 'admin', 'SE ACTUALIZO PERMISOS', 'PERMISOS', 'SE ACTUALIZO PERMISOS DE PERFIL:APODERADO', '2018-10-08 01:01:12'),
(181, 'JESUS INCA CARDENAS', 'INSERTAR', 'SE REGISTRO PERFIL', 'Perfil', '2018-10-08 01:02:02'),
(182, 'JESUS INCA CARDENAS', 'INSERTAR', 'SE REGISTRO PERMISOS DE PERFIL', 'Permisos', '2018-10-08 01:02:02'),
(183, 'admin', 'SE ACTUALIZO PERMISOS', 'PERMISOS', 'SE ACTUALIZO PERMISOS DE PERFIL:ENCARGADO', '2018-10-08 01:02:19'),
(184, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:ADMINISTRADOR GENERAL DEL SISTEMA', '2018-10-08 01:09:25'),
(185, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Persona', 'SE REGISTRO PERSONA:Jesus Inca Cardenas', '2018-10-08 01:22:56'),
(186, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:jinca', '2018-10-08 01:23:23'),
(187, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:jinca', '2018-10-08 01:24:11'),
(188, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:jinca', '2018-10-08 01:25:04'),
(189, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TIPO DE TARJETA DE PAGO', 'TipoTarjeta', '2018-10-08 02:07:43'),
(190, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TIPO DE TARJETA DE PAGO', 'TipoTarjeta', '2018-10-08 02:09:08'),
(191, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TIPO DE TARJETA DE PAGO', 'TipoTarjeta', '2018-10-08 02:12:44'),
(192, 'admin', 'TIPO DE TARJETA DESHABILITADO', 'PERFIL', 'TIPO DE TARJETA DESHABILITADO :TARJETA PRUEBA3', '2018-10-08 02:14:07'),
(193, 'admin', 'TIPO DE TARJETA HABILITADO', 'PERFIL', 'TIPO DE TARJETA HABILITADO :TARJETA PRUEBA3', '2018-10-08 02:14:09'),
(194, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TIPO DE TARJETA DE PAGO', 'TipoTarjeta', '2018-10-08 02:14:19'),
(195, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TIPO DE TARJETA DE PAGO', 'TipoTarjeta', '2018-10-08 02:14:26'),
(196, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TIPO DE TARJETA DE PAGO', 'TipoTarjeta', '2018-10-08 02:15:38'),
(197, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TIPO DE TARJETA DE PAGO', 'TipoTarjeta', '2018-10-08 02:17:28'),
(198, 'admin', 'ACTUALIZACION', 'TipoTarjeta', 'SE ACTUALIZO TIPO TARJETA:TIPO PRUEBA2', '2018-10-08 02:25:35'),
(199, 'admin', 'ACTUALIZACION', 'TipoTarjeta', 'SE ACTUALIZO TIPO TARJETA:TIPO PRUEBA', '2018-10-08 02:25:42'),
(200, 'admin', 'TIPO DE TARJETA DESHABILITADO', 'PERFIL', 'TIPO DE TARJETA DESHABILITADO :TIPO PRUEBA', '2018-10-08 02:25:47'),
(201, 'admin', 'TIPO DE TARJETA HABILITADO', 'PERFIL', 'TIPO DE TARJETA HABILITADO :TIPO PRUEBA', '2018-10-08 02:25:49'),
(202, 'admin', 'NIVEL DESHABILITADO', 'NIVEL', 'NIVEL DESHABILITADO :SECUNDARIA', '2018-10-08 03:01:02'),
(203, 'admin', 'NIVEL HABILITADO', 'NIVEL', 'NIVEL HABILITADO :SECUNDARIA', '2018-10-08 03:01:05'),
(204, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO NIVEL', 'NIVEL', '2018-10-08 03:01:19'),
(205, 'admin', 'ACTUALIZACION', 'Nivel', 'SE ACTUALIZO NIVEL:NOCTURNO2', '2018-10-08 03:01:28'),
(206, 'admin', 'ACTUALIZACION', 'Nivel', 'SE ACTUALIZO NIVEL:NOCTURNO3', '2018-10-08 03:02:19'),
(207, 'admin', 'ACTUALIZACION', 'Nivel', 'SE ACTUALIZO NIVEL:NOCTURNO3', '2018-10-08 03:02:31'),
(208, 'admin', 'NIVEL DESHABILITADO', 'NIVEL', 'NIVEL DESHABILITADO :SECUNDARIA', '2018-10-08 03:06:25'),
(209, 'admin', 'NIVEL HABILITADO', 'NIVEL', 'NIVEL HABILITADO :SECUNDARIA', '2018-10-08 03:06:27'),
(210, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO NIVEL', 'NIVEL', '2018-10-08 03:06:36'),
(211, 'admin', 'ACTUALIZACION', 'Nivel', 'SE ACTUALIZO NIVEL:aaaaa', '2018-10-08 03:06:50'),
(212, 'admin', 'ACTUALIZACION', 'Nivel', 'SE ACTUALIZO NIVEL:SECUNDARIA2', '2018-10-08 03:08:30'),
(213, 'admin', 'ACTUALIZACION', 'Nivel', 'SE ACTUALIZO NIVEL:SECUNDARIA2', '2018-10-08 03:09:27'),
(214, 'admin', 'ACTUALIZACION', 'Nivel', 'SE ACTUALIZO NIVEL:SECUNDARIA2', '2018-10-08 03:09:40'),
(215, 'admin', 'ACTUALIZACION', 'Nivel', 'SE ACTUALIZO NIVEL:SECUNDARIA2', '2018-10-08 03:10:46'),
(216, 'admin', 'ACTUALIZACION', 'Nivel', 'SE ACTUALIZO NIVEL:PRIMARIA', '2018-10-08 03:10:55'),
(217, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO NIVEL', 'NIVEL', '2018-10-08 03:11:07'),
(218, 'admin', 'ACTUALIZACION', 'Nivel', 'SE ACTUALIZO NIVEL:SECUNDARIA', '2018-10-08 03:11:14'),
(219, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO NIVEL', 'NIVEL', '2018-10-08 03:11:32'),
(220, 'admin', 'GRADO DESHABILITADO', 'GRADO', 'GRADO DESHABILITADO :A', '2018-10-08 03:24:37'),
(221, 'admin', 'GRADO HABILITADO', 'GRADO', 'GRADO HABILITADO :A', '2018-10-08 03:24:44'),
(222, 'admin', 'GRADO DESHABILITADO', 'GRADO', 'GRADO DESHABILITADO :A', '2018-10-08 03:24:48'),
(223, 'admin', 'GRADO HABILITADO', 'GRADO', 'GRADO HABILITADO :A', '2018-10-08 03:24:51'),
(224, 'admin', 'GRADO DESHABILITADO', 'GRADO', 'GRADO DESHABILITADO :K', '2018-10-08 03:24:53'),
(225, 'admin', 'GRADO HABILITADO', 'GRADO', 'GRADO HABILITADO :K', '2018-10-08 03:24:56'),
(226, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO GRADO', 'GRADO', '2018-10-08 03:25:09'),
(227, 'admin', 'ACTUALIZACION', 'GRADO', 'SE ACTUALIZO GRADO:NUEVO GRADO2', '2018-10-08 03:25:19'),
(228, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SECCION', 'SECCION', '2018-10-08 03:40:08'),
(229, 'admin', 'SECCION DESHABILITADO', 'SECCION', 'SECCION DESHABILITADO :A', '2018-10-08 03:40:11'),
(230, 'admin', 'SECCION HABILITADO', 'SECCION', 'SECCION HABILITADO :A', '2018-10-08 03:40:18'),
(231, 'admin', 'ACTUALIZACION', 'SECCION', 'SE ACTUALIZO SECCION:AA', '2018-10-08 03:40:23'),
(232, 'admin', 'ACTUALIZACION', 'SECCION', 'SE ACTUALIZO SECCION:A', '2018-10-08 03:40:31'),
(233, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SECCION', 'SECCION', '2018-10-08 03:40:39'),
(234, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SECCION', 'SECCION', '2018-10-08 03:40:45'),
(235, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SECCION', 'SECCION', '2018-10-08 03:40:51'),
(236, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SECCION', 'SECCION', '2018-10-08 03:40:58'),
(237, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SECCION', 'SECCION', '2018-10-08 03:41:04'),
(238, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SECCION', 'SECCION', '2018-10-08 03:41:10'),
(239, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SECCION', 'SECCION', '2018-10-08 03:41:17'),
(240, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO GRADO', 'GRADO', '2018-10-08 03:42:13'),
(241, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO GRADO', 'GRADO', '2018-10-08 03:42:24'),
(242, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO GRADO', 'GRADO', '2018-10-08 03:42:34'),
(243, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO GRADO', 'GRADO', '2018-10-08 03:42:45'),
(244, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO GRADO', 'GRADO', '2018-10-08 03:42:57'),
(245, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO GRADO', 'GRADO', '2018-10-08 03:43:10'),
(246, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO GRADO', 'GRADO', '2018-10-08 03:45:21'),
(247, 'admin', 'SECCION DESHABILITADO', 'SECCION', 'SECCION DESHABILITADO :C', '2018-10-08 05:25:02'),
(248, 'admin', 'SECCION HABILITADO', 'SECCION', 'SECCION HABILITADO :C', '2018-10-08 05:25:04'),
(249, 'admin', 'SECCION HABILITADO', 'SECCION', 'SECCION HABILITADO :C', '2018-10-08 05:25:05'),
(250, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SECCION', 'SECCION', '2018-10-08 05:25:34'),
(251, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SECCION', 'SECCION', '2018-10-08 05:25:40'),
(252, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SECCION', 'SECCION', '2018-10-08 05:25:45'),
(253, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SECCION', 'SECCION', '2018-10-08 05:25:50'),
(254, 'admin', 'ACTUALIZACION', 'SECCION', 'SE ACTUALIZO SECCION:C', '2018-10-08 05:26:01'),
(255, 'admin', 'ACTUALIZACION', 'SECCION', 'SE ACTUALIZO SECCION:D', '2018-10-08 05:26:07'),
(256, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SECCION', 'SECCION', '2018-10-08 05:26:14'),
(257, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SECCION', 'SECCION', '2018-10-08 05:26:23'),
(258, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SECCION', 'SECCION', '2018-10-08 05:26:30'),
(259, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Persona', 'SE REGISTRO PERSONA:vwefv wevwe vwev', '2018-10-08 12:34:12'),
(260, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Alumno', 'SE REGISTRO PERSONA:vwefv wevwe vwev COMO ALUMNO NUEVO', '2018-10-08 12:34:12'),
(261, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Persona', 'SE REGISTRO PERSONA:ewfwe wef wefwe', '2018-10-08 12:34:59'),
(262, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Alumno', 'SE REGISTRO PERSONA:ewfwe wef wefwe COMO ALUMNO NUEVO', '2018-10-08 12:34:59'),
(263, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Persona', 'SE REGISTRO PERSONA:jesusin incae carfew', '2018-10-08 12:56:02'),
(264, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Alumno', 'SE REGISTRO PERSONA:jesusin incae carfew COMO ALUMNO NUEVO', '2018-10-08 12:56:02'),
(265, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:EWFWE WEF WEFWE', '2018-10-08 18:28:32'),
(266, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JESUSINDD INCAEDD CARFEWDD', '2018-10-08 18:28:56'),
(267, 'admin', 'PERSONA DESHBILITADO', 'USUARIO', 'SEPERSONA DESHBILITADO :EWFWE WEF WEFWE', '2018-10-08 18:49:37'),
(268, 'admin', 'PERSONA HABILITADO', 'USUARIO', 'SEPERSONA HABILITADO :EWFWE WEF WEFWE', '2018-10-08 18:49:40'),
(269, 'admin', 'PERSONA DESHBILITADO', 'USUARIO', 'SEPERSONA DESHBILITADO :JESUSINDD INCAEDD CARFEWDD', '2018-10-08 18:49:45'),
(270, 'admin', 'PERSONA HABILITADO', 'USUARIO', 'SEPERSONA HABILITADO :JESUSINDD INCAEDD CARFEWDD', '2018-10-08 18:49:47'),
(271, 'admin', 'PERSONA DESHBILITADO', 'USUARIO', 'SEPERSONA DESHBILITADO :EWFWE WEF WEFWE', '2018-10-08 18:49:49'),
(272, 'admin', 'PERSONA HABILITADO', 'USUARIO', 'SEPERSONA HABILITADO :EWFWE WEF WEFWE', '2018-10-08 18:49:51'),
(273, 'admin', 'TIPO DE TARJETA DESHABILITADO', 'PERFIL', 'TIPO DE TARJETA DESHABILITADO :TARJETA DINNER CLUB', '2018-10-08 22:12:39'),
(274, 'admin', 'TIPO DE TARJETA HABILITADO', 'PERFIL', 'TIPO DE TARJETA HABILITADO :TARJETA DINNER CLUB', '2018-10-08 22:13:00'),
(275, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Persona', 'SE REGISTRO APODERADO:eeee eeeeee eeee', '2018-10-08 22:50:40'),
(276, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:ADMINISTRADOR GENERAL DEL SISTEMA', '2018-10-08 22:58:54'),
(277, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:ADMINISTRADOR GENERAL DEL SISTEMA', '2018-10-08 22:59:03'),
(278, 'admin', 'PERSONA DESHBILITADO', 'USUARIO', 'SEPERSONA DESHBILITADO :EEEE EEEEEE EEEE', '2018-10-08 23:03:35'),
(279, 'admin', 'PERSONA HABILITADO', 'USUARIO', 'SEPERSONA HABILITADO :EEEE EEEEEE EEEE', '2018-10-08 23:03:37'),
(280, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Apoderado', 'SE ACTUALIZO Apoderado:EEEE EEEEEE EEEE', '2018-10-08 23:06:12'),
(281, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Apoderado', 'SE ACTUALIZO Apoderado:EEEEd EEEEEEd EEEEd', '2018-10-08 23:06:22'),
(282, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Alumno', 'SE REGISTRO PERSONA:alumno prueba prueba COMO ALUMNO NUEVO', '2018-10-09 02:36:09'),
(283, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Alumno', 'SE REGISTRO PERSONA:sergio inca cardenas COMO ALUMNO NUEVO', '2018-10-10 20:09:41'),
(284, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Persona', 'SE REGISTRO APODERADO:papa apellido p apellid m', '2018-10-10 20:26:35'),
(285, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ELIMINAR', 'Relacion', 'SE QUITO RELACION', '2018-10-10 23:37:42'),
(286, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ELIMINAR', 'Relacion', 'SE QUITO RELACION', '2018-10-10 23:41:10'),
(287, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Alumno', 'SE REGISTRO PERSONA:alumnoPrueba qfqw qwfqwf COMO ALUMNO NUEVO', '2018-10-10 23:48:02'),
(288, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Relacion', 'SE AGREGO ALUMNO:6 A APODERADO:1', '2018-10-10 23:53:58'),
(289, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ELIMINAR', 'Relacion', 'SE QUITO RELACION', '2018-10-10 23:54:17'),
(290, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ELIMINAR', 'Relacion', 'SE QUITO RELACION', '2018-10-10 23:54:22'),
(291, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ELIMINAR', 'Relacion', 'SE QUITO RELACION', '2018-10-10 23:58:17'),
(292, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ELIMINAR', 'Relacion', 'SE QUITO RELACION', '2018-10-10 23:58:19'),
(293, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ELIMINAR', 'Relacion', 'SE QUITO RELACION', '2018-10-10 23:58:22'),
(294, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:5', '2018-10-11 00:46:06'),
(295, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:5', '2018-10-11 00:54:21'),
(296, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:5', '2018-10-11 00:54:51'),
(297, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:5', '2018-10-11 00:56:56'),
(298, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:5', '2018-10-11 21:10:34'),
(299, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:5', '2018-10-11 21:10:37'),
(300, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:5', '2018-10-11 21:10:45'),
(301, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:5', '2018-10-11 21:11:09'),
(302, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:4', '2018-10-11 21:31:48'),
(303, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:4', '2018-10-11 21:31:53'),
(304, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:5', '2018-10-11 21:32:04'),
(305, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:4', '2018-10-11 21:36:03'),
(306, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:5', '2018-10-11 21:36:13'),
(307, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:5', '2018-10-11 21:36:39'),
(308, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:5', '2018-10-11 21:39:11'),
(309, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:4', '2018-10-11 23:29:05'),
(310, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:4', '2018-10-12 23:00:24'),
(311, 'admin', 'CUOTA ANULADA', 'CUOTA', 'COUTA ANULADA :18', '2018-10-12 23:00:27'),
(312, 'admin', 'CUOTA ANULADA', 'CUOTA', 'COUTA ANULADA :18', '2018-10-12 23:07:12'),
(313, 'admin', 'CUOTA ANULADA', 'CUOTA', 'COUTA ANULADA :18', '2018-10-12 23:07:14'),
(314, 'admin', 'CUOTA ANULADA', 'CUOTA', 'COUTA ANULADA :18', '2018-10-12 23:07:17'),
(315, 'admin', 'CUOTA ANULADA', 'CUOTA', 'COUTA ANULADA :18', '2018-10-12 23:07:21'),
(316, 'admin', 'CUOTA ANULADA', 'CUOTA', 'COUTA ANULADA :18', '2018-10-12 23:07:27'),
(317, 'admin', 'CUOTA ANULADA', 'CUOTA', 'COUTA ANULADA :18', '2018-10-12 23:07:31'),
(318, 'admin', 'CUOTA ANULADA', 'CUOTA', 'COUTA ANULADA :18', '2018-10-12 23:11:03'),
(319, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:5', '2018-10-13 11:48:36'),
(320, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:5', '2018-10-13 11:48:45'),
(321, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:5', '2018-10-13 11:49:15'),
(322, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:5', '2018-10-13 11:49:18'),
(323, 'admin', 'CUOTA ANULADA', 'CUOTA', 'COUTA ANULADA :22', '2018-10-13 11:49:32'),
(324, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:5', '2018-10-13 11:49:45'),
(325, 'admin', 'CUOTA ANULADA', 'CUOTA', 'COUTA ANULADA :22', '2018-10-13 11:49:48'),
(326, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JOSE RODRIGUEZ ROMERO', '2018-10-13 11:58:15'),
(327, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:ESTEFANY INCA CARDENAS', '2018-10-13 11:58:44'),
(328, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Alumno', 'SE REGISTRO PERSONA:JULIO BENITEZ ROMAN COMO ALUMNO NUEVO', '2018-10-13 11:59:19'),
(329, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:6', '2018-10-13 12:00:03'),
(330, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:6', '2018-10-13 12:00:06'),
(331, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:6', '2018-10-13 12:00:08'),
(332, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:6', '2018-10-13 12:00:10'),
(333, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:6', '2018-10-13 12:00:13'),
(334, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:6', '2018-10-13 12:00:18'),
(335, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:6', '2018-10-13 12:00:21'),
(336, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:6', '2018-10-13 12:00:25'),
(337, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:6', '2018-10-13 12:00:27'),
(338, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:6', '2018-10-13 12:00:29'),
(339, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:7', '2018-10-13 12:02:59'),
(340, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:7', '2018-10-13 12:03:01'),
(341, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:7', '2018-10-13 12:03:03'),
(342, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:7', '2018-10-13 12:03:07'),
(343, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Apoderado', 'SE ACTUALIZO Apoderado:JULIO DOMINGO GUZMAN', '2018-10-13 12:08:03'),
(344, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Persona', 'SE REGISTRO APODERADO:VERONICA PADILLA CARRILLO', '2018-10-13 12:09:06'),
(345, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Relacion', 'SE AGREGO ALUMNO:7 A APODERADO:2', '2018-10-13 12:09:14'),
(346, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ELIMINAR', 'Relacion', 'SE QUITO RELACION', '2018-10-13 12:09:20'),
(347, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Relacion', 'SE AGREGO ALUMNO:7 A APODERADO:2', '2018-10-13 12:09:25'),
(348, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ELIMINAR', 'Relacion', 'SE QUITO RELACION', '2018-10-13 12:09:28'),
(349, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ELIMINAR', 'Relacion', 'SE QUITO RELACION', '2018-10-13 12:09:39'),
(350, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Alumno', 'SE REGISTRO PERSONA:JOAQUIN PRIALE DOMINGUEZ COMO ALUMNO NUEVO', '2018-10-13 12:21:38'),
(351, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JOSE RODRIGUEZ ROMERO', '2018-10-13 13:33:10'),
(352, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:4', '2018-10-13 13:33:21'),
(353, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:1', '2018-10-13 16:59:10'),
(354, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:1', '2018-10-13 17:01:23'),
(355, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:1', '2018-10-13 17:02:00'),
(356, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:2', '2018-10-13 17:03:09'),
(357, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:2', '2018-10-13 17:06:31'),
(358, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:2', '2018-10-13 17:10:28'),
(359, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:3', '2018-10-13 17:10:58'),
(360, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:3', '2018-10-13 17:24:18'),
(361, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:4', '2018-10-13 17:30:22'),
(362, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:4', '2018-10-13 17:32:46'),
(363, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:4', '2018-10-13 17:33:45'),
(364, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:3', '2018-10-13 17:34:08'),
(365, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:3', '2018-10-13 17:36:34'),
(366, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:3', '2018-10-13 17:38:47'),
(367, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:2', '2018-10-13 17:40:39'),
(368, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:2', '2018-10-13 17:40:49'),
(369, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:2', '2018-10-13 17:40:49'),
(370, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:2', '2018-10-13 17:40:56'),
(371, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:2', '2018-10-13 17:40:56'),
(372, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:2', '2018-10-13 17:40:56'),
(373, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:3', '2018-10-13 17:44:18'),
(374, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:2', '2018-10-13 21:00:29'),
(375, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:2', '2018-10-13 21:01:26'),
(376, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:2', '2018-10-13 21:01:26'),
(377, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:2', '2018-10-13 21:01:26'),
(378, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:2', '2018-10-13 21:01:26'),
(379, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:2', '2018-10-13 22:16:40'),
(380, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:2', '2018-10-13 22:18:52'),
(381, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO CLIENTE', 'CLIENTE', '2018-10-15 04:16:21'),
(382, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO CLIENTE', 'CLIENTE', '2018-10-15 04:16:55'),
(383, 'admin', 'ACTUALIZACION', 'CLIENTE', 'SE ACTUALIZO cliente:SAMSUNG SAC', '2018-10-15 04:20:37'),
(384, 'admin', 'ACTUALIZACION', 'CLIENTE', 'SE ACTUALIZO cliente:LG SAC', '2018-10-15 04:20:46'),
(385, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO CLIENTE', 'CLIENTE', '2018-10-15 04:20:55'),
(386, 'admin', 'CLIENTE DESHABILITADO', 'CLIENTE', 'CLIENTE DESHABILITADO :efwfwef', '2018-10-15 04:21:04'),
(387, 'admin', 'CLIENTE HABILITADO', 'CLIENTE', 'CLIENTE HABILITADO :efwfwef', '2018-10-15 04:21:07'),
(388, 'admin', 'CLIENTE DESHABILITADO', 'CLIENTE', 'CLIENTE DESHABILITADO :efwfwef', '2018-10-15 04:21:09'),
(389, 'admin', 'ACTUALIZACION', 'Perfil', 'SE ACTUALIZO PERFIL:EMPLEADO', '2018-10-15 04:37:02'),
(390, 'admin', 'ACTUALIZACION', 'Perfil', 'SE ACTUALIZO PERFIL:JEFE PROYECTO', '2018-10-15 04:37:33'),
(391, 'admin', 'ACTUALIZACION', 'Perfil', 'SE ACTUALIZO PERFIL:ENCARGADO', '2018-10-15 04:37:51'),
(392, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO PROYECTO', 'PROYECTO', '2018-10-15 04:50:00'),
(393, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO PROYECTO', 'PROYECTO', '2018-10-15 04:50:27'),
(394, 'admin', 'PROYECTO DESHABILITADO', 'PROYECTO', 'PROYECTO DESHABILITADO :WFEFWEF', '2018-10-15 04:55:39'),
(395, 'admin', 'PROYECTO HABILITADO', 'PROYECTO', 'PROYECTO HABILITADO :WFEFWEF', '2018-10-15 04:55:43'),
(396, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO PROYECTO', 'PROYECTO', '2018-10-15 04:56:44'),
(397, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-15 12:32:33'),
(398, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-15 12:35:07'),
(399, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-15 12:35:41'),
(400, 'admin', 'TAREA DESHABILITADO', 'TAREA', 'TAREA DESHABILITADO :TAREA 1', '2018-10-15 12:36:13'),
(401, 'admin', 'TAREA HABILITADO', 'TAREA', 'TAREA HABILITADO :TAREA 1', '2018-10-15 12:36:16'),
(402, 'admin', 'TAREA DESHABILITADO', 'TAREA', 'TAREA DESHABILITADO :TAREA 3', '2018-10-15 12:36:18'),
(403, 'admin', 'TAREA HABILITADO', 'TAREA', 'TAREA HABILITADO :TAREA 3', '2018-10-15 12:36:21'),
(404, 'admin', 'ACTUALIZACION', 'TAREA', 'SE ACTUALIZO TAREA:TAREA 1', '2018-10-15 12:38:33'),
(405, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SUBTAREA', 'SUBTAREA', '2018-10-15 14:54:16'),
(406, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SUBTAREA', 'SUBTAREA', '2018-10-15 14:54:27'),
(407, 'admin', 'SUBTAREA DESHABILITADO', 'SUBTAREA', 'SUBTAREA DESHABILITADO :fwfwefwe', '2018-10-15 15:12:05'),
(408, 'admin', 'SUBTAREA HABILITADO', 'SUBTAREA', 'SUBTAREA HABILITADO :fwfwefwe', '2018-10-15 15:12:07'),
(409, 'admin', 'ACTUALIZACION', 'SUBTAREA', 'SE ACTUALIZO SUBTAREA:SUBTAREA 1', '2018-10-15 15:15:04'),
(410, 'admin', 'ACTUALIZACION', 'SUBTAREA', 'SE ACTUALIZO SUBTAREA:SUBTAREA2', '2018-10-15 15:15:47'),
(411, 'admin', 'ACTUALIZACION', 'SUBTAREA', 'SE ACTUALIZO SUBTAREA:SUBTAREA 3', '2018-10-15 15:15:58'),
(412, 'admin', 'ACTUALIZACION', 'SUBTAREA', 'SE ACTUALIZO SUBTAREA:SUBTAREA 2', '2018-10-15 15:16:06'),
(413, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SUBTAREA', 'SUBTAREA', '2018-10-15 15:16:22'),
(414, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SUBTAREA', 'SUBTAREA', '2018-10-15 15:16:40'),
(415, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SUBTAREA', 'SUBTAREA', '2018-10-15 15:18:10'),
(416, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SUBTAREA', 'SUBTAREA', '2018-10-15 15:21:42'),
(417, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SUBTAREA', 'SUBTAREA', '2018-10-15 15:23:54'),
(418, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SUBTAREA', 'SUBTAREA', '2018-10-15 15:24:01'),
(419, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:jrodriguez', '2018-10-15 15:25:13'),
(420, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:sinca', '2018-10-15 15:25:31'),
(421, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-15 15:31:48'),
(422, 'admin', 'ACTUALIZACION', 'PROEYCTO', 'SE ACTUALIZO PROYECTO:PROYECTO 2', '2018-10-15 16:20:36'),
(423, 'admin', 'ACTUALIZACION', 'PROEYCTO', 'SE ACTUALIZO PROYECTO:PROYECTO 3', '2018-10-15 16:20:49'),
(424, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:jdomingo', '2018-10-15 16:53:08'),
(425, 'JULIO DOMINGO GUZMAN', 'INSERTAR', 'SE REGISTRO SUBTAREA', 'SUBTAREA', '2018-10-15 17:09:44'),
(426, 'JULIO DOMINGO GUZMAN', 'INSERTAR', 'SE REGISTRO SUBTAREA', 'SUBTAREA', '2018-10-15 17:09:54'),
(427, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Persona', 'SE REGISTRO PERSONA:Bryan Cordoba Robladillo', '2018-10-15 19:50:14'),
(428, 'admin', 'PERFIL DESHABILITADO', 'PERFIL', 'SEPERFIL DESHABILITADO :ENCARGADO', '2018-10-15 19:52:25'),
(429, 'admin', 'PERFIL HABILITADO', 'PERFIL', 'SEPERFIL HABILITADO :ENCARGADO', '2018-10-15 19:52:32'),
(430, 'admin', 'PERFIL DESHABILITADO', 'PERFIL', 'SEPERFIL DESHABILITADO :ENCARGADO', '2018-10-15 19:52:43'),
(431, 'admin', 'PERFIL HABILITADO', 'PERFIL', 'SEPERFIL HABILITADO :ENCARGADO', '2018-10-15 19:52:52'),
(432, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO CLIENTE', 'CLIENTE', '2018-10-15 19:53:34'),
(433, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO PROYECTO', 'PROYECTO', '2018-10-15 19:54:38'),
(434, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:bcordova', '2018-10-15 19:56:32'),
(435, 'admin', 'SE ACTUALIZO PERMISOS', 'PERMISOS', 'SE ACTUALIZO PERMISOS DE PERFIL:ENCARGADO', '2018-10-15 19:56:56'),
(436, 'BRYAN CORDOBA ROBLADILLO', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:jdominguez', '2018-10-15 19:58:52'),
(437, 'BRYAN CORDOBA ROBLADILLO', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-15 20:02:34'),
(438, 'BRYAN CORDOBA ROBLADILLO', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-15 20:03:29'),
(439, 'JOAQUIN PRIALE DOMINGUEZ', 'INSERTAR', 'SE REGISTRO SUBTAREA', 'SUBTAREA', '2018-10-15 20:11:50'),
(440, 'JOAQUIN PRIALE DOMINGUEZ', 'INSERTAR', 'SE REGISTRO SUBTAREA', 'SUBTAREA', '2018-10-15 20:12:10'),
(441, 'JOAQUIN PRIALE DOMINGUEZ', 'INSERTAR', 'SE REGISTRO SUBTAREA', 'SUBTAREA', '2018-10-15 20:13:30'),
(442, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO PERFIL', 'Perfil', '2018-10-20 13:44:13'),
(443, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO PERMISOS DE PERFIL', 'Permisos', '2018-10-20 13:44:13'),
(444, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO PERFIL', 'Perfil', '2018-10-20 13:46:08'),
(445, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO PERMISOS DE PERFIL', 'Permisos', '2018-10-20 13:46:08'),
(446, 'admin', 'ACTUALIZACION', 'Perfil', 'SE ACTUALIZO PERFIL:ADMINISTRADOR', '2018-10-20 13:46:29'),
(447, 'admin', 'SE ACTUALIZO PERMISOS', 'PERMISOS', 'SE ACTUALIZO PERMISOS DE PERFIL:JEFE DE PROYECTO', '2018-10-20 13:46:42'),
(448, 'admin', 'SE ACTUALIZO PERMISOS', 'PERMISOS', 'SE ACTUALIZO PERMISOS DE PERFIL:JEFE DE PROYECTO', '2018-10-20 13:46:49'),
(449, 'admin', 'SE ACTUALIZO PERMISOS', 'PERMISOS', 'SE ACTUALIZO PERMISOS DE PERFIL:EMPLEADO', '2018-10-20 13:47:00'),
(450, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:agarciaa', '2018-10-20 14:12:00'),
(451, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:jgonzalezc', '2018-10-20 14:12:19'),
(452, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:mrodriguezc', '2018-10-20 14:12:44'),
(453, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:ffernandezr', '2018-10-20 14:13:08');
INSERT INTO `bitacora` (`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`, `Detalle`, `fechaRegistro`) VALUES
(454, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:dlopezp', '2018-10-20 14:13:30'),
(455, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:jmartinezd', '2018-10-20 14:13:52'),
(456, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:jsanchezs', '2018-10-20 14:14:16'),
(457, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:jperezv', '2018-10-20 14:14:48'),
(458, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:jgomezm', '2018-10-20 14:15:11'),
(459, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:dmartins', '2018-10-20 14:15:22'),
(460, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:fjimenezp', '2018-10-20 14:15:37'),
(461, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:jruize', '2018-10-20 14:15:50'),
(462, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:chernandezb', '2018-10-20 14:16:05'),
(463, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:adiazg', '2018-10-20 14:16:18'),
(464, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:mmorenor', '2018-10-20 14:16:31'),
(465, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:jmunozh', '2018-10-20 14:16:48'),
(466, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:ralvarezm', '2018-10-20 14:17:03'),
(467, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:promerol', '2018-10-20 14:17:14'),
(468, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:malonso', '2018-10-20 14:17:41'),
(469, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:agutierrezg', '2018-10-20 14:18:04'),
(470, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:pnavarroi', '2018-10-20 14:18:17'),
(471, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:jtorresf', '2018-10-20 14:19:21'),
(472, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:fdominguezd', '2018-10-20 14:19:37'),
(473, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:svazquezs', '2018-10-20 14:19:56'),
(474, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:lramosb', '2018-10-20 14:20:12'),
(475, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:jgilv', '2018-10-20 14:20:37'),
(476, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:aramirezm', '2018-10-20 14:20:49'),
(477, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:jserranov', '2018-10-20 14:21:04'),
(478, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:ablancov', '2018-10-20 14:21:22'),
(479, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:jmolinap', '2018-10-20 14:21:42'),
(480, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:dmoralesf', '2018-10-20 14:21:54'),
(481, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:asuarezc', '2018-10-20 14:22:06'),
(482, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:rortegac', '2018-10-20 14:22:21'),
(483, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:jdelgadov', '2018-10-20 14:22:41'),
(484, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:icastrof', '2018-10-20 14:22:54'),
(485, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:eortizc', '2018-10-20 14:23:43'),
(486, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:rrubiod', '2018-10-20 14:24:02'),
(487, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO CLIENTE', 'CLIENTE', '2018-10-20 15:14:50'),
(488, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO CLIENTE', 'CLIENTE', '2018-10-20 15:15:11'),
(489, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO CLIENTE', 'CLIENTE', '2018-10-20 15:15:38'),
(490, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO CLIENTE', 'CLIENTE', '2018-10-20 15:15:52'),
(491, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO CLIENTE', 'CLIENTE', '2018-10-20 15:16:22'),
(492, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO PROYECTO', 'PROYECTO', '2018-10-20 15:19:38'),
(493, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO PROYECTO', 'PROYECTO', '2018-10-20 15:22:58'),
(494, 'admin', 'ACTUALIZACION', 'PROEYCTO', 'SE ACTUALIZO PROYECTO:Sistema WEB para el Proceso de Producción', '2018-10-20 15:23:12'),
(495, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO PROYECTO', 'PROYECTO', '2018-10-20 15:23:55'),
(496, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO PROYECTO', 'PROYECTO', '2018-10-20 15:24:57'),
(497, 'admin', 'ACTUALIZACION', 'PROEYCTO', 'SE ACTUALIZO PROYECTO:Sistema WEB para el Proceso de Producción', '2018-10-20 15:38:02'),
(498, 'admin', 'ACTUALIZACION', 'PROEYCTO', 'SE ACTUALIZO PROYECTO:Sistema WEB para el Proceso Contable', '2018-10-20 15:38:13'),
(499, 'admin', 'ACTUALIZACION', 'PROEYCTO', 'SE ACTUALIZO PROYECTO:Sistema WEB para el Proceso de venta', '2018-10-20 15:38:20'),
(500, 'admin', 'ACTUALIZACION', 'PROEYCTO', 'SE ACTUALIZO PROYECTO:Sistema MOVIL ANDROID para el Proceso de Registros Academicos', '2018-10-20 15:38:27'),
(501, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO PROYECTO', 'PROYECTO', '2018-10-20 15:39:01'),
(502, 'admin', 'PROYECTO DESHABILITADO', 'PROYECTO', 'PROYECTO DESHABILITADO :Sistema WEB Administrativo SIEN', '2018-10-20 15:47:46'),
(503, 'admin', 'PROYECTO HABILITADO', 'PROYECTO', 'PROYECTO HABILITADO :Sistema WEB Administrativo SIEN', '2018-10-20 15:47:49'),
(504, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO ACTIVIDAD', 'ACTIVIDAD', '2018-10-20 17:08:32'),
(505, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO ACTIVIDAD', 'ACTIVIDAD', '2018-10-20 17:09:56'),
(506, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO ACTIVIDAD', 'ACTIVIDAD', '2018-10-20 17:10:54'),
(507, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO ACTIVIDAD', 'ACTIVIDAD', '2018-10-20 17:11:05'),
(508, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO ACTIVIDAD', 'ACTIVIDAD', '2018-10-20 17:17:21'),
(509, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO ACTIVIDAD', 'ACTIVIDAD', '2018-10-20 17:17:55'),
(510, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO ACTIVIDAD', 'ACTIVIDAD', '2018-10-20 17:18:32'),
(511, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO ACTIVIDAD', 'ACTIVIDAD', '2018-10-20 17:18:54'),
(512, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO ACTIVIDAD', 'ACTIVIDAD', '2018-10-20 17:19:12'),
(513, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO ACTIVIDAD', 'ACTIVIDAD', '2018-10-20 17:20:37'),
(514, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO ACTIVIDAD', 'ACTIVIDAD', '2018-10-20 17:21:03'),
(515, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO ACTIVIDAD', 'ACTIVIDAD', '2018-10-20 17:21:33'),
(516, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO ACTIVIDAD', 'ACTIVIDAD', '2018-10-20 17:21:57'),
(517, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO ACTIVIDAD', 'ACTIVIDAD', '2018-10-20 17:22:19'),
(518, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO ACTIVIDAD', 'ACTIVIDAD', '2018-10-20 17:22:55'),
(519, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO ACTIVIDAD', 'ACTIVIDAD', '2018-10-20 17:23:17'),
(520, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO ACTIVIDAD', 'ACTIVIDAD', '2018-10-20 17:23:43'),
(521, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO ACTIVIDAD', 'ACTIVIDAD', '2018-10-20 17:24:12'),
(522, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO ACTIVIDAD', 'ACTIVIDAD', '2018-10-20 17:24:28'),
(523, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO ACTIVIDAD', 'ACTIVIDAD', '2018-10-20 17:24:59'),
(524, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO ACTIVIDAD', 'ACTIVIDAD', '2018-10-20 17:25:19'),
(525, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO ACTIVIDAD', 'ACTIVIDAD', '2018-10-20 17:25:41'),
(526, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO ACTIVIDAD', 'ACTIVIDAD', '2018-10-20 17:26:03'),
(527, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO ACTIVIDAD', 'ACTIVIDAD', '2018-10-20 17:26:21'),
(528, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO ACTIVIDAD', 'ACTIVIDAD', '2018-10-20 17:26:51'),
(529, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO ACTIVIDAD', 'ACTIVIDAD', '2018-10-20 17:27:14'),
(530, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO ACTIVIDAD', 'ACTIVIDAD', '2018-10-20 17:27:41'),
(531, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO ACTIVIDAD', 'ACTIVIDAD', '2018-10-20 17:27:59'),
(532, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO ACTIVIDAD', 'ACTIVIDAD', '2018-10-20 17:28:15'),
(533, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SUBTAREA', 'SUBTAREA', '2018-10-21 19:58:23'),
(534, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 20:38:15'),
(535, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 20:44:37'),
(536, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 20:45:20'),
(537, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 20:49:36'),
(538, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 20:49:59'),
(539, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 20:51:26'),
(540, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 20:52:30'),
(541, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 21:06:53'),
(542, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 21:07:09'),
(543, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 21:27:13'),
(544, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 21:40:15'),
(545, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 21:40:38'),
(546, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 21:40:53'),
(547, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 21:41:49'),
(548, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 21:46:58'),
(549, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 21:47:34'),
(550, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 21:48:00'),
(551, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 22:17:12'),
(552, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 22:17:27'),
(553, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 22:18:25'),
(554, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 22:19:01'),
(555, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 22:19:47'),
(556, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 22:20:18'),
(557, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 22:20:32'),
(558, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 22:22:32'),
(559, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 22:22:51'),
(560, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 22:23:22'),
(561, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 22:23:37'),
(562, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 22:25:57'),
(563, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 22:26:21'),
(564, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 22:26:41'),
(565, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 22:26:56'),
(566, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 22:27:51'),
(567, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 22:28:18'),
(568, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 22:30:02'),
(569, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 22:30:32'),
(570, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 22:30:52'),
(571, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 22:31:04'),
(572, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 22:33:36'),
(573, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 22:33:49'),
(574, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 22:34:33'),
(575, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 22:34:54'),
(576, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 22:38:37'),
(577, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 22:38:55'),
(578, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 22:39:14'),
(579, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 22:40:13'),
(580, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TAREA', 'TAREA', '2018-10-21 22:40:36');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cliente`
--

DROP TABLE IF EXISTS `cliente`;
CREATE TABLE IF NOT EXISTS `cliente` (
  `idCliente` int(11) NOT NULL AUTO_INCREMENT,
  `NombreCliente` varchar(150) NOT NULL,
  `Direccion` text NOT NULL,
  `Contacto` char(11) NOT NULL,
  `fechaRegistro` datetime NOT NULL,
  `Estado_idEstado` int(11) NOT NULL,
  PRIMARY KEY (`idCliente`),
  KEY `FK_Estado_EstadoCLiente` (`Estado_idEstado`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `cliente`
--

INSERT INTO `cliente` (`idCliente`, `NombreCliente`, `Direccion`, `Contacto`, `fechaRegistro`, `Estado_idEstado`) VALUES
(5, 'INCASOFT SAC', 'AV- AREQUIPA N2834 - MIRAFLORES', '6374324', '2018-10-20 15:14:50', 1),
(6, 'AMERICAN SOFT SAC', 'AV. LIMATAMBO 342', '2132132', '2018-10-20 15:15:11', 1),
(7, 'QSYSTEM SAC', 'AV. RUSISEÑOREAS 2312 - LINCE', '132123', '2018-10-20 15:15:38', 1),
(8, 'QSOLUTION SAC', 'AV- LIMA 2312', '12312', '2018-10-20 15:15:52', 1),
(9, 'FACIRAC SAC', 'AV. BENAVIDES 22312', '12312', '2018-10-20 15:16:22', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estado`
--

DROP TABLE IF EXISTS `estado`;
CREATE TABLE IF NOT EXISTS `estado` (
  `idEstado` int(11) NOT NULL AUTO_INCREMENT,
  `tipoEstado` tinyint(4) NOT NULL,
  `nombreEstado` varchar(50) NOT NULL,
  PRIMARY KEY (`idEstado`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `estado`
--

INSERT INTO `estado` (`idEstado`, `tipoEstado`, `nombreEstado`) VALUES
(1, 1, 'ACTIVO'),
(2, 1, 'INACTIVO'),
(3, 2, 'HABILITADO'),
(4, 2, 'DESHABILITADO'),
(5, 3, 'INICIADO'),
(6, 3, 'PENDIENTE'),
(7, 3, 'FINALIZADO'),
(8, 3, 'ANULADO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `login`
--

DROP TABLE IF EXISTS `login`;
CREATE TABLE IF NOT EXISTS `login` (
  `idLogin` int(11) NOT NULL AUTO_INCREMENT,
  `Usuario_idUsuario` int(11) NOT NULL,
  `usuarioLog` varchar(50) NOT NULL,
  `passwordLog` varchar(100) NOT NULL,
  `perfilLog` varchar(150) NOT NULL,
  `fechaLog` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip` varchar(50) DEFAULT NULL,
  `fechaLogout` datetime DEFAULT NULL,
  PRIMARY KEY (`idLogin`),
  KEY `Usuario_idUsuario` (`Usuario_idUsuario`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `login`
--

INSERT INTO `login` (`idLogin`, `Usuario_idUsuario`, `usuarioLog`, `passwordLog`, `perfilLog`, `fechaLog`, `ip`, `fechaLogout`) VALUES
(1, 1, 'admin', '$2a$08$RCuzW/8g2Lg4QMNCfmsa/uKp33rvDmdWrC.P40DOECJlMtPu16NMW', 'Administrador', '2018-09-29 14:03:44', '::1', '2018-10-22 19:42:20');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `participacion`
--

DROP TABLE IF EXISTS `participacion`;
CREATE TABLE IF NOT EXISTS `participacion` (
  `idParticipacion` int(11) NOT NULL AUTO_INCREMENT,
  `Actividad_idActividad` int(11) NOT NULL,
  `Persona_idPersona` int(11) NOT NULL,
  `fechaRegistro` datetime NOT NULL,
  PRIMARY KEY (`idParticipacion`),
  KEY `FK_Actividad_Participacion` (`Actividad_idActividad`),
  KEY `FK_PersonaActividad` (`Persona_idPersona`)
) ENGINE=InnoDB AUTO_INCREMENT=122 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `participacion`
--

INSERT INTO `participacion` (`idParticipacion`, `Actividad_idActividad`, `Persona_idPersona`, `fechaRegistro`) VALUES
(1, 11, 45, '2018-10-20 20:12:30'),
(3, 11, 46, '2018-10-20 20:15:52'),
(4, 11, 47, '2018-10-20 20:15:56'),
(5, 11, 48, '2018-10-20 20:16:00'),
(6, 11, 49, '2018-10-20 20:16:05'),
(7, 11, 50, '2018-10-20 20:16:11'),
(8, 11, 51, '2018-10-20 20:16:15'),
(12, 11, 52, '2018-10-20 20:17:47'),
(16, 16, 48, '2018-10-21 21:56:07'),
(17, 16, 45, '2018-10-21 21:56:09'),
(18, 16, 52, '2018-10-21 21:56:11'),
(19, 16, 51, '2018-10-21 21:56:16'),
(20, 16, 66, '2018-10-21 21:56:19'),
(21, 16, 74, '2018-10-21 21:56:23'),
(22, 17, 47, '2018-10-21 21:56:36'),
(23, 17, 54, '2018-10-21 21:56:39'),
(24, 17, 51, '2018-10-21 21:56:42'),
(25, 17, 50, '2018-10-21 21:56:44'),
(26, 12, 49, '2018-10-21 22:06:23'),
(27, 12, 52, '2018-10-21 22:06:28'),
(28, 12, 55, '2018-10-21 22:06:32'),
(29, 12, 51, '2018-10-21 22:06:36'),
(30, 13, 48, '2018-10-21 22:06:57'),
(31, 13, 51, '2018-10-21 22:07:00'),
(32, 13, 55, '2018-10-21 22:07:03'),
(33, 14, 62, '2018-10-21 22:07:14'),
(34, 14, 72, '2018-10-21 22:07:17'),
(35, 14, 49, '2018-10-21 22:07:19'),
(36, 15, 47, '2018-10-21 22:07:30'),
(37, 15, 54, '2018-10-21 22:07:33'),
(38, 18, 50, '2018-10-21 22:08:10'),
(39, 18, 53, '2018-10-21 22:08:12'),
(40, 18, 48, '2018-10-21 22:08:15'),
(41, 19, 51, '2018-10-21 22:16:06'),
(42, 19, 50, '2018-10-21 22:16:09'),
(43, 19, 54, '2018-10-21 22:16:11'),
(44, 19, 49, '2018-10-21 22:16:13'),
(45, 20, 49, '2018-10-21 22:16:44'),
(46, 20, 50, '2018-10-21 22:16:46'),
(47, 20, 51, '2018-10-21 22:16:47'),
(48, 21, 71, '2018-10-21 22:24:00'),
(49, 21, 66, '2018-10-21 22:24:10'),
(50, 21, 59, '2018-10-21 22:24:15'),
(51, 21, 49, '2018-10-21 22:24:17'),
(52, 22, 49, '2018-10-21 22:24:27'),
(53, 22, 48, '2018-10-21 22:24:29'),
(54, 22, 51, '2018-10-21 22:24:31'),
(55, 22, 46, '2018-10-21 22:24:34'),
(56, 23, 45, '2018-10-21 22:24:46'),
(57, 23, 46, '2018-10-21 22:24:48'),
(58, 23, 47, '2018-10-21 22:24:50'),
(59, 24, 48, '2018-10-21 22:25:06'),
(60, 24, 45, '2018-10-21 22:25:10'),
(61, 24, 46, '2018-10-21 22:25:15'),
(68, 27, 45, '2018-10-21 22:28:51'),
(69, 27, 46, '2018-10-21 22:28:54'),
(70, 27, 47, '2018-10-21 22:28:56'),
(71, 28, 45, '2018-10-21 22:29:07'),
(72, 28, 46, '2018-10-21 22:29:11'),
(73, 28, 47, '2018-10-21 22:29:12'),
(74, 29, 45, '2018-10-21 22:29:22'),
(75, 29, 46, '2018-10-21 22:29:24'),
(76, 29, 47, '2018-10-21 22:29:25'),
(77, 30, 45, '2018-10-21 22:29:36'),
(78, 30, 46, '2018-10-21 22:29:38'),
(79, 30, 47, '2018-10-21 22:29:41'),
(80, 31, 45, '2018-10-21 22:35:56'),
(81, 31, 46, '2018-10-21 22:36:01'),
(82, 31, 47, '2018-10-21 22:36:04'),
(83, 32, 45, '2018-10-21 22:36:15'),
(84, 32, 46, '2018-10-21 22:36:17'),
(85, 32, 47, '2018-10-21 22:36:19'),
(86, 33, 45, '2018-10-21 22:37:29'),
(87, 33, 46, '2018-10-21 22:37:32'),
(88, 33, 47, '2018-10-21 22:37:34'),
(89, 34, 45, '2018-10-21 22:37:45'),
(90, 34, 46, '2018-10-21 22:37:47'),
(91, 34, 47, '2018-10-21 22:37:49'),
(92, 35, 46, '2018-10-21 22:38:01'),
(93, 35, 45, '2018-10-21 22:38:08'),
(94, 35, 48, '2018-10-21 22:38:13'),
(96, 12, 45, '2018-10-21 22:44:25'),
(97, 13, 45, '2018-10-21 22:44:35'),
(98, 14, 45, '2018-10-21 22:44:45'),
(99, 15, 45, '2018-10-21 22:44:53'),
(100, 17, 45, '2018-10-21 22:45:21'),
(101, 18, 45, '2018-10-21 22:45:29'),
(102, 19, 45, '2018-10-21 22:45:49'),
(103, 20, 45, '2018-10-21 22:45:57'),
(104, 21, 45, '2018-10-21 22:46:11'),
(105, 22, 45, '2018-10-21 22:46:20'),
(106, 23, 49, '2018-10-21 22:46:29'),
(107, 24, 47, '2018-10-21 22:46:37'),
(113, 25, 45, '2018-10-21 22:48:19'),
(118, 26, 45, '2018-10-21 22:49:26'),
(119, 26, 46, '2018-10-21 22:51:23'),
(120, 26, 47, '2018-10-21 22:51:24'),
(121, 28, 50, '2018-10-21 22:51:58');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `participaciontarea`
--

DROP TABLE IF EXISTS `participaciontarea`;
CREATE TABLE IF NOT EXISTS `participaciontarea` (
  `idParticipacionTarea` int(11) NOT NULL AUTO_INCREMENT,
  `Actividad_idActividad` int(11) NOT NULL,
  `Tarea_idTarea` int(11) NOT NULL,
  `Persona_idPersona` int(11) NOT NULL,
  `fechaRegistro` datetime NOT NULL,
  PRIMARY KEY (`idParticipacionTarea`),
  KEY `FK_partiTarea_Actividad` (`Actividad_idActividad`),
  KEY `FK_partiTarea_Tarea` (`Tarea_idTarea`),
  KEY `FK_partiTarea_Persona` (`Persona_idPersona`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `perfil`
--

DROP TABLE IF EXISTS `perfil`;
CREATE TABLE IF NOT EXISTS `perfil` (
  `idPerfil` int(11) NOT NULL AUTO_INCREMENT,
  `nombrePerfil` varchar(50) NOT NULL,
  `descripcionPerfil` text NOT NULL,
  `Estado_idEstado` int(11) NOT NULL,
  `fechaRegistro` datetime NOT NULL,
  PRIMARY KEY (`idPerfil`),
  KEY `FK_Estado` (`Estado_idEstado`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `perfil`
--

INSERT INTO `perfil` (`idPerfil`, `nombrePerfil`, `descripcionPerfil`, `Estado_idEstado`, `fechaRegistro`) VALUES
(1, 'ADMINISTRADOR', 'ADMINISTRADOR GENERAL, QUE SE ENCARGUE DE TENER ACCESO A TODO EL SISTEMA.', 1, '2018-09-29 13:29:55'),
(9, 'JEFE DE PROYECTO', 'JEFE DE PROYECTO GENERAL ENCARGADO DE LOS PROYECTOS, PODRÁ ASIGNAR LAS ACTIVIDADES, TAREAS Y PROYECTOS A LOS TRABAJADORES, ENCARGADO TAMBIÉN DE REALIZAR LOS REPORTES DE CADA PROYECTO Y DE LOS INDICADORES DE CADA PROYECTO.', 1, '2018-10-20 13:44:13'),
(10, 'EMPLEADO', 'EMPLEADO		EMPLEADO SE ENCARGA DE REALIZAR LAS ACTIVIDADES Y TAREAS \r\nQUE LE ASIGNE EL JEFE DE PROYECTOS.', 1, '2018-10-20 13:46:08');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos`
--

DROP TABLE IF EXISTS `permisos`;
CREATE TABLE IF NOT EXISTS `permisos` (
  `idPermisos` int(11) NOT NULL AUTO_INCREMENT,
  `Perfil_idPerfil` int(11) NOT NULL,
  `Permiso1` int(11) NOT NULL,
  `Permiso2` int(11) NOT NULL,
  `Permiso3` int(11) NOT NULL,
  PRIMARY KEY (`idPermisos`),
  KEY `FK_Perfil_idPerfil` (`Perfil_idPerfil`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `permisos`
--

INSERT INTO `permisos` (`idPermisos`, `Perfil_idPerfil`, `Permiso1`, `Permiso2`, `Permiso3`) VALUES
(5, 1, 1, 1, 1),
(9, 9, 1, 0, 1),
(10, 10, 1, 0, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `persona`
--

DROP TABLE IF EXISTS `persona`;
CREATE TABLE IF NOT EXISTS `persona` (
  `idPersona` int(11) NOT NULL AUTO_INCREMENT,
  `nombrePersona` varchar(50) NOT NULL,
  `apellidoPaterno` varchar(50) NOT NULL,
  `apellidoMaterno` varchar(50) NOT NULL,
  `DNI` char(8) NOT NULL,
  `fechaNacimiento` date DEFAULT NULL,
  `correo` varchar(50) DEFAULT NULL,
  `telefono` char(10) DEFAULT NULL,
  `direccion` text,
  `Estado_idEstado` int(11) NOT NULL,
  `fechaRegistro` datetime NOT NULL,
  PRIMARY KEY (`idPersona`),
  KEY `FK_Estado_idEstado` (`Estado_idEstado`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=140 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `persona`
--

INSERT INTO `persona` (`idPersona`, `nombrePersona`, `apellidoPaterno`, `apellidoMaterno`, `DNI`, `fechaNacimiento`, `correo`, `telefono`, `direccion`, `Estado_idEstado`, `fechaRegistro`) VALUES
(1, 'ADMINISTRADOR', 'GENERAL', 'DEL SISTEMA', '47040087', '2018-10-04', 'ADMINISTRADOR@HOTMAIL.COM', '55555', 'DIRECCION', 1, '2018-09-29 13:45:53'),
(40, 'ANTONIO', 'GARCIA', 'ARIAS', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(41, 'JOSE', 'GONZALEZ', 'CARMONA', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(42, 'MANUEL', 'RODRIGUEZ', 'CRESPO', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(43, 'FRANCISCO', 'FERNANDEZ', 'ROMAN', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(44, 'DAVID', 'LOPEZ', 'PASTOR', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(45, 'JUAN', 'MARTINEZ', 'SOTO', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(46, 'JOSE ANTONIO', 'SANCHEZ', 'SAEZ', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(47, 'JAVIER', 'PEREZ', 'VELASCO', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(48, 'JOSE LUIS', 'GOMEZ', 'MOYA', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(49, 'DANIEL', 'MARTIN', 'SOLER', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(50, 'FRANCISCO JAVIER', 'JIMENEZ', 'PARRA', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(51, 'JESUS', 'RUIZ', 'ESTEBAN', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(52, 'CARLOS', 'HERNANDEZ', 'BRAVO', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(53, 'ALEJANDRO', 'DIAZ', 'GALLARDO', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(54, 'MIGUEL', 'MORENO', 'ROJAS', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(55, 'JOSE MANUEL', 'MUÑOZ', 'HERRERO', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(56, 'RAFAEL', 'ALVAREZ', 'MONTERO', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(57, 'PEDRO', 'ROMERO', 'LORENZO', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(58, 'MIGUEL ANGEL', 'ALONSO', 'HIDALGO', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(59, 'ANGEL', 'GUTIERREZ', 'GIMENEZ', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(60, 'PABLO', 'NAVARRO', 'IBAÑEZ', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(61, 'JOSE MARIA', 'TORRES', 'FERRER', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(62, 'FERNANDO', 'DOMINGUEZ', 'DURAN', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(63, 'SERGIO', 'VAZQUEZ', 'SANTIAGO', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(64, 'LUIS', 'RAMOS', 'BENITEZ', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(65, 'JORGE', 'GIL', 'VARGAS', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(66, 'ALBERTO', 'RAMIREZ', 'MORA', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(67, 'JUAN CARLOS', 'SERRANO', 'VICENTE', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(68, 'ALVARO', 'BLANCO', 'VIDAL', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(69, 'JUAN JOSE', 'MOLINA', 'PEÑA', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(70, 'DIEGO', 'MORALES', 'FLORES', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(71, 'ADRIAN', 'SUAREZ', 'CABRERA', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(72, 'RAUL', 'ORTEGA', 'CAMPOS', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(73, 'JUAN ANTONIO', 'DELGADO', 'VEGA', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(74, 'IVAN', 'CASTRO', 'FUENTES', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(75, 'ENRIQUE', 'ORTIZ', 'CARRASCO', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(76, 'RUBEN', 'RUBIO', 'DIEZ', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(77, 'RAMON', 'MARIN', 'REYES', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(78, 'VICENTE', 'SANZ', 'CABALLERO', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(79, 'OSCAR', 'NUÑEZ', 'NIETO', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(80, 'ANDRES', 'IGLESIAS', 'AGUILAR', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(81, 'JOAQUIN', 'MEDINA', 'PASCUAL', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(82, 'JUAN MANUEL', 'GARRIDO', 'SANTANA', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(83, 'SANTIAGO', 'CORTES', 'MORALES', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(84, 'EDUARDO', 'CASTILLO', 'SUAREZ', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(85, 'VICTOR', 'SANTOS', 'ORTEGA', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(86, 'MARIO', 'LOZANO', 'DELGADO', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(87, 'ROBERTO', 'GUERRERO', 'CASTRO', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(88, 'JAIME', 'CANO', 'ORTIZ', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(89, 'ANGELA', 'PRIETO', 'MOLINA', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(90, 'SONIA', 'MENDEZ', 'RUBIO', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(91, 'SANDRA', 'CRUZ', 'MARIN', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(92, 'MARINA', 'CALVO', 'SANZ', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(93, 'SUSANA', 'GALLEGO', 'NUÑEZ', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(94, 'YOLANDA', 'HERRERA', 'IGLESIAS', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(95, 'NATALIA', 'MARQUEZ', 'MEDINA', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(96, 'MARGARITA', 'LEON', 'GARRIDO', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(97, 'MARIA JOSEFA', 'VIDAL', 'CORTES', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(98, 'MARIA ROSARIO', 'PEÑA', 'CASTILLO', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(99, 'EVA', 'FLORES', 'SANTOS', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(100, 'INMACULADA', 'CABRERA', 'LOZANO', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(101, 'CLAUDIA', 'CAMPOS', 'GUERRERO', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(102, 'MARIA MERCEDES', 'VEGA', 'CANO', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(103, 'ANA ISABEL', 'FUENTES', 'PRIETO', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(104, 'ESTHER', 'CARRASCO', 'MENDEZ', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(105, 'NOELIA', 'DIEZ', 'CRUZ', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(106, 'CARLA', 'REYES', 'CALVO', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(107, 'VERONICA', 'CABALLERO', 'GALLEGO', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(108, 'SOFIA', 'NIETO', 'HERRERA', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(109, 'ANGELES', 'AGUILAR', 'MARQUEZ', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(110, 'CAROLINA', 'PASCUAL', 'LEON', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(111, 'NEREA', 'SANTANA', 'ROMERO', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(112, 'MARIA VICTORIA', 'HERRERO', 'ALONSO', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(113, 'MARIA ROSA', 'MONTERO', 'GUTIERREZ', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(114, 'EVA MARIA', 'LORENZO', 'NAVARRO', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(115, 'AMPARO', 'HIDALGO', 'TORRES', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(116, 'MIRIAM', 'GIMENEZ', 'DOMINGUEZ', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(117, 'LORENA', 'IBAÑEZ', 'VAZQUEZ', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(118, 'INES', 'FERRER', 'RAMOS', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(119, 'MARIA CONCEPCION', 'DURAN', 'GIL', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(120, 'ANA BELEN', 'SANTIAGO', 'RAMIREZ', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(121, 'MARIA ELENA', 'BENITEZ', 'SERRANO', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(122, 'VICTORIA', 'VARGAS', 'BLANCO', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:08:59'),
(123, 'MARIA ANTONIA', 'MORA', 'GARCIA', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:09:00'),
(124, 'DANIELA', 'VICENTE', 'GONZALEZ', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:09:00'),
(125, 'CATALINA', 'ARIAS', 'RODRIGUEZ', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:09:00'),
(126, 'CONSUELO', 'CARMONA', 'FERNANDEZ', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:09:00'),
(127, 'LIDIA', 'CRESPO', 'LOPEZ', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:09:00'),
(128, 'MARIA NIEVES', 'ROMAN', 'MARTINEZ', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:09:00'),
(129, 'CELIA', 'PASTOR', 'SANCHEZ', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:09:00'),
(130, 'ALEJANDRA', 'SOTO', 'PEREZ', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:09:00'),
(131, 'OLGA', 'SAEZ', 'GOMEZ', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:09:00'),
(132, 'EMILIA', 'VELASCO', 'MARTIN', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:09:00'),
(133, 'GLORIA', 'MOYA', 'JIMENEZ', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:09:00'),
(134, 'LUISA', 'SOLER', 'RUIZ', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:09:00'),
(135, 'AINHOA', 'PARRA', 'HERNANDEZ', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:09:00'),
(136, 'AURORA', 'ESTEBAN', 'DIAZ', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:09:00'),
(137, 'MARIA SOLEDAD', 'BRAVO', 'MORENO', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:09:00'),
(138, 'MARTINA', 'GALLARDO', 'MUÑOZ', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:09:00'),
(139, 'FATIMA', 'ROJAS', 'ALVAREZ', '44444444', '1989-01-01', 'example@hotmail.com', '999999999', 'direccion ejemplo', 1, '2018-10-20 14:09:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proyecto`
--

DROP TABLE IF EXISTS `proyecto`;
CREATE TABLE IF NOT EXISTS `proyecto` (
  `idProyecto` int(11) NOT NULL AUTO_INCREMENT,
  `NombreProyecto` varchar(200) NOT NULL,
  `Cliente_idCliente` int(11) NOT NULL,
  `Descripcion` text NOT NULL,
  `fechaRegistro` datetime NOT NULL,
  `fechaInicio` date DEFAULT NULL,
  `fechaFin` date DEFAULT NULL,
  `Persona_idPersona` int(11) DEFAULT NULL,
  `Estado_idEstado` int(11) NOT NULL,
  PRIMARY KEY (`idProyecto`),
  KEY `FK_EStado_idEstadoProyecto2` (`Estado_idEstado`),
  KEY `FK_Cliente_Proyecto` (`Cliente_idCliente`),
  KEY `FK_ProyectoPersona` (`Persona_idPersona`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `proyecto`
--

INSERT INTO `proyecto` (`idProyecto`, `NombreProyecto`, `Cliente_idCliente`, `Descripcion`, `fechaRegistro`, `fechaInicio`, `fechaFin`, `Persona_idPersona`, `Estado_idEstado`) VALUES
(5, 'Sistema WEB para el Proceso de Producción', 5, 'Sistema de Producción para el CLiente INCASOFT SAC', '2018-10-20 15:19:38', '2018-10-01', '2019-01-19', 40, 1),
(6, 'Sistema WEB para el Proceso Contable', 5, 'Modulo Contable Cliente INCASOFT SAC', '2018-10-20 15:22:58', '2018-10-01', '2018-12-14', 41, 1),
(7, 'Sistema WEB para el Proceso de venta', 6, 'Sistema para el Area de Venta de AMERICAN SOFT SAC', '2018-10-20 15:23:55', '2018-10-01', '2018-11-28', 42, 1),
(8, 'Sistema MOVIL ANDROID para el Proceso de Registros Academicos', 7, 'Proyecto de Referencia Activo QSYSTEM SAC', '2018-10-20 15:24:57', '2018-10-10', '2018-12-13', 43, 1),
(9, 'Sistema WEB Administrativo SIEN', 8, 'Proyecto  de terceros para el Estado.', '2018-10-20 15:39:01', '2018-10-16', '2018-11-22', 44, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tarea`
--

DROP TABLE IF EXISTS `tarea`;
CREATE TABLE IF NOT EXISTS `tarea` (
  `idTarea` int(11) NOT NULL AUTO_INCREMENT,
  `NombreTarea` varchar(150) NOT NULL,
  `Descripcion` text NOT NULL,
  `fechaRegistro` datetime NOT NULL,
  `fechaInicio` date DEFAULT NULL,
  `fechaFin` date DEFAULT NULL,
  `Actividad_idActividad` int(11) NOT NULL,
  `Estado_idEstado` int(11) NOT NULL,
  PRIMARY KEY (`idTarea`),
  KEY `FK_Estado_Subtarea` (`Estado_idEstado`),
  KEY `FK_Actividad_idTAREA` (`Actividad_idActividad`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `tarea`
--

INSERT INTO `tarea` (`idTarea`, `NombreTarea`, `Descripcion`, `fechaRegistro`, `fechaInicio`, `fechaFin`, `Actividad_idActividad`, `Estado_idEstado`) VALUES
(5, 'tarea1', 'tarea1', '2018-10-21 20:49:36', '2018-10-01', '2018-10-10', 11, 5),
(6, 'tarea 2', 'tarea 2', '2018-10-21 20:49:59', '2018-10-10', '2018-10-20', 11, 5),
(7, 'Tarea 3', 'Tarea 3', '2018-10-21 20:51:26', '2018-10-20', '2018-10-31', 11, 5),
(8, 'Tarea 4', 'Tarea 4', '2018-10-21 20:52:30', '2018-10-31', '2018-11-10', 11, 5),
(9, 'tarea 1', 'tarea 1', '2018-10-21 21:06:53', '2018-11-10', '2018-11-17', 12, 5),
(10, 'tarea 2', 'tarea 2', '2018-10-21 21:07:09', '2018-11-17', '2018-11-22', 12, 5),
(11, 'Tarea 3', 'Tarea 3', '2018-10-21 21:27:13', '2018-11-22', '2018-11-29', 12, 5),
(12, 'Tarea 1', 'Tarea 1', '2018-10-21 21:40:15', '2018-11-29', '2018-12-06', 13, 5),
(13, 'Tarea 2', 'Tarea 2', '2018-10-21 21:40:38', '2018-12-06', '2018-12-13', 13, 5),
(14, 'Tarea 3', 'Tarea 3', '2018-10-21 21:40:53', '2018-12-13', '2018-12-20', 13, 5),
(15, 'Tarea 1', 'Tarea 1', '2018-10-21 21:41:49', '2018-12-20', '2018-12-25', 14, 5),
(16, 'Tarea 2', 'Tarea 2', '2018-10-21 21:46:58', '2018-12-25', '2018-12-31', 14, 5),
(17, 'Tarea 1', 'Tarea 1', '2018-10-21 21:47:34', '2018-12-31', '2019-01-11', 15, 5),
(18, 'Tarea 2', 'Tarea 2', '2018-10-21 21:48:00', '2019-01-11', '2019-01-19', 15, 5),
(19, 'Tarea 1', 'Tarea 1', '2018-10-21 22:17:12', '2018-10-01', '2018-10-12', 16, 5),
(20, 'Tarea 2', 'Tarea 2', '2018-10-21 22:17:27', '2018-10-12', '2018-10-26', 16, 5),
(21, 'Tarea 3', 'Tarea 3', '2018-10-21 22:18:25', '2018-10-26', '2018-10-31', 16, 5),
(22, 'Tarea 1', 'Tarea 1', '2018-10-21 22:19:01', '2018-10-31', '2018-11-08', 17, 5),
(23, 'Tarea 2', 'Tarea 2', '2018-10-21 22:19:47', '2018-11-08', '2018-11-16', 17, 5),
(24, 'Tarea 1', 'Tarea 1', '2018-10-21 22:20:18', '2018-11-16', '2018-11-21', 18, 5),
(25, 'Tarea 2', 'Tarea 2', '2018-10-21 22:20:32', '2018-11-21', '2018-11-23', 18, 5),
(26, 'Tarea 1', 'Tarea 1', '2018-10-21 22:22:32', '2018-11-23', '2018-11-29', 19, 5),
(27, 'Tarea 2', 'Tarea 2', '2018-10-21 22:22:51', '2018-11-29', '2018-11-30', 19, 5),
(28, 'Tarea 1', 'Tarea 1', '2018-10-21 22:23:22', '2018-11-30', '2018-12-06', 20, 5),
(29, 'Tarea 2', 'Tarea 2', '2018-10-21 22:23:37', '2018-12-06', '2018-12-14', 20, 5),
(30, 'TAREA 1', 'TAREA 1', '2018-10-21 22:25:57', '2018-10-01', '2018-10-04', 21, 5),
(31, 'TAREA 1', 'TAREA 1', '2018-10-21 22:26:21', '2018-10-04', '2018-10-11', 22, 5),
(32, 'TAREA 1', 'TAREA 1', '2018-10-21 22:26:41', '2018-10-11', '2018-10-25', 23, 5),
(33, 'TAREA 1', 'TAREA 1', '2018-10-21 22:26:56', '2018-10-25', '2018-10-30', 23, 5),
(34, 'TAREA 1', 'TAREA 1', '2018-10-21 22:27:51', '2018-10-31', '2018-11-02', 24, 5),
(35, 'TAREA 1', 'TAREA 1', '2018-10-21 22:28:18', '2018-11-02', '2018-11-28', 25, 5),
(36, 'TAREA 1', 'TAREA 1', '2018-10-21 22:30:02', '2018-10-10', '2018-10-31', 26, 7),
(37, 'TAREA 2', 'TAREA 2', '2018-10-21 22:30:32', '2018-10-31', '2018-10-31', 26, 7),
(38, 'TAREA 1', 'TAREA 1', '2018-10-21 22:30:52', '2018-10-31', '2018-11-08', 27, 7),
(39, 'TAREA 2', 'TAREA 2', '2018-10-21 22:31:04', '2018-11-08', '2018-11-16', 27, 7),
(40, 'TAREA 1', 'TAREA 1', '2018-10-21 22:33:36', '2018-11-16', '2018-11-20', 28, 6),
(41, 'TAREA 2', 'TAREA 2', '2018-10-21 22:33:49', '2018-11-20', '2018-11-22', 28, 7),
(42, 'TAREA 1', 'TAREA 1', '2018-10-21 22:34:33', '2018-11-22', '2018-11-30', 29, 7),
(43, 'TAREA 1', 'TAREA 1', '2018-10-21 22:34:54', '2018-11-30', '2018-12-13', 30, 6),
(44, 'TAREA 1', 'TAREA 1', '2018-10-21 22:38:37', '2018-10-16', '2018-10-30', 31, 7),
(45, 'TAREA 1', 'TAREA 1', '2018-10-21 22:38:55', '2018-10-30', '2018-11-06', 32, 5),
(46, 'TAREA 1', 'TAREA 1', '2018-10-21 22:39:14', '2018-11-06', '2018-11-14', 33, 5),
(47, 'TAREA 1', 'TAREA 1', '2018-10-21 22:40:13', '2018-11-14', '2018-11-17', 34, 5),
(48, 'TAREA 1', 'TAREA 1', '2018-10-21 22:40:36', '2018-11-17', '2018-11-22', 35, 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tareagestion`
--

DROP TABLE IF EXISTS `tareagestion`;
CREATE TABLE IF NOT EXISTS `tareagestion` (
  `idGestionTarea` int(11) NOT NULL AUTO_INCREMENT,
  `Tarea_idTarea` int(11) NOT NULL,
  `Persona_idPersona` int(11) DEFAULT NULL,
  `DiasTotales` int(11) NOT NULL,
  `DiasGestion` int(11) NOT NULL,
  `fechaInicio` date DEFAULT NULL,
  `fechaFin` date DEFAULT NULL,
  `Detalle` text,
  `fechaRegistro` date NOT NULL,
  PRIMARY KEY (`idGestionTarea`),
  KEY `FK_TareaGestion` (`Tarea_idTarea`),
  KEY `FK_PersonTareaGestion` (`Persona_idPersona`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `tareagestion`
--

INSERT INTO `tareagestion` (`idGestionTarea`, `Tarea_idTarea`, `Persona_idPersona`, `DiasTotales`, `DiasGestion`, `fechaInicio`, `fechaFin`, `Detalle`, `fechaRegistro`) VALUES
(1, 38, 45, 8, 6, '2018-10-31', '2018-11-06', 'wfwefwe', '2018-10-22'),
(3, 38, 45, 8, 2, '2018-11-06', '2018-11-08', 'wfwefwef', '2018-10-22'),
(4, 37, 45, 0, 0, '2018-10-31', '2018-10-31', 'fwefwefewf', '2018-10-22'),
(5, 39, 45, 8, 8, '2018-11-08', '2018-11-16', 'wfwef', '2018-10-22'),
(6, 36, 45, 21, 21, '2018-10-10', '2018-10-31', 'fwefwef', '2018-10-22'),
(7, 40, 45, 4, 2, '2018-11-16', '2018-11-18', 'fwefwef', '2018-10-22'),
(8, 41, 45, 2, 2, '2018-11-20', '2018-11-22', 'wfwef', '2018-10-22'),
(9, 42, 45, 8, 8, '2018-11-22', '2018-11-30', 'wfwefwef', '2018-10-22'),
(10, 43, 45, 13, 5, '2018-11-30', '2018-12-05', 'wfwef', '2018-10-22'),
(11, 44, 45, 14, 14, '2018-10-16', '2018-10-30', 'cascasas', '2018-10-22');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

DROP TABLE IF EXISTS `usuario`;
CREATE TABLE IF NOT EXISTS `usuario` (
  `idUsuario` int(11) NOT NULL AUTO_INCREMENT,
  `usuario` varchar(50) NOT NULL,
  `pass` varchar(100) NOT NULL,
  `Perfil_idPerfil` int(11) NOT NULL,
  `Persona_idPersona` int(11) NOT NULL,
  `Estado_idEstado` int(11) NOT NULL,
  `fechaRegistro` datetime NOT NULL,
  PRIMARY KEY (`idUsuario`),
  KEY `Perfil_idPerfil` (`Perfil_idPerfil`) USING BTREE,
  KEY `Persona_idPersona` (`Persona_idPersona`) USING BTREE,
  KEY `Estado_idEstado` (`Estado_idEstado`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`idUsuario`, `usuario`, `pass`, `Perfil_idPerfil`, `Persona_idPersona`, `Estado_idEstado`, `fechaRegistro`) VALUES
(1, 'admin', '$2a$08$Vo4zFrwFG.k2ZHhln/fQVu5NoeJdzJUSG6HOVA6fBCknS/umS0bki', 1, 1, 1, '2018-09-29 14:03:15'),
(7, 'agarciaa', '$2a$08$I6wjt3lXDOXWdDZAKCy/yOMRtTuYPrCBsveBX5/L2J8qmQLHUiQAO', 9, 40, 1, '2018-10-20 14:12:00'),
(8, 'jgonzalezc', '$2a$08$hQ1tRvkc6QjZ7KiisqQ93.7nsME15CsRWRhk.hK1tHJ1q6nrd.zKq', 9, 41, 1, '2018-10-20 14:12:19'),
(9, 'mrodriguezc', '$2a$08$CHpZjVrfSVyk4TX.k82eKOFM9OAFTOnhtJa55Of2xGX4RMTfmoUce', 9, 42, 1, '2018-10-20 14:12:44'),
(10, 'ffernandezr', '$2a$08$rLbQSYmZ3I2r.kDEUHW.vO0sB03/02z6zIyq70TmQX0rfMSFuFIRm', 9, 43, 1, '2018-10-20 14:13:08'),
(11, 'dlopezp', '$2a$08$j9e4wzhJFa.IFRrtv5BdA..v5RzQ8.kMSQRn5jPl/oSCe9WSN5vVy', 9, 44, 1, '2018-10-20 14:13:30'),
(12, 'jmartinezd', '$2a$08$ub7Ti8tUFuaEioZ5y0cBneWsQ.M7HD/3bMEsvuWKKjCvoLM4zM0DK', 10, 45, 1, '2018-10-20 14:13:52'),
(13, 'jsanchezs', '$2a$08$olLiCLQLA7km0mJgijVmuO8hIMedLG.fsdGafjh63SzNQjwTP0krK', 10, 46, 1, '2018-10-20 14:14:16'),
(14, 'jperezv', '$2a$08$/57L1Tx6a01zNSXMVAiu1OHzC2PwC1bVn9ZXd3TonJgxniYNsCJ9a', 10, 47, 1, '2018-10-20 14:14:48'),
(15, 'jgomezm', '$2a$08$a6jI1vU7bs8ERw5fwePIkeoctJsbMeGM1OFM6hw7ltU9KgWbwmsOK', 10, 48, 1, '2018-10-20 14:15:11'),
(16, 'dmartins', '$2a$08$cdaJ5PjKmmX0vqb5mMNQPeXi9LzYi.yYxLbzfCFJ/1gmEnIu6brVm', 10, 49, 1, '2018-10-20 14:15:22'),
(17, 'fjimenezp', '$2a$08$9k7qzTeLlqZ8bm4Gt8HZ2uIIsdgP6B6pmjLNxJhxhTU7Ie0etOZhm', 10, 50, 1, '2018-10-20 14:15:37'),
(18, 'jruize', '$2a$08$X.FJYFIwcodQi1LKFA48wOAe8rHgdjrM96nCklJnzjkFP/Wm0I0T2', 10, 51, 1, '2018-10-20 14:15:50'),
(19, 'chernandezb', '$2a$08$u6Q1ZZAUOmZ6gjTZid95X.CufW5tZz81U39ZsJzNyfxasden3Hwkm', 10, 52, 1, '2018-10-20 14:16:05'),
(20, 'adiazg', '$2a$08$.IZQdrjRmIWTTrXajrypDuoZU0ySwjYzQxbB9rKwscHMl5FHNUOFe', 10, 53, 1, '2018-10-20 14:16:18'),
(21, 'mmorenor', '$2a$08$c8K6zSWGfwqdjsEPAatlvOUp3MHMxxUxFbWutrioV5Qi4CTXXKOm.', 10, 54, 1, '2018-10-20 14:16:31'),
(22, 'jmunozh', '$2a$08$GovvHDW3KoCLlxbmoBLnfeR5KbuMlYmE/XiN11ETxBGhsYssXddpC', 10, 55, 1, '2018-10-20 14:16:48'),
(23, 'ralvarezm', '$2a$08$nGH6B5vds51gNOxzXuVS4OojOJT.CpMrbYJMWetvIXptd2Y9Ffmd.', 10, 56, 1, '2018-10-20 14:17:03'),
(24, 'promerol', '$2a$08$5PnI54ptOjVEjzglrOfNFuMAkQ7QLUVR3/lsaLSeMHCEEFB6LfGq6', 10, 57, 1, '2018-10-20 14:17:14'),
(25, 'malonso', '$2a$08$1JrSTkM7iDpxcySY21vJf.U6fk2xC9gJEci.SBlYLPX46rNqgQdpG', 10, 58, 1, '2018-10-20 14:17:41'),
(26, 'agutierrezg', '$2a$08$J1uvO0UWK/2DhwTN/dwCLOrpzWmb0hGMhKJzWMwKMHDpKmgsOjM/W', 10, 59, 1, '2018-10-20 14:18:04'),
(27, 'pnavarroi', '$2a$08$rkx.y6cFpsaMv82UM/TAuu9iZSSv0hslPWMYIzIvP3hkiGhkHpr8u', 10, 60, 1, '2018-10-20 14:18:17'),
(28, 'jtorresf', '$2a$08$lVeTvZHXi9/RpV06xIgKquZKLphGePWq0MI6NWY445uJ9pkoaExAq', 10, 61, 1, '2018-10-20 14:19:21'),
(29, 'fdominguezd', '$2a$08$Xzk7vHwRzQrWUQd5I9oe2eeGhMNZTTw55tZGWG4iGxwjRoz.H7I/m', 10, 62, 1, '2018-10-20 14:19:37'),
(30, 'svazquezs', '$2a$08$ZXIDQc/PaUl6E09qiRHz/u7GzgJn6nWG4aoSu3ohUzUN9UsjY.y/6', 10, 63, 1, '2018-10-20 14:19:56'),
(31, 'lramosb', '$2a$08$mrM./h42Em9jymq7h.aqp.nHDCyLzJEIWub0K.XuLQifLRtVpiLMi', 10, 64, 1, '2018-10-20 14:20:12'),
(32, 'jgilv', '$2a$08$gBIeR7Yb19/C4ERo10FKGeHFp3KLVLVe/11/rR7yFZquTAoQlwhCm', 10, 65, 1, '2018-10-20 14:20:37'),
(33, 'aramirezm', '$2a$08$7Mj9sig7sKCEXxhxkV4Jmep33lWMGuHZrlf/0BtnIru3NldLAWHnS', 10, 66, 1, '2018-10-20 14:20:49'),
(34, 'jserranov', '$2a$08$S4r4CI9TIY4BNQ9p7zK5MuflLGTGMNI4e3avYSqAG4ZLKD1/p9acm', 10, 67, 1, '2018-10-20 14:21:04'),
(35, 'ablancov', '$2a$08$7Z7ljjTwXk2XwDbCLnXDfO.6TGmID0Uhq.79NcletYp47ChP684mO', 10, 68, 1, '2018-10-20 14:21:22'),
(36, 'jmolinap', '$2a$08$qh7t.170ojty0R8A2HeiUeN2EVISseqX3gcaGkfnCdp/bx1J9GBjO', 10, 69, 1, '2018-10-20 14:21:42'),
(37, 'dmoralesf', '$2a$08$gMi.38E.HJGDoi2GFHKmXeVF83svFBrDelhg3ztb/t6fSyqZDHKUW', 10, 70, 1, '2018-10-20 14:21:54'),
(38, 'asuarezc', '$2a$08$LMjohvoONUUHnTSPiINXbutTkcOJUWHgdvMTbYLApACKcU0pQLcVi', 10, 71, 1, '2018-10-20 14:22:06'),
(39, 'rortegac', '$2a$08$EqXCNxWfJ82/ft3AuFPVbeElWRh7kbPXrdlqWP93kzoZMNo1q/ZFi', 10, 72, 1, '2018-10-20 14:22:21'),
(40, 'jdelgadov', '$2a$08$fQRYwMTVZakse6nPuJK3Jus7jIN.QZhHLUTUE8T8AYepk0S6cuux.', 10, 73, 1, '2018-10-20 14:22:41'),
(41, 'icastrof', '$2a$08$0cG7yeI1/gecWVDUofj6F.sFpSbqd0.T.85V2tysul4c7WkNB58xe', 10, 74, 1, '2018-10-20 14:22:54'),
(42, 'eortizc', '$2a$08$Dz3rkTYGwrmsWUakjZg0NOSKi0kiFoi/jk32OC18o3xef7wupV73S', 1, 75, 1, '2018-10-20 14:23:43'),
(43, 'rrubiod', '$2a$08$AzDtpRBv6jVD9kMdP0uc1O3NXMxVfv6nO/aM3hXHINPm5TwFHSnru', 1, 76, 1, '2018-10-20 14:24:02');

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `actividad`
--
ALTER TABLE `actividad`
  ADD CONSTRAINT `FK_Participacion_Actividad22` FOREIGN KEY (`Participacion_idParticipacion`) REFERENCES `participacion` (`idParticipacion`),
  ADD CONSTRAINT `FK_Tarea_Proyecto` FOREIGN KEY (`Proyecto_idProyecto`) REFERENCES `proyecto` (`idProyecto`);

--
-- Filtros para la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD CONSTRAINT `FK_Estado_EstadoCLiente` FOREIGN KEY (`Estado_idEstado`) REFERENCES `estado` (`idEstado`);

--
-- Filtros para la tabla `login`
--
ALTER TABLE `login`
  ADD CONSTRAINT `FK_Usuario_idUsuario2` FOREIGN KEY (`Usuario_idUsuario`) REFERENCES `usuario` (`idUsuario`);

--
-- Filtros para la tabla `participacion`
--
ALTER TABLE `participacion`
  ADD CONSTRAINT `FK_Actividad_Participacion` FOREIGN KEY (`Actividad_idActividad`) REFERENCES `actividad` (`idActividad`),
  ADD CONSTRAINT `FK_PersonaActividad` FOREIGN KEY (`Persona_idPersona`) REFERENCES `persona` (`idPersona`);

--
-- Filtros para la tabla `participaciontarea`
--
ALTER TABLE `participaciontarea`
  ADD CONSTRAINT `FK_partiTarea_Actividad` FOREIGN KEY (`Actividad_idActividad`) REFERENCES `actividad` (`idActividad`),
  ADD CONSTRAINT `FK_partiTarea_Persona` FOREIGN KEY (`Persona_idPersona`) REFERENCES `persona` (`idPersona`),
  ADD CONSTRAINT `FK_partiTarea_Tarea` FOREIGN KEY (`Tarea_idTarea`) REFERENCES `tarea` (`idTarea`);

--
-- Filtros para la tabla `perfil`
--
ALTER TABLE `perfil`
  ADD CONSTRAINT `FK_ESTADO` FOREIGN KEY (`Estado_idEstado`) REFERENCES `estado` (`idEstado`);

--
-- Filtros para la tabla `permisos`
--
ALTER TABLE `permisos`
  ADD CONSTRAINT `FK_Perfil_idPerfil` FOREIGN KEY (`Perfil_idPerfil`) REFERENCES `perfil` (`idPerfil`);

--
-- Filtros para la tabla `persona`
--
ALTER TABLE `persona`
  ADD CONSTRAINT `FK_Estado_idEstado` FOREIGN KEY (`Estado_idEstado`) REFERENCES `estado` (`idEstado`);

--
-- Filtros para la tabla `proyecto`
--
ALTER TABLE `proyecto`
  ADD CONSTRAINT `FK_Cliente_Proyecto` FOREIGN KEY (`Cliente_idCliente`) REFERENCES `cliente` (`idCliente`),
  ADD CONSTRAINT `FK_EStado_idEstadoProyecto2` FOREIGN KEY (`Estado_idEstado`) REFERENCES `estado` (`idEstado`),
  ADD CONSTRAINT `FK_ProyectoPersona` FOREIGN KEY (`Persona_idPersona`) REFERENCES `persona` (`idPersona`);

--
-- Filtros para la tabla `tarea`
--
ALTER TABLE `tarea`
  ADD CONSTRAINT `FK_Estado_Subtarea` FOREIGN KEY (`Estado_idEstado`) REFERENCES `estado` (`idEstado`),
  ADD CONSTRAINT `FK_Tarea_idTarea` FOREIGN KEY (`Actividad_idActividad`) REFERENCES `actividad` (`idActividad`);

--
-- Filtros para la tabla `tareagestion`
--
ALTER TABLE `tareagestion`
  ADD CONSTRAINT `FK_PersonTareaGestion` FOREIGN KEY (`Persona_idPersona`) REFERENCES `persona` (`idPersona`),
  ADD CONSTRAINT `FK_TareaGestion` FOREIGN KEY (`Tarea_idTarea`) REFERENCES `tarea` (`idTarea`);

--
-- Filtros para la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `FK_Estado_idEstado2` FOREIGN KEY (`Estado_idEstado`) REFERENCES `estado` (`idEstado`),
  ADD CONSTRAINT `FK_Perfil_idPerfil2` FOREIGN KEY (`Perfil_idPerfil`) REFERENCES `perfil` (`idPerfil`),
  ADD CONSTRAINT `FK_Persona_idPersona2` FOREIGN KEY (`Persona_idPersona`) REFERENCES `persona` (`idPersona`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
