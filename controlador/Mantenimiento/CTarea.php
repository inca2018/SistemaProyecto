<?php
   session_start();
   require_once "../../modelo/Mantenimiento/MTarea.php";
   require_once "../../modelo/General/MGeneral.php";
   $mantenimiento = new MTarea();
   $general = new MGeneral();


	$idTarea=isset($_POST["idTarea"])?limpiarCadena($_POST["idTarea"]):"";
	$TareaNombre=isset($_POST["TareaNombre"])?limpiarCadena($_POST["TareaNombre"]):"";
	$TareaPersona=isset($_POST["TareaPersona"])?limpiarCadena($_POST["TareaPersona"]):"";
	$TareaDescripcion=isset($_POST["TareaDescripcion"])?limpiarCadena($_POST["TareaDescripcion"]):"";
    $TareaHoras=isset($_POST["TareaHoras"])?limpiarCadena($_POST["TareaHoras"]):"";
    $TareaCosto=isset($_POST["TareaCosto"])?limpiarCadena($_POST["TareaCosto"]):"";
	$TareaEstado=isset($_POST["TareaEstado"])?limpiarCadena($_POST["TareaEstado"]):"";
    $TareaProyecto=isset($_POST["idProyecto"])?limpiarCadena($_POST["idProyecto"]):"";

	$login_idLog=$_SESSION['idUsuario'];

   $idProyecto=isset($_POST["idProyectolista"])?limpiarCadena($_POST["idProyectolista"]):"";


   function BuscarEstado($reg){
        if($reg->Estado_idEstado=='1' || $reg->Estado_idEstado==1 ){
            return '<div class="badge badge-success">'.$reg->nombreEstado.'</div>';
        }elseif($reg->Estado_idEstado=='2' || $reg->Estado_idEstado==2){
            return '<div class="badge badge-danger">'.$reg->nombreEstado.'</div>';
        }elseif($reg->Estado_idEstado=='3' || $reg->Estado_idEstado==3){
            return '<div class="badge badge-success">'.$reg->nombreEstado.'</div>';
        }elseif($reg->Estado_idEstado=='4' || $reg->Estado_idEstado==4){
            return '<div class="badge badge-danger">'.$reg->nombreEstado.'</div>';
        }elseif($reg->Estado_idEstado=='5' || $reg->Estado_idEstado==5){
            return '<div class="badge badge-warning">'.$reg->nombreEstado.'</div>';
        }elseif($reg->Estado_idEstado=='6' || $reg->Estado_idEstado==6){
            return '<div class="badge badge-purple">'.$reg->nombreEstado.'</div>';
        }elseif($reg->Estado_idEstado=='7' || $reg->Estado_idEstado==7){
            return '<div class="badge badge-info">'.$reg->nombreEstado.'</div>';
        }else{
             return '<div class="badge badge-danger">'.$reg->nombreEstado.'</div>';
        }
    }
    function BuscarAccion($reg){
        if($reg->Estado_idEstado==1 || $reg->Estado_idEstado==2 ){
            return '
            <button type="button"  title="SubTareas" class="btn btn-info btn-sm" onclick="SubTareas('.$reg->idTarea.')"><i class="fa fa-tasks"></i></button>
            <button type="button" title="Editar" class="btn btn-warning btn-sm" onclick="EditarTarea('.$reg->idTarea.')"><i class="fa fa-edit"></i></button>
               <button type="button"  title="Eliminar" class="btn btn-danger btn-sm" onclick="EliminarTarea('.$reg->idTarea.')"><i class="fa fa-trash"></i></button>
               ';
        }elseif($reg->Estado_idEstado==4){
            return '<button type="button"  title="Habilitar" class="btn btn-info btn-sm" onclick="HabilitarTarea('.$reg->idTarea.')"><i class="fa fa-sync"></i></button>';
        }
    }

   switch($_GET['op']){
        case 'AccionTarea':
		 	$rspta=array("Error"=>false,"Mensaje"=>"","Registro"=>false);
         if(empty($idTarea)){

                /*--  validar si el numero de la factura ya se encuentra emitido  --*/
                $validarTarea=$mantenimiento->ValidarTarea($TareaNombre,$idTarea);
                if($validarTarea>0){
                    $rspta["Mensaje"].="El Tarea ya se encuentra Registrado ";
                    $rspta["Error"]=true;
                }
                if($rspta["Error"]){
                    $rspta["Mensaje"].="Por estas razones no se puede Registrar el Tarea.";
                }else{
                    $RespuestaRegistro=$mantenimiento->RegistroTarea($idTarea,$TareaNombre,$TareaDescripcion,$TareaHoras,$TareaCosto,$TareaProyecto,$TareaPersona,$TareaEstado,$login_idLog);
                    if($RespuestaRegistro){
                        $rspta["Registro"]=true;
                        $rspta["Mensaje"]="Tarea se registro Correctamente.";
                    }else{
                        $rspta["Registro"]=false;
                        $rspta["Mensaje"]="Tarea no se puede registrar comuniquese con el area de soporte.";
                    }
                }
            }else{

                 $validarTarea=$mantenimiento->ValidarTarea($TareaNombre,$idTarea);
                if($validarTarea>0){
                    $rspta["Mensaje"].="El Tarea ya se encuentra Registrado ";
                    $rspta["Error"]=true;
                }
                if($rspta["Error"]){
                    $rspta["Mensaje"].="Por estas razones no se puede Registrar el Tarea.";
                }else{

                    $RespuestaRegistro=$mantenimiento->RegistroTarea($idTarea,$TareaNombre,$TareaDescripcion,$TareaHoras,$TareaCosto,$TareaProyecto,$TareaPersona,$TareaEstado,$login_idLog);
                    if($RespuestaRegistro){
                        $rspta["Registro"]=true;
                        $rspta["Mensaje"]="Tarea se Actualizo Correctamente.";
                    }else{
                        $rspta["Registro"]=false;
                        $rspta["Mensaje"]="Tarea no se puede Actualizar comuniquese con el area de soporte.";
                    }
                }
            }

         echo json_encode($rspta);
       break;
      case 'listar_estados':

      		$rpta = $general->Listar_Estados(2);
         	while ($reg = $rpta->fetch_object()){
					echo '<option   value=' . $reg->idEstado . '>' . $reg->nombreEstado . '</option>';
         	}
       break;
      case 'listar_personas':

      		$rpta = $general->Listar_Empleados();
             echo '<option value="">--SELECCIONAR--</option>';
         	while ($reg = $rpta->fetch_object()){
					echo '<option   value=' . $reg->idPersona . '>' . $reg->PersonaNombre.'</option>';
         	}
       break;

		case 'Listar_Tarea':

         $rspta=$mantenimiento->Listar_Tarea($idProyecto);
         $data= array();
         while ($reg=$rspta->fetch_object()){
         $data[]=array(
               "0"=>'',
               "1"=>BuscarEstado($reg),
               "2"=>$reg->NombreTarea,
               "3"=>$reg->nomPersona,
               "4"=>$reg->NombreProyecto,
               "5"=>$reg->CantidadHoras,
               "6"=>"S/. ".number_format($reg->Costo,2),
               "7"=>$reg->CantiSubtareas,
               "8"=>$reg->fechaRegistro,
               "9"=>BuscarAccion($reg)
            );
         }
         $results = array(
            "sEcho"=>1, //Información para el datatables
            "iTotalRecords"=>count($data), //enviamos el total registros al datatable
            "iTotalDisplayRecords"=>count($data), //enviamos el total registros a visualizar
            "aaData"=>$data);
         echo json_encode($results);
      break;

      case 'Eliminar_Tarea':
         $rspta = array("Mensaje"=>"","Eliminar"=>false,"Error"=>false);
         /*------ Cuando el usuario ya se esta facturando, ya no se puede eliminar --------*/
         $rspta['Eliminar']=$mantenimiento->Eliminar_Tarea($idTarea,1,$login_idLog);

         $rspta['Eliminar']?$rspta['Mensaje']="Tarea Eliminado.":$rspta['Mensaje']="Tarea no se pudo eliminar comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;

      case 'Recuperar_Tarea':
         $rspta = array("Mensaje"=>"","Eliminar"=>false,"Error"=>false);
         /*------ Cuando el usuario ya se esta facturando, ya no se puede eliminar --------*/
         $rspta['Eliminar']=$mantenimiento->Eliminar_Tarea($idTarea,2,$login_idLog);

         $rspta['Eliminar']?$rspta['Mensaje']="Tarea Restablecido.":$rspta['Mensaje']="Tarea no se pudo Restablecer comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;

      case 'RecuperarInformacion_Tarea':
			$rspta=$mantenimiento->Recuperar_Tarea($idTarea);
         echo json_encode($rspta);
      break;


   }


?>
