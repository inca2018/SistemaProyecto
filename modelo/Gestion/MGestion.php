<?php
   require_once '../../config/config.php';


   class MGestion{

      public function __construct(){
      }


		public function Recuperar_Parametros(){
            $sql1=ejecutarConsulta("CALL `SP_RECUPERAR_PARAMETROS`(@p0, @p1, @p2, @p3);");
			$sql="SELECT @p0 AS `Proyectos`, @p1 AS `Tareas`, @p2 AS `Empleados`, @p3 AS `Usuarios`;";
			return ejecutarConsultaSimpleFila($sql);
		}
       	public function Recuperar_Informacion_proyectos(){
			$sql="CALL `SP_GESTION_INFORMACION_AVANCE`();";
			return ejecutarConsulta($sql);
		}
       public function Recuperar_Informacion_Usuario($idUsuario){
			$sql="CALL `SP_RECUPERAR_PROYECTOS_ASIGNADOS`('$idUsuario');";
			return ejecutarConsulta($sql);
		}

		public function RecuperarTareaGestion($idTarea){
			$sql="CALL `SP_GESTION_LISTAR`('$idTarea');";
			return ejecutarConsulta($sql);
		}
       public function ListaDisponibilidad($idUsuario){
          $sql="CALL `SP_LISTA_DISPONIBILIDAD`('$idUsuario');";
			return ejecutarConsulta($sql);
       }

		public function RecuperarInformacionTarea($idTarea){
			$sql="SELECT NombreTarea,Descripcion,fechaInicio,fechaFin,fechaRegistro,idTarea,TIMESTAMPDIFF(DAY,fechaInicio,fechaFin) AS diasT FROM tarea WHERE idTarea='$idTarea';";
			return ejecutarConsultaSimpleFila($sql);
		}
		public function RecuperarInformacionFechas($idTarea){
			$sql="CALL `SP_GESTION_RECUPERAR_FECHAS`('$idTarea');";
			return ejecutarConsultaSimpleFila($sql);
		}

      public function RecuperarReporteFechas($fechaInicio,$fechFin,$idProyecto){
			$sql="CALL `SP_GESTION_RECUPERAR_INDICADORES2`('$fechaInicio','$fechFin','$idProyecto');";
			return ejecutarConsultaSimpleFila($sql);
		}
		 public function RecuperarReporte($fechaInicio,$fechFin,$idProyecto){
			$sql="CALL `SP_REPORTE_1`('$fechaInicio','$fechFin','$idProyecto');";
			return ejecutarConsulta($sql);
		}
		public function RegistroGestionTarea($idTarea,$detalle,$inicio,$fin,$login_idLog){
			 $sql="CALL `SP_GESTION_REGISTRO`('$idTarea','$detalle','$inicio','$fin','$login_idLog');";

			return ejecutarConsulta($sql);
		}
     public function RecuperarActividades($idProyecto){
		  $sql="SELECT ac.idActividad,ac.NombreTarea FROM proyecto pro INNER JOIN actividad ac On ac.Proyecto_idProyecto=pro.idProyecto where pro.idProyecto=$idProyecto";
		  return ejecutarConsulta($sql);
	  }

		public function FinalizarTarea($idTarea,$Documento){
			$sql="UPDATE `tarea` SET  `Documento`='$Documento',`Estado_idEstado`=7 WHERE `idTarea`='$idTarea'";
			return ejecutarConsulta($sql);
		}

    public function EliminarGestion($idGestion,$idTarea){
         $sql="CALL `SP_GESTION_ELIMINAR`('$idGestion','$idTarea');";
		  return ejecutarConsulta($sql);
    }

       public function ListarProyectos(){
           $sql="SELECT
pro.idProyecto,
pro.NombreProyecto,
DATE_FORMAT(pro.fechaInicio,'%d/%m/%Y') as Inicio,
DATE_FORMAT(pro.fechaFin,'%d/%m/%Y') as Fin,
CONCAT(FORMAT(IFNULL(((SELECT SUM(tg.DiasGestion) FROM actividad ac3 INNER JOIN tarea ta3 On ta3.Actividad_idActividad=ac3.idActividad INNER JOIN tareagestion tg On tg.Tarea_idTarea=ta3.idTarea where ac3.Proyecto_idProyecto=pro.idProyecto)*100)/(TIMESTAMPDIFF(DAY,pro.fechaInicio,pro.fechaFin)),'0.00'),2),'%') as PorcentajeAvance

FROM proyecto pro LEFT JOIN actividad ac ON ac.Proyecto_idProyecto=pro.idProyecto GROUP BY pro.idProyecto";
		  return ejecutarConsulta($sql);
       }
       public function ListarActividades($idProyecto){
           $sql="SELECT
act.idActividad,
act.NombreTarea,
DATE_FORMAT(act.fechaInicio,'%d/%m/%Y') as Inicio,
DATE_FORMAT(act.fechaFin,'%d/%m/%Y') as Fin,

CONCAT(FORMAT(IFNULL((
    (SELECT SUM(tg.DiasGestion) FROM actividad ac3 INNER JOIN tarea ta3 On ta3.Actividad_idActividad=ac3.idActividad INNER JOIN tareagestion tg On tg.Tarea_idTarea=ta3.idTarea where ac3.idActividad=act.idActividad)
    *100)
                     /(TIMESTAMPDIFF(DAY,act.fechaInicio,act.fechaFin)),'0.00'),2),'%') as ActividadAvance

FROM actividad act WHERE act.Proyecto_idProyecto='$idProyecto'";
		  return ejecutarConsulta($sql);
       }

       public function ListarTareas($idActividad){
           $sql="SELECT
t.idTarea,
t.NombreTarea,
DATE_FORMAT(t.fechaInicio,'%d/%m/%Y') as Inicio,
DATE_FORMAT(t.fechaFin,'%d/%m/%Y') as Fin,

CONCAT(FORMAT(IFNULL((
    (SELECT SUM(tg.DiasGestion) FROM actividad ac3 INNER JOIN tarea ta3 On ta3.Actividad_idActividad=ac3.idActividad INNER JOIN tareagestion tg On tg.Tarea_idTarea=ta3.idTarea where ta3.idTarea=t.idTarea)
    *100)
                     /(TIMESTAMPDIFF(DAY,t.fechaInicio,t.fechaFin)),'0.00'),2),'%') as TareadAvance

FROM tarea t WHERE t.Actividad_idActividad='$idActividad';";
		  return ejecutarConsulta($sql);
       }


   }

?>
