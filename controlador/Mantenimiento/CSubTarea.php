<?php
   session_start();
   require_once "../../modelo/Mantenimiento/MSubTarea.php";
   require_once "../../modelo/General/MGeneral.php";
   $mantenimiento = new MSubTarea();
   $general = new MGeneral();


	$idSubTarea=isset($_POST["idSubTarea"])?limpiarCadena($_POST["idSubTarea"]):"";

	$SubTareaDescripcion=isset($_POST["SubTareaDescripcion"])?limpiarCadena($_POST["SubTareaDescripcion"]):"";

	$SubTareaEstado=isset($_POST["SubTareaEstado"])?limpiarCadena($_POST["SubTareaEstado"]):"";

    $SubTareaTarea=isset($_POST["idTarea"])?limpiarCadena($_POST["idTarea"]):"";

	$login_idLog=$_SESSION['idUsuario'];

   $idTarea=isset($_POST["idTareaE"])?limpiarCadena($_POST["idTareaE"]):"";
   $idActividad=isset($_POST["idActividad"])?limpiarCadena($_POST["idActividad"]):"";
   $idProyecto=isset($_POST["idProyecto"])?limpiarCadena($_POST["idProyecto"]):"";

   $fechaInicio=isset($_POST["inicio"])?limpiarCadena($_POST["inicio"]):"";
   $fechaFin=isset($_POST["fin"])?limpiarCadena($_POST["fin"]):"";

   $tareaNombre=isset($_POST["TareaNombre"])?limpiarCadena($_POST["TareaNombre"]):"";


   $date = str_replace('/', '-', $fechaInicio);
   $fechaInicio = date("Y-m-d", strtotime($date));

   $date = str_replace('/', '-', $fechaFin);
   $fechaFin = date("Y-m-d", strtotime($date));

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
		 $resp="";
        if($reg->Estado_idEstado==1 || $reg->Estado_idEstado==2 || $reg->Estado_idEstado==5 || $reg->Estado_idEstado==6 || $reg->Estado_idEstado==7){
            $resp.= '

            <button type="button" title="Editar" class="btn btn-warning btn-sm" onclick="EditarSubTarea('.$reg->idTarea.')"><i class="fa fa-edit"></i></button>
               <button type="button"  title="Eliminar" class="btn btn-danger btn-sm" onclick="EliminarSubTarea('.$reg->idTarea.')"><i class="fa fa-trash"></i></button>
               ';
        }elseif($reg->Estado_idEstado==4 || $reg->Estado_idEstado==8){
            $resp.= '<button type="button"  title="Reprogramar" class="btn btn-info btn-sm" onclick="HabilitarSubTarea('.$reg->idTarea.')"><i class="fa fa-sync"></i></button>';
        }

		 if ($reg->Documento != "" || $reg->Documento != null) {
			  $resp .= '<a href="../../vista/DocumentoTarea/'. $reg->Documento . '" target="_blank" class="btn btn-danger btn-sm ml-1"><i class="fas fa-file-pdf"></i></a>';
		 }

		 return $resp;
    }

   switch($_GET['op']){
        case 'AccionSubTarea':
		 	$rspta=array("Error"=>false,"Mensaje"=>"","Registro"=>false);
         if(empty($idSubTarea)){


                if($rspta["Error"]){
                    $rspta["Mensaje"].="Por estas razones no se puede Registrar el SubTarea.";
                }else{
                    $RespuestaRegistro=$mantenimiento->RegistroSubTarea($idSubTarea,$SubTareaDescripcion,$fechaInicio,$fechaFin,$SubTareaEstado,$idActividad,$idProyecto,$login_idLog,$tareaNombre);
                    if($RespuestaRegistro){
                        $rspta["Registro"]=true;
                        $rspta["Mensaje"]="Tarea se registro Correctamente.";
                    }else{
                        $rspta["Registro"]=false;
                        $rspta["Mensaje"]="Tarea no se puede registrar comuniquese con el area de soporte.";
                    }
                }
            }else{


                if($rspta["Error"]){
                    $rspta["Mensaje"].="Por estas razones no se puede Registrar el Tarea.";
                }else{

                    $RespuestaRegistro=$mantenimiento->RegistroSubTarea($idSubTarea,$SubTareaDescripcion,$fechaInicio,$fechaFin,$SubTareaEstado,$idActividad,$idProyecto,$login_idLog,$tareaNombre);
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
               "2"=>$reg->NombreActividad,
               "3"=>$reg->NombreTarea,
               "4"=>$reg->Descripcion,
               "5"=>$reg->fechaInicio." - ".$reg->fechaFin,
               "6"=>$reg->fechaRegistro,
               "7"=>BuscarAccion($reg)
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

         $rspta['Eliminar']?$rspta['Mensaje']="Tarea Eliminado.":$rspta['Mensaje']="Tarea no se pudo eliminar comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;

      case 'Recuperar_SubTarea':
         $rspta = array("Mensaje"=>"","Eliminar"=>false,"Error"=>false);
         /*------ Cuando el usuario ya se esta facturando, ya no se puede eliminar --------*/
         $rspta['Eliminar']=$mantenimiento->Eliminar_SubTarea($idSubTarea,2,$login_idLog);

         $rspta['Eliminar']?$rspta['Mensaje']="Tarea Restablecido.":$rspta['Mensaje']="Tarea no se pudo Restablecer comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;

      case 'RecuperarInformacion_SubTarea':
			$rspta=$mantenimiento->Recuperar_SubTarea($idSubTarea);
         echo json_encode($rspta);
      break;

     case 'RecuperarFecha':
			$rspta=$mantenimiento->RecuperarFecha($idActividad);

         echo json_encode($rspta);
      break;


   }


?>
