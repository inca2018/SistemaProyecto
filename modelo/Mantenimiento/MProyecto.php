<?php
   require_once '../../config/config.php';


   class MProyecto{

      public function __construct(){
      }

	  public function Listar_Proyecto(){
           $sql="CALL `SP_PROYECTO_LISTAR`();";
           return ejecutarConsulta($sql);
       }
      public function Eliminar_Proyecto($idProyecto,$codigo,$idCreador){
           $sql="CALL `SP_PROYECTO_HABILITACION`('$idProyecto','$codigo','$idCreador');";

           return ejecutarConsulta($sql);
       }
      public function ValidarProyecto($Proyectonom,$idProyecto){
          $sql="";
          if($idProyecto=='' || $idProyecto==null || empty($idProyecto)){
			   $sql="SELECT * FROM proyecto WHERE NombreProyecto='$Proyectonom';";
          }else{
             $sql="SELECT * FROM proyecto WHERE idProyecto!='$idProyecto' and NombreProyecto='$Proyectonom';";
          }
          return validarDatos($sql);
      }
      public function RegistroProyecto($idProyecto,$ProyectoNombre,$ProyectoCliente,$ProyectoDescripcion,$ProyectoEstado,$login_idLog){
        $sql="";

        if($idProyecto=="" || $idProyecto==null || empty($idProyecto)){
             $sql="CALL `SP_PROYECTO_REGISTRO`('$ProyectoNombre','$ProyectoCliente','$ProyectoDescripcion','$ProyectoEstado','$login_idLog');";

        }else{

           $sql="CALL `SP_PROYECTO_ACTUALIZAR`('$idProyecto','$ProyectoNombre','$ProyectoCliente','$ProyectoDescripcion','$ProyectoEstado','$login_idLog');";
        }

         return ejecutarConsulta($sql);
      }

		public function Recuperar_Proyecto($idProyecto){
			$sql="CALL `SP_PROYECTO_RECUPERAR`('$idProyecto');";
			return ejecutarConsultaSimpleFila($sql);
		}


   }

?>
