<?php
   session_start();
   require_once "../../modelo/Mantenimiento/MSubTarea.php";
   require_once "../../modelo/General/MGeneral.php";
   $mantenimiento = new MSubTarea();
   $general = new MGeneral();


	$idSubTarea=isset($_POST["idSubTarea"])?limpiarCadena($_POST["idSubTarea"]):"";

	$SubTareaDescripcion=isset($_POST["SubTareaDescripcion"])?limpiarCadena($_POST["SubTareaDescripcion"]):"";
    $SubTareaHoras=isset($_POST["SubTareaHoras"])?limpiarCadena($_POST["SubTareaHoras"]):"";

	$SubTareaEstado=isset($_POST["SubTareaEstado"])?limpiarCadena($_POST["SubTareaEstado"]):"";

    $SubTareaTarea=isset($_POST["idTarea"])?limpiarCadena($_POST["idTarea"]):"";

	$login_idLog=$_SESSION['idUsuario'];

   $idTarea=isset($_POST["idTareaE"])?limpiarCadena($_POST["idTareaE"]):"";


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

            <button type="button" title="Editar" class="btn btn-warning btn-sm" onclick="EditarSubTarea('.$reg->idSubTarea.')"><i class="fa fa-edit"></i></button>
               <button type="button"  title="Eliminar" class="btn btn-danger btn-sm" onclick="EliminarSubTarea('.$reg->idSubTarea.')"><i class="fa fa-trash"></i></button>
               ';
        }elseif($reg->Estado_idEstado==4){
            return '<button type="button"  title="Habilitar" class="btn btn-info btn-sm" onclick="HabilitarSubTarea('.$reg->idSubTarea.')"><i class="fa fa-sync"></i></button>';
        }
    }

   switch($_GET['op']){
        case 'AccionSubTarea':
		 	$rspta=array("Error"=>false,"Mensaje"=>"","Registro"=>false);
         if(empty($idSubTarea)){


                if($rspta["Error"]){
                    $rspta["Mensaje"].="Por estas razones no se puede Registrar el SubTarea.";
                }else{
                    $RespuestaRegistro=$mantenimiento->RegistroSubTarea($idSubTarea,$SubTareaDescripcion,$SubTareaHoras,$SubTareaEstado,$SubTareaTarea,$login_idLog);
                    if($RespuestaRegistro){
                        $rspta["Registro"]=true;
                        $rspta["Mensaje"]="SubTarea se registro Correctamente.";
                    }else{
                        $rspta["Registro"]=false;
                        $rspta["Mensaje"]="SubTarea no se puede registrar comuniquese con el area de soporte.";
                    }
                }
            }else{


                if($rspta["Error"]){
                    $rspta["Mensaje"].="Por estas razones no se puede Registrar el SubTarea.";
                }else{

                    $RespuestaRegistro=$mantenimiento->RegistroSubTarea($idSubTarea,$SubTareaDescripcion,$SubTareaHoras,$SubTareaEstado,$SubTareaTarea,$login_idLog);
                    if($RespuestaRegistro){
                        $rspta["Registro"]=true;
                        $rspta["Mensaje"]="SubTarea se Actualizo Correctamente.";
                    }else{
                        $rspta["Registro"]=false;
                        $rspta["Mensaje"]="SubTarea no se puede Actualizar comuniquese con el area de soporte.";
                    }
                }
            }

         echo json_encode($rspta);
       break;
      case 'listar_estados':

      		$rpta = $general->Listar_Estados(3);
         	while ($reg = $rpta->fetch_object()){
					echo '<option   value=' . $reg->idEstado . '>' . $reg->nombreEstado . '</option>';
         	}
       break;
      case 'listar_personas':

      		$rpta = $general->Listar_Personas_Todo();
             echo '<option value="">--SELECCIONAR--</option>';
         	while ($reg = $rpta->fetch_object()){
					echo '<option   value=' . $reg->idPersona . '>' . $reg->nombrePersona.' '.$reg->apellidoPaterno.' '.$reg->apellidoMaterno. '</option>';
         	}
       break;

		case 'Listar_SubTarea':

         $rspta=$mantenimiento->Listar_SubTarea($idTarea);
         $data= array();
         while ($reg=$rspta->fetch_object()){
         $data[]=array(
               "0"=>'',
               "1"=>BuscarEstado($reg),
               "2"=>$reg->Descripcion,
               "3"=>$reg->CantidadHora,
               "4"=>$reg->NombreTarea,
               "5"=>$reg->fechaRegistro,
               "6"=>BuscarAccion($reg)
            );
         }
         $results = array(
            "sEcho"=>1, //Información para el datatables
            "iTotalRecords"=>count($data), //enviamos el total registros al datatable
            "iTotalDisplayRecords"=>count($data), //enviamos el total registros a visualizar
            "aaData"=>$data);
         echo json_encode($results);
      break;

      case 'Eliminar_SubTarea':
         $rspta = array("Mensaje"=>"","Eliminar"=>false,"Error"=>false);
         /*------ Cuando el usuario ya se esta facturando, ya no se puede eliminar --------*/
         $rspta['Eliminar']=$mantenimiento->Eliminar_SubTarea($idSubTarea,1,$login_idLog);

         $rspta['Eliminar']?$rspta['Mensaje']="SubTarea Eliminado.":$rspta['Mensaje']="SubTarea no se pudo eliminar comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;

      case 'Recuperar_SubTarea':
         $rspta = array("Mensaje"=>"","Eliminar"=>false,"Error"=>false);
         /*------ Cuando el usuario ya se esta facturando, ya no se puede eliminar --------*/
         $rspta['Eliminar']=$mantenimiento->Eliminar_SubTarea($idSubTarea,2,$login_idLog);

         $rspta['Eliminar']?$rspta['Mensaje']="SubTarea Restablecido.":$rspta['Mensaje']="SubTarea no se pudo Restablecer comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;

      case 'RecuperarInformacion_SubTarea':
			$rspta=$mantenimiento->Recuperar_SubTarea($idSubTarea);
         echo json_encode($rspta);
      break;


   }


?>
