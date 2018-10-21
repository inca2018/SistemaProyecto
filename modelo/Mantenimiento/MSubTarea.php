<?php
   require_once '../../config/config.php';


   class MSubTarea{

      public function __construct(){
      }

	  public function Listar_SubTarea($idTarea){
           $sql="CALL `SP_SUBTAREA_LISTAR`('$idTarea');";
           return ejecutarConsulta($sql);
       }
      public function Eliminar_SubTarea($idSubTarea,$codigo,$idCreador){
           $sql="CALL `SP_SUBTAREA_HABILITACION`('$idSubTarea','$codigo','$idCreador');";

           return ejecutarConsulta($sql);
       }
      public function ValidarSubTarea($SubTareanom,$idSubTarea){
          $sql="";
          if($idSubTarea=='' || $idSubTarea==null || empty($idSubTarea)){
			   $sql="SELECT * FROM subtarea WHERE Descripcion='$SubTareanom';";
          }else{
             $sql="SELECT * FROM subtarea WHERE idSubTarea!='$idSubTarea' and NombreSubTarea='$SubTareanom';";
          }
          return validarDatos($sql);
      }
      public function RegistroSubTarea($idSubTarea,$SubTareaDescripcion,$SubTareaHoras,$SubTareaEstado,$SubTareaTarea,$login_idLog){
        $sql="";

        if($idSubTarea=="" || $idSubTarea==null || empty($idSubTarea)){
             $sql="CALL  `SP_SUBTAREA_REGISTRO`('$SubTareaDescripcion','$SubTareaHoras','$SubTareaTarea','$SubTareaEstado','$login_idLog');";

        }else{

           $sql="CALL  `SP_SUBTAREA_ACTUALIZAR`('$SubTareaDescripcion','$SubTareaHoras','$SubTareaTarea','$SubTareaEstado','$login_idLog','$idSubTarea');";
        }

         return ejecutarConsulta($sql);
      }

		public function Recuperar_SubTarea($idSubTarea){
			$sql="CALL `SP_SUBTAREA_RECUPERAR`('$idSubTarea');";
			return ejecutarConsultaSimpleFila($sql);
		}
       public function RecuperarFecha($idActividad){
			$sql="CALL `SP_SUBTAREA_RECUPERAR_FECHA`('$idActividad');";
			return ejecutarConsultaSimpleFila($sql);
		}

   }

?>
