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
			$sql="SELECT NombreTarea,fechaInicio,fechaFin,fechaRegistro,idTarea,TIMESTAMPDIFF(DAY,fechaInicio,fechaFin) AS diasT FROM tarea WHERE idTarea='$idTarea';";
			return ejecutarConsultaSimpleFila($sql);
		}
		public function RecuperarInformacionFechas($idTarea){
			$sql="CALL `SP_GESTION_RECUPERAR_FECHAS`('$idTarea');";
			return ejecutarConsultaSimpleFila($sql);
		}

		public function RegistroGestionTarea($idTarea,$detalle,$inicio,$fin,$login_idLog){
			 $sql="CALL `SP_GESTION_REGISTRO`('$idTarea','$detalle','$inicio','$fin','$login_idLog');";

			return ejecutarConsulta($sql);
		}



   }

?>
