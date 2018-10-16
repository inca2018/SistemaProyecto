<?php
   require_once '../../config/config.php';


   class MTarea{

      public function __construct(){
      }

	  public function Listar_Tarea($idProyecto){
           $sql="CALL `SP_TAREA_LISTAR`('$idProyecto');";
           return ejecutarConsulta($sql);
       }
      public function Eliminar_Tarea($idTarea,$codigo,$idCreador){
           $sql="CALL `SP_TAREA_HABILITACION`('$idTarea','$codigo','$idCreador');";

           return ejecutarConsulta($sql);
       }
      public function ValidarTarea($Tareanom,$idTarea){
          $sql="";
          if($idTarea=='' || $idTarea==null || empty($idTarea)){
			   $sql="SELECT * FROM tarea WHERE NombreTarea='$Tareanom';";
          }else{
             $sql="SELECT * FROM tarea WHERE idTarea!='$idTarea' and NombreTarea='$Tareanom';";
          }
          return validarDatos($sql);
      }
      public function RegistroTarea($idTarea,$TareaNombre,$TareaDescripcion,$TareaHoras,$TareaCosto,$TareaProyecto,$TareaPersona,$TareaEstado,$login_idLog){
        $sql="";

        if($idTarea=="" || $idTarea==null || empty($idTarea)){
             $sql="CALL `SP_TAREA_REGISTRO`('$TareaNombre','$TareaDescripcion','$TareaHoras','$TareaCosto','$TareaProyecto','$TareaPersona','$TareaEstado','$login_idLog');";

        }else{

           $sql="CALL `SP_TAREA_ACTUALIZAR`('$idTarea','$TareaNombre','$TareaDescripcion','$TareaHoras','$TareaCosto','$TareaProyecto','$TareaPersona','$TareaEstado','$login_idLog');";
        }

         return ejecutarConsulta($sql);
      }

		public function Recuperar_Tarea($idTarea){
			$sql="CALL `SP_TAREA_RECUPERAR`('$idTarea');";
			return ejecutarConsultaSimpleFila($sql);
		}


   }

?>
