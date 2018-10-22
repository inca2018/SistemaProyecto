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
      public function RegistroSubTarea($idSubTarea,$SubTareaDescripcion,$fechaInicio,$fechaFin,$SubTareaEstado,$idActividad,$idProyecto,$login_idLog,$tareaNombre){
        $sql="";

        if($idSubTarea=="" || $idSubTarea==null || empty($idSubTarea)){
             $sql="CALL  `SP_SUBTAREA_REGISTRO`('$SubTareaDescripcion','$fechaInicio','$fechaFin','$SubTareaEstado','$idActividad','$idProyecto','$login_idLog','$tareaNombre');";
        }else{
           $sql="CALL  `SP_SUBTAREA_ACTUALIZAR`('$idSubTarea','$SubTareaDescripcion','$fechaInicio','$fechaFin','$SubTareaEstado','$idActividad','$idProyecto','$login_idLog','$tareaNombre');";
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
