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
			$sql="CALL `SP_RECUPERAR_PROYECTOS`();";
			return ejecutarConsulta($sql);
		}
       public function Recuperar_Informacion_Usuario($idUsuario){
			$sql="CALL `SP_RECUPERAR_PROYECTOS_ASIGNADOS`('$idUsuario');";
			return ejecutarConsulta($sql);
		}

   }

?>
