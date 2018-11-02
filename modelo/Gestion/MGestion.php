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


   }

?>
