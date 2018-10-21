<?php
   require_once '../../config/config.php';

   class MGeneral{

      public function __construct(){
      }

        public function Listar_Estados($tipo){
         $sql="CALL `SP_ESTADO_LISTAR`('$tipo');";
         return ejecutarConsulta($sql);
       }
        public function Listar_Persona_Todo(){
         $sql="CALL `SP_PERSONA_LISTAR_TODO`(); ";
         return ejecutarConsulta($sql);
       }

       public function Listar_Personas_Sin_Usuario(){
         $sql="CALL `SP_PERSONAS_LISTAR_SIN_USUARIOS`();";
         return ejecutarConsulta($sql);
       }
		public function Listar_Personas_Todo(){
         $sql="select * from persona";
         return ejecutarConsulta($sql);
       }
        public function Listar_Perfiles(){
         $sql="CALL `SP_LISTAR_PERFILES`();";
         return ejecutarConsulta($sql);
       }
       public function Listar_Niveles(){
         $sql="CALL `SP_LISTAR_NIVELES`();";
         return ejecutarConsulta($sql);
       }
        public function Listar_Grados(){
         $sql="CALL `SP_LISTAR_GRADOS`();";
         return ejecutarConsulta($sql);
       }
        public function Listar_Secciones(){
         $sql="CALL `SP_LISTAR_SECCIONES`();";
         return ejecutarConsulta($sql);
       }

       public function Listar_TipoTarjeta(){
           $sql="CALL `SP_TIPO_TARJETA_LISTAR`();";
           return  ejecutarConsulta($sql);
       }
         public function Listar_TipoPago(){
           $sql="SELECT * FROM tipopago";
           return  ejecutarConsulta($sql);
       }

     public function Listar_Clientes(){
          $sql="CALL `SP_CLIENTE_LISTAR`();";
         return ejecutarConsulta($sql);
       }
      public function Listar_Empleados(){
          $sql="SELECT per.idPersona,CONCAT(per.nombrePersona,' ',per.apellidoPaterno,' ',per.apellidoMaterno) as PersonaNombre FROM usuario u INNER JOIN persona per ON per.idPersona=u.Persona_idPersona WHERE u.Perfil_idPerfil=6";
         return ejecutarConsulta($sql);
       }

        public function Listar_Proyectos(){
          $sql="SELECT pro.idProyecto,pro.NombreProyecto FROM proyecto pro";
         return ejecutarConsulta($sql);
       }

       public function Recuperar_Indicadores($idProyecto){
			$sql="CALL `SP_RECUPERAR_INDICADORES`('$idProyecto');";
			return ejecutarConsultaSimpleFila($sql);
		}

        public function RecuperarJefesProyecto(){
			$sql="CALL `SP_PERSONAS_LISTAR_JEFE_PROYECTO`();";
			return ejecutarConsulta($sql);
		}

   }

?>
