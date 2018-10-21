<?php
   require_once '../../config/config.php';


   class MTarea{

      public function __construct(){
      }

	  public function Listar_Tarea($idProyecto){
           $sql="CALL `SP_ACTIVIDAD_LISTAR`('$idProyecto');";
           return ejecutarConsulta($sql);
       }
     public function ListarAgregados($idActividad){
           $sql="CALL `SP_ACTIVIDAD_LISTAR_AGREGADOS`('$idActividad');";
           return ejecutarConsulta($sql);
       }
     public function ListarDisponibles($idActividad){
           $sql="CALL `SP_ACTIVIDAD_LISTAR_NOAGREGADO`('$idActividad');";
           return ejecutarConsulta($sql);
       }
     public function AgregarEmpleado($idActividad,$idEmpleado){
           $sql="CALL `SP_ACTIVIDAD_AGREGAR_EMPLEADO`('$idActividad','$idEmpleado');";
           return ejecutarConsulta($sql);
       }
     public function EliminarEmpleado($idActividad,$idParticipacion){
           $sql="CALL `SP_ACTIVIDAD_ELIMINAR_EMPLEADO`('$idActividad','$idParticipacion');";
           return ejecutarConsulta($sql);
       }

      public function Eliminar_Tarea($idTarea,$codigo,$idCreador){
           $sql="CALL `SP_ACTIVIDAD_HABILITACION`('$idTarea','$codigo','$idCreador');";

           return ejecutarConsulta($sql);
       }

      public function RegistroTarea($idTarea,$TareaNombre,$TareaDescripcion,$TareaCosto,$TareaProyecto,$TareaEstado,$login_idLog){
        $sql="";

        if($idTarea=="" || $idTarea==null || empty($idTarea)){
             $sql="CALL `SP_ACTIVIDAD_REGISTRO`('$TareaNombre','$TareaDescripcion','$TareaCosto','$TareaProyecto','$TareaEstado','$login_idLog');";

        }else{

           $sql="CALL `SP_ACTIVIDAD_ACTUALIZAR`('$idTarea','$TareaNombre','$TareaDescripcion','$TareaCosto','$TareaProyecto','$TareaEstado','$login_idLog');";
        }

         return ejecutarConsulta($sql);
      }

		public function Recuperar_Tarea($idTarea){
			$sql="CALL `SP_ACTIVIDAD_RECUPERAR`('$idTarea');";
			return ejecutarConsultaSimpleFila($sql);
		}

       public function RecuperarInformacionProyecto($idProyecto){
			$sql="CALL `SP_ACTIVIDAD_RECUPERAR_PROYECTO`('$idProyecto');";
			return ejecutarConsultaSimpleFila($sql);
		}
        public function RecuperarInformacionActividad($idActividad){
			$sql="CALL `SP_ACTIVIDAD_RECUPERAR_INFORMACION`('$idActividad');";
			return ejecutarConsultaSimpleFila($sql);
		}




   }

?>
