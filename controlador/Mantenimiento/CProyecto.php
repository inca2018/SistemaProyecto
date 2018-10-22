<?php
   session_start();
   require_once "../../modelo/Mantenimiento/MProyecto.php";
   require_once "../../modelo/General/MGeneral.php";
   $mantenimiento = new MProyecto();
   $general = new MGeneral();


	$idProyecto=isset($_POST["idProyecto"])?limpiarCadena($_POST["idProyecto"]):"";
	$ProyectoNombre=isset($_POST["ProyectoNombre"])?limpiarCadena($_POST["ProyectoNombre"]):"";
	$ProyectoCliente=isset($_POST["ProyectoCliente"])?limpiarCadena($_POST["ProyectoCliente"]):"";
	$ProyectoDescripcion=isset($_POST["ProyectoDescripcion"])?limpiarCadena($_POST["ProyectoDescripcion"]):"";
	$ProyectoEstado=isset($_POST["ProyectoEstado"])?limpiarCadena($_POST["ProyectoEstado"]):"";
    $ProyectoJefe=isset($_POST["ProyectoJefe"])?limpiarCadena($_POST["ProyectoJefe"]):"";


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
            <button type="button"  title="Actividades" class="btn btn-info btn-sm" onclick="Tareas('.$reg->idProyecto.')"><i class="fa fa-tasks"></i></button>
            <button type="button" title="Editar" class="btn btn-warning btn-sm" onclick="EditarProyecto('.$reg->idProyecto.')"><i class="fa fa-edit"></i></button>
               <button type="button"  title="Eliminar" class="btn btn-danger btn-sm" onclick="EliminarProyecto('.$reg->idProyecto.')"><i class="fa fa-trash"></i></button>
               ';
        }elseif($reg->Estado_idEstado==4){
            return '<button type="button"  title="Habilitar" class="btn btn-info btn-sm" onclick="HabilitarProyecto('.$reg->idProyecto.')"><i class="fa fa-sync"></i></button>';
        }
    }

   switch($_GET['op']){
        case 'AccionProyecto':
		 	$rspta=array("Error"=>false,"Mensaje"=>"","Registro"=>false);
         if(empty($idProyecto)){

                /*--  validar si el numero de la factura ya se encuentra emitido  --*/
                $validarProyecto=$mantenimiento->ValidarProyecto($ProyectoNombre,$idProyecto);
                if($validarProyecto>0){
                    $rspta["Mensaje"].="El Proyecto ya se encuentra Registrado ";
                    $rspta["Error"]=true;
                }
                if($rspta["Error"]){
                    $rspta["Mensaje"].="Por estas razones no se puede Registrar el Proyecto.";
                }else{
                    $RespuestaRegistro=$mantenimiento->RegistroProyecto($idProyecto,$ProyectoNombre,$ProyectoCliente,$ProyectoDescripcion,$ProyectoEstado,$login_idLog,$ProyectoJefe);
                    if($RespuestaRegistro){
                        $rspta["Registro"]=true;
                        $rspta["Mensaje"]="Proyecto se registro Correctamente.";
                    }else{
                        $rspta["Registro"]=false;
                        $rspta["Mensaje"]="Proyecto no se puede registrar comuniquese con el area de soporte.";
                    }
                }
            }else{

                 $validarProyecto=$mantenimiento->ValidarProyecto($ProyectoNombre,$idProyecto);
                if($validarProyecto>0){
                    $rspta["Mensaje"].="El Proyecto ya se encuentra Registrado ";
                    $rspta["Error"]=true;
                }
                if($rspta["Error"]){
                    $rspta["Mensaje"].="Por estas razones no se puede Registrar el Proyecto.";
                }else{

                    $RespuestaRegistro=$mantenimiento->RegistroProyecto($idProyecto,$ProyectoNombre,$ProyectoCliente,$ProyectoDescripcion,$ProyectoEstado,$login_idLog,$ProyectoJefe);
                    if($RespuestaRegistro){
                        $rspta["Registro"]=true;
                        $rspta["Mensaje"]="Proyecto se Actualizo Correctamente.";
                    }else{
                        $rspta["Registro"]=false;
                        $rspta["Mensaje"]="Proyecto no se puede Actualizar comuniquese con el area de soporte.";
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
       case 'listar_clientes':

      		$rpta = $general->Listar_Clientes();
             echo '<option value="">--SELECCIONAR--</option>';
         	while ($reg = $rpta->fetch_object()){
					echo '<option   value=' . $reg->idCliente . '>' . $reg->NombreCliente . '</option>';
         	}
       break;
     case 'listar_jefe_proyecto':
      		$rpta = $general->RecuperarJefesProyecto();
             echo '<option value="">--SELECCIONAR--</option>';
         	while ($reg = $rpta->fetch_object()){
					echo '<option   value=' . $reg->idPersona . '>' . $reg->NombreJefeProyecto . '</option>';
         	}
       break;

		case 'Listar_Proyecto':

         $rspta=$mantenimiento->Listar_Proyecto();
         $data= array();
         while ($reg=$rspta->fetch_object()){
         $data[]=array(
               "0"=>'',
               "1"=>BuscarEstado($reg),
               "2"=>$reg->NombreProyecto,
               "3"=>"S/. ".number_format($reg->CostoTotal,2),
               "4"=>$reg->NombreCliente,
               "5"=>$reg->NombreJefe,
               "6"=>$reg->CantidadTarea,
               "7"=>$reg->fechaInicio." - ".$reg->fechaFin,
               "8"=>BuscarAccion($reg)
            );
         }
         $results = array(
            "sEcho"=>1, //Información para el datatables
            "iTotalRecords"=>count($data), //enviamos el total registros al datatable
            "iTotalDisplayRecords"=>count($data), //enviamos el total registros a visualizar
            "aaData"=>$data);
         echo json_encode($results);
      break;

      case 'Eliminar_Proyecto':
         $rspta = array("Mensaje"=>"","Eliminar"=>false,"Error"=>false);
         /*------ Cuando el usuario ya se esta facturando, ya no se puede eliminar --------*/
         $rspta['Eliminar']=$mantenimiento->Eliminar_Proyecto($idProyecto,1,$login_idLog);

         $rspta['Eliminar']?$rspta['Mensaje']="Proyecto Eliminado.":$rspta['Mensaje']="Proyecto no se pudo eliminar comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;

      case 'Recuperar_Proyecto':
         $rspta = array("Mensaje"=>"","Eliminar"=>false,"Error"=>false);
         /*------ Cuando el usuario ya se esta facturando, ya no se puede eliminar --------*/
         $rspta['Eliminar']=$mantenimiento->Eliminar_Proyecto($idProyecto,2,$login_idLog);

         $rspta['Eliminar']?$rspta['Mensaje']="Proyecto Restablecido.":$rspta['Mensaje']="Proyecto no se pudo Restablecer comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;

      case 'RecuperarInformacion_Proyecto':
			$rspta=$mantenimiento->Recuperar_Proyecto($idProyecto);
         echo json_encode($rspta);
      break;


   }


?>
