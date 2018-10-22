<?php
   session_start();
   require_once "../../modelo/Gestion/MGestion.php";
   require_once "../../modelo/General/MGeneral.php";
   $gestion = new MGestion();
   $general = new MGeneral();


	$idGestion=isset($_POST["idGestion"])?limpiarCadena($_POST["idGestion"]):"";
	$GestionNombre=isset($_POST["GestionNombre"])?limpiarCadena($_POST["GestionNombre"]):"";
	$GestionDescripcion=isset($_POST["GestionDescripcion"])?limpiarCadena($_POST["GestionDescripcion"]):"";
	$GestionEstado=isset($_POST["GestionEstado"])?limpiarCadena($_POST["GestionEstado"]):"";

    $idPermisos=isset($_POST["idPermisos"])?limpiarCadena($_POST["idPermisos"]):"";
    $Permiso1=isset($_POST["m_gestion"])?limpiarCadena($_POST["m_gestion"]):"";
    $Permiso2=isset($_POST["m_gestion"])?limpiarCadena($_POST["m_gestion"]):"";
    $Permiso3=isset($_POST["m_reporte"])?limpiarCadena($_POST["m_reporte"]):"";

   $idProyecto=isset($_POST["idProyecto"])?limpiarCadena($_POST["idProyecto"]):"";
 	$idActividad=isset($_POST["idActividad"])?limpiarCadena($_POST["idActividad"]):"";
	$idTarea=isset($_POST["idTarea"])?limpiarCadena($_POST["idTarea"]):"";

	$login_idLog=$_SESSION['idUsuario'];


    $PagoTipoPago=isset($_POST["PagoTipoPago"])?limpiarCadena($_POST["PagoTipoPago"]):"";
    $PagoTipoTarjeta=isset($_POST["PagoTipoTarjeta"])?limpiarCadena($_POST["PagoTipoTarjeta"]):"";

    $pago_detalle=isset($_POST["pago_detalle"])?limpiarCadena($_POST["pago_detalle"]):"";
    $numPago=isset($_POST["numPago"])?limpiarCadena($_POST["numPago"]):"";

    $importePago=isset($_POST["MontoIngreso"])?limpiarCadena($_POST["MontoIngreso"]):"";
    $importeBase=isset($_POST["importeBase"])?limpiarCadena($_POST["importeBase"]):"";
    $importeMora=isset($_POST["importeMora"])?limpiarCadena($_POST["importeMora"]):"";



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
            return '<button type="button"  title="Permisos" class="btn btn-info btn-sm" onclick="PermisosGestion('.$reg->idGestion.')"><i class="fa fa-tasks"></i></button>
            <button type="button"   title="Editar" class="btn btn-warning btn-sm" onclick="EditarGestion('.$reg->idGestion.')"><i class="fa fa-edit"></i></button>
               <button type="button"  title="Eliminar" class="btn btn-danger btn-sm" onclick="EliminarGestion('.$reg->idGestion.')"><i class="fa fa-trash"></i></button>
               ';
        }elseif($reg->Estado_idEstado==4){
            return '<button type="button"  title="Habilitar" class="btn btn-info btn-sm" onclick="HabilitarGestion('.$reg->idGestion.')"><i class="fa fa-sync"></i></button>';
        }
    }
    function AccionesCuotas($reg){
        if($reg->Estado_idEstado==5 || $reg->Estado_idEstado==6 ){
            return '<button type="button"  title="Pago de Matriculas" class="btn btn-green btn-sm m-1" onclick="PagoCuota('.$reg->idCuota.')"><i class="fas fa-money-bill-alt fa-1x"></i>
            </button>';
        }else{
            return '<div class="badge badge-primary">PAGADO</div>';
        }
    }

   function AccionesOperacion($reg){
       if($reg->idPlanPago==null || $reg->idPlanPago==''){
            return '<div class="badge badge-primary">DEBE MATRICULAR A ALUMNO</div>';
       }else{
          return'
            <button type="button"  title="Pago de Matricula" class="btn btn-info btn-sm m-1" onclick="PagoMatricula('.$reg->idPlanPago.','.$reg->idAlumno.')"><i class="fas fa-money-bill-alt fa-lg"></i>
            </button>
            <button type="button"   title="Pago de Cuota" class="btn btn-success btn-sm m-1" onclick="PagoCuota('.$reg->idPlanPago.','.$reg->idAlumno.')"><i class="fas fa-dollar-sign fa-lg"></i></button>
            ';
       }

   }

 function AccionesOperacion2($reg){
       if($reg->Estado_idEstado==null || $reg->Estado_idEstado==8){
            return '<div class="badge badge-primary">ANULADO</div>';
       }else{
          return'
            <button type="button"  title="Registrar Subtarea" class="btn btn-info btn-sm m-1" onclick="verSubtareas('.$reg->idProyecto.','.$reg->idTarea.')"><i class="fas fa-plus fa-lg"></i>
            </button>';
       }

   }

   switch($_GET['op']){
     case 'RecuperarInformacionMatricula':
			$rspta=$gestion->RecuperarInformacionMatricula($idPlan,$idAlumno);
         echo json_encode($rspta);
      break;
    case 'RecuperarCuotaPagar':
			$rspta=$gestion->RecuperarCuotaPagar($idPlan,$idCuota);
         echo json_encode($rspta);
      break;


      case 'listar_tipoTarjeta':

      		$rpta = $general->Listar_TipoTarjeta();
         	while ($reg = $rpta->fetch_object()){
					echo '<option   value=' . $reg->idTipoTarjeta . '>' . $reg->Descripcion . '</option>';
         	}
       break;
     case 'listar_tipoPago':

      		$rpta = $general->Listar_TipoPago();
         	while ($reg = $rpta->fetch_object()){
					echo '<option   value=' . $reg->idTipoPago . '>' . $reg->Descripcion . '</option>';
         	}
       break;

		case 'Listar_Operaciones':

         $rspta=$gestion->Recuperar_Informacion_proyectos();
         $data= array();
         while ($reg=$rspta->fetch_object()){
         $data[]=array(
               "0"=>'',
               "1"=>$reg->NombreProyecto,
               "2"=>$reg->NumeroTareas,
               "3"=>$reg->HorasProgramadas,
               "4"=>$reg->HorasRealizadas,
               "5"=>"S/. ".number_format($reg->CostoPresupuestado,2),
               "6"=>"S/. ".number_format($reg->CostoRealizado,2),
               "7"=>$reg->PorcentajeAvance

            );
         }
         $results = array(
            "sEcho"=>1, //Información para el datatables
            "iTotalRecords"=>count($data), //enviamos el total registros al datatable
            "iTotalDisplayRecords"=>count($data), //enviamos el total registros a visualizar
            "aaData"=>$data);
         echo json_encode($results);
      break;

    case 'Listar_Operaciones_Usuario':

         $rspta=$gestion->Recuperar_Informacion_Usuario($login_idLog);
         $data= array();
         while ($reg=$rspta->fetch_object()){
         $data[]=array(
               "0"=>'',
               "1"=>BuscarEstado($reg),
               "2"=>$reg->NombreProyecto,
               "3"=>$reg->NombreCliente,
               "4"=>$reg->NombreTarea,
               "5"=>$reg->CantidadHoras,
               "6"=>$reg->fechaRegistro,
               "7"=>AccionesOperacion2($reg)
            );
         }
         $results = array(
            "sEcho"=>1, //Información para el datatables
            "iTotalRecords"=>count($data), //enviamos el total registros al datatable
            "iTotalDisplayRecords"=>count($data), //enviamos el total registros a visualizar
            "aaData"=>$data);
         echo json_encode($results);
      break;

	    case 'ListarGestionTarea':
         $rspta=$gestion->RecuperarTareaGestion($idTarea);
         $data= array();
         while ($reg=$rspta->fetch_object()){
         $data[]=array(
               "0"=>'',
               "1"=>$reg->NombreTarea,
				   "2"=>$reg->Detalle,
               "3"=>$reg->DiasTotales,
               "4"=>$reg->DiasGestion,

				   "5"=>$reg->fechaRegistro,
               "6"=>'<button type="button"  title="Eliminar Gestión" class="btn btn-danger btn-sm" onclick="EliminarGestion('.$reg->idGestionTarea.')"><i class="fa fa-trash"></i></button>'
            );
         }
         $results = array(
            "sEcho"=>1, //Información para el datatables
            "iTotalRecords"=>count($data), //enviamos el total registros al datatable
            "iTotalDisplayRecords"=>count($data), //enviamos el total registros a visualizar
            "aaData"=>$data);
         echo json_encode($results);
      break;


    case 'Listar_Cuotas':
         $rspta=$gestion->Listar_Cuotas($idPlan,$idAlumno);
         $data= array();
         while ($reg=$rspta->fetch_object()){
         $data[]=array(
               "0"=>'',
               "1"=>BuscarEstado($reg),
               "2"=>"S/. ".number_format($reg->Importe,2),
               "3"=>"S/. ".number_format($reg->Diferencia,2),

               "4"=>$reg->fechaVencimiento,
               "5"=>$reg->DiasMora,
               "6"=>"S/. ".number_format((($reg->DiasMora*1)-$reg->Mora),2),
               "7"=>AccionesCuotas($reg)

            );
         }
         $results = array(
            "sEcho"=>1, //Información para el datatables
            "iTotalRecords"=>count($data), //enviamos el total registros al datatable
            "iTotalDisplayRecords"=>count($data), //enviamos el total registros a visualizar
            "aaData"=>$data);
         echo json_encode($results);
      break;


      case 'RegistrarPago':
         $rspta = array("Mensaje"=>"","Registro"=>false,"Error"=>false);

         $rspta['Registro']=$gestion->RegistrarPago($idPlan,$idAlumno,$numPago,$PagoTipoPago,$PagoTipoTarjeta,$importePago,$pago_detalle,$login_idLog);
         $rspta['Registro']?$rspta['Mensaje']="Pago Registrado.":$rspta['Mensaje']="Pago no se pudo Registrar comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;

  case 'RegistrarCuota':
         $rspta = array("Mensaje"=>"","Registro"=>false,"Error"=>false);


            $rspta['Registro']=$gestion->RegistrarCuota($idPlan,$idAlumno,$idCuota,$PagoTipoPago,$PagoTipoTarjeta,$importePago,$importeBase,$importeMora,$pago_detalle,$login_idLog);
            $rspta['Registro']?$rspta['Mensaje']="Pago Registrado.":$rspta['Mensaje']="Pago no se pudo Registrar comuniquese con el area de soporte";

         echo json_encode($rspta);
      break;

    case 'RecuperarInformacion':
        $rspta=$gestion->Recuperar_Parametros($idPlan,$idCuota);
        echo json_encode($rspta);
    break;
	case 'RecuperarInformacionTarea':
        $rspta=$gestion->RecuperarInformacionTarea($idTarea);
        echo json_encode($rspta);
    break;



    case 'RecuperarArbol2':
         $response=Array();
         $base=Array();
         $base["text"]='<span class="badge badge-success ml-2 mr-2"><i class="fa fa-star   mr-2 ml-2" aria-hidden="true"></i>PROYECTOS</span>';
         $rspta_proyectos=$general->Listar_ProyectosDisponibles($login_idLog);

        while($proyectoRecuperado=$rspta_proyectos->fetch_object()){
            $ProyectoArreglo= Array();
            $ProyectoArreglo["text"]='<span class="badge badge-info ml-2 mr-2"><i class="fa fa-folder mr-2 ml-2" aria-hidden="true"></i>'.$proyectoRecuperado->NombreProyecto.'</span>';

           $actividadDisponible= $general->ListarActividadesDisponibles($proyectoRecuperado->idProyecto,$login_idLog);

            while($actividadRecuperado=$actividadDisponible->fetch_object()){
                $ActividadArreglo=Array();
                $ActividadArreglo["text"]='<span class="badge badge-warning ml-2 mr-2"><i class="fa fa-home   mr-2 ml-2" aria-hidden="true"></i>'.$actividadRecuperado->NombreTarea.'</span> --------------------> '.$actividadRecuperado->nombreEstado;
                 $rsta_tareas=$gestion->listar_Tareas($actividadRecuperado->idActividad,$proyectoRecuperado->idProyecto,$login_idLog);

                while($tarea=$rsta_tareas->fetch_object()){
                    $Tarea=Array();
                    $Tarea["text"]='<span class="badge badge-primary ml-2 mr-2"><i class="fa fa-desktop  mr-2 ml-2" aria-hidden="true"></i>'.$tarea->NombreTarea.'</span> -------------------------------------> Estado: '.$tarea->nombreEstado;
                    $Actividad["children"][]=$Tarea;
                }

                $ProyectoArreglo["children"][]=$ActividadArreglo;
            }

            $base["children"][]=$ProyectoArreglo;
        }
         $response[]=$base;

        echo json_encode($response);

     break;
     case 'MostrarDisponibilidad':
         $rspta=$gestion->ListaDisponibilidad($login_idLog);
         $data= array();
         while ($reg=$rspta->fetch_object()){
         $data[]=array(
               "0"=>'',
				   "1"=>BuscarEstado($reg);
               "2"=>$reg->NombreProyecto,
               "3"=>$reg->NombreActividad,
               "4"=>$reg->NombreTarea,
               "5"=>$reg->nombreEstado,
               "6"=>'<button type="button"  title="Gestión" class="btn btn-info btn-sm m-1" onclick="Gestión_Tarea('.$reg->idProyecto.','.$reg->idActividad.','.$reg->idTarea.')"><i class="fas fa-money-bill-alt fa-lg"></i>
            </button>'
            );
         }
         $results = array(
            "sEcho"=>1, //Información para el datatables
            "iTotalRecords"=>count($data), //enviamos el total registros al datatable
            "iTotalDisplayRecords"=>count($data), //enviamos el total registros a visualizar
            "aaData"=>$data);
         echo json_encode($results);
    break;
   }


?>
