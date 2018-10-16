<?php
   session_start();
   require_once "../../modelo/Mantenimiento/MCliente.php";
   require_once "../../modelo/General/MGeneral.php";
   $mantenimiento = new MCliente();
   $general = new MGeneral();


	$idCliente=isset($_POST["idCliente"])?limpiarCadena($_POST["idCliente"]):"";
	$ClienteNombre=isset($_POST["ClienteNombre"])?limpiarCadena($_POST["ClienteNombre"]):"";
	$ClienteContacto=isset($_POST["ClienteContacto"])?limpiarCadena($_POST["ClienteContacto"]):"";
	$ClienteDireccion=isset($_POST["ClienteDireccion"])?limpiarCadena($_POST["ClienteDireccion"]):"";
	$ClienteEstado=isset($_POST["ClienteEstado"])?limpiarCadena($_POST["ClienteEstado"]):"";

	$login_idLog=$_SESSION['idUsuario'];

    function BuscarEstado($reg){
        if($reg->Estado_idEstado=='1' || $reg->Estado_idEstado==1 ){
            return '<div class="badge badge-success">'.$reg->nombreEstado.'</div>';
        }elseif($reg->Estado_idEstado=='2' || $reg->Estado_idEstado==2){
            return '<div class="badge badge-danger">'.$reg->nombreEstado.'</div>';
        }else{
             return '<div class="badge badge-primary">'.$reg->nombreEstado.'</div>';
        }
    }
    function BuscarAccion($reg){
        if($reg->Estado_idEstado==1 || $reg->Estado_idEstado==2 ){
            return '
            <button type="button" title="Editar" class="btn btn-warning btn-sm" onclick="EditarCliente('.$reg->idCliente.')"><i class="fa fa-edit"></i></button>
               <button type="button"  title="Eliminar" class="btn btn-danger btn-sm" onclick="EliminarCliente('.$reg->idCliente.')"><i class="fa fa-trash"></i></button>
               ';
        }elseif($reg->Estado_idEstado==4){
            return '<button type="button"  title="Habilitar" class="btn btn-info btn-sm" onclick="HabilitarCliente('.$reg->idCliente.')"><i class="fa fa-sync"></i></button>';
        }
    }

   switch($_GET['op']){
        case 'AccionCliente':
		 	$rspta=array("Error"=>false,"Mensaje"=>"","Registro"=>false);
         if(empty($idCliente)){

                /*--  validar si el numero de la factura ya se encuentra emitido  --*/
                $validarCliente=$mantenimiento->ValidarCliente($ClienteNombre,$idCliente);
                if($validarCliente>0){
                    $rspta["Mensaje"].="El Cliente ya se encuentra Registrado ";
                    $rspta["Error"]=true;
                }
                if($rspta["Error"]){
                    $rspta["Mensaje"].="Por estas razones no se puede Registrar el Cliente.";
                }else{
                    $RespuestaRegistro=$mantenimiento->RegistroCliente($idCliente,$ClienteNombre,$ClienteDireccion,$ClienteContacto,$ClienteEstado,$login_idLog);
                    if($RespuestaRegistro){
                        $rspta["Registro"]=true;
                        $rspta["Mensaje"]="Cliente se registro Correctamente.";
                    }else{
                        $rspta["Registro"]=false;
                        $rspta["Mensaje"]="Cliente no se puede registrar comuniquese con el area de soporte.";
                    }
                }
            }else{

                 $validarCliente=$mantenimiento->ValidarCliente($ClienteNombre,$idCliente);
                if($validarCliente>0){
                    $rspta["Mensaje"].="El Cliente ya se encuentra Registrado ";
                    $rspta["Error"]=true;
                }
                if($rspta["Error"]){
                    $rspta["Mensaje"].="Por estas razones no se puede Registrar el Cliente.";
                }else{

                    $RespuestaRegistro=$mantenimiento->RegistroCliente($idCliente,$ClienteNombre,$ClienteDireccion,$ClienteContacto,$ClienteEstado,$login_idLog);
                    if($RespuestaRegistro){
                        $rspta["Registro"]=true;
                        $rspta["Mensaje"]="Cliente se Actualizo Correctamente.";
                    }else{
                        $rspta["Registro"]=false;
                        $rspta["Mensaje"]="Cliente no se puede Actualizar comuniquese con el area de soporte.";
                    }
                }
            }

         echo json_encode($rspta);
       break;
      case 'listar_estados':

      		$rpta = $general->Listar_Estados(1);
         	while ($reg = $rpta->fetch_object()){
					echo '<option   value=' . $reg->idEstado . '>' . $reg->nombreEstado . '</option>';
         	}
       break;

		case 'Listar_Cliente':

         $rspta=$mantenimiento->Listar_Cliente();
         $data= array();
         while ($reg=$rspta->fetch_object()){
         $data[]=array(
               "0"=>'',
               "1"=>BuscarEstado($reg),
               "2"=>$reg->NombreCliente,
               "3"=>$reg->Contacto,
               "4"=>$reg->fechaRegistro,
               "5"=>BuscarAccion($reg)
            );
         }
         $results = array(
            "sEcho"=>1, //Información para el datatables
            "iTotalRecords"=>count($data), //enviamos el total registros al datatable
            "iTotalDisplayRecords"=>count($data), //enviamos el total registros a visualizar
            "aaData"=>$data);
         echo json_encode($results);
      break;

      case 'Eliminar_Cliente':
         $rspta = array("Mensaje"=>"","Eliminar"=>false,"Error"=>false);
         /*------ Cuando el usuario ya se esta facturando, ya no se puede eliminar --------*/
         $rspta['Eliminar']=$mantenimiento->Eliminar_Cliente($idCliente,1,$login_idLog);

         $rspta['Eliminar']?$rspta['Mensaje']="Cliente Eliminado.":$rspta['Mensaje']="Cliente no se pudo eliminar comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;

      case 'Recuperar_Cliente':
         $rspta = array("Mensaje"=>"","Eliminar"=>false,"Error"=>false);
         /*------ Cuando el usuario ya se esta facturando, ya no se puede eliminar --------*/
         $rspta['Eliminar']=$mantenimiento->Eliminar_Cliente($idCliente,2,$login_idLog);

         $rspta['Eliminar']?$rspta['Mensaje']="Cliente Restablecido.":$rspta['Mensaje']="Cliente no se pudo Restablecer comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;

      case 'RecuperarInformacion_Cliente':
			$rspta=$mantenimiento->Recuperar_Cliente($idCliente);
         echo json_encode($rspta);
      break;


   }


?>
