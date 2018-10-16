<?php
   require_once '../../config/config.php';


   class MCliente{

      public function __construct(){
      }

	  public function Listar_Cliente(){
           $sql="CALL `SP_CLIENTE_LISTAR`();";
           return ejecutarConsulta($sql);
       }
      public function Eliminar_Cliente($idCliente,$codigo,$idCreador){
           $sql="CALL `SP_CLIENTE_HABILITACION`('$idCliente','$codigo','$idCreador');";

           return ejecutarConsulta($sql);
       }
      public function ValidarCliente($Clientenom,$idCliente){
          $sql="";
          if($idCliente=='' || $idCliente==null || empty($idCliente)){
			   $sql="SELECT * FROM Cliente WHERE NombreCliente='$Clientenom';";
          }else{
             $sql="SELECT * FROM Cliente WHERE idCliente!='$idCliente' and NombreCliente='$Clientenom';";
          }
          return validarDatos($sql);
      }
      public function RegistroCliente($idCliente,$ClienteNombre,$ClienteDireccion,$ClienteContacto,$ClienteEstado,$login_idLog){
        $sql="";

        if($idCliente=="" || $idCliente==null || empty($idCliente)){
             $sql="CALL `SP_CLIENTE_REGISTRO`('$ClienteNombre','$ClienteDireccion','$ClienteContacto','$ClienteEstado','$login_idLog');";

        }else{

           $sql="CALL `SP_CLIENTE_ACTUALIZAR`('$ClienteNombre','$ClienteDireccion','$ClienteContacto','$ClienteEstado','$login_idLog','$idCliente');";
        }

         return ejecutarConsulta($sql);
      }

		public function Recuperar_Cliente($idCliente){
			$sql="CALL `SP_CLIENTE_RECUPERAR`('$idCliente');";
			return ejecutarConsultaSimpleFila($sql);
		}


   }

?>
