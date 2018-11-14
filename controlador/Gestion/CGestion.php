<?php
   session_start();
   require_once "../../modelo/Gestion/MGestion.php";
   require_once "../../modelo/General/MGeneral.php";
	require_once "../../config/conexion.php";
   $gestion = new MGestion();
   $general = new MGeneral();
   $recursos = new Conexion();


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

	$detalle=isset($_POST["detalle"])?limpiarCadena($_POST["detalle"]):"";

	$inicio=isset($_POST["inicio"])?limpiarCadena($_POST["inicio"]):"";

	$fin=isset($_POST["fin"])?limpiarCadena($_POST["fin"]):"";

   $date = str_replace('/', '-', $inicio);
   $inicio = date("Y-m-d", strtotime($date));

   $date = str_replace('/', '-', $fin);
   $fin = date("Y-m-d", strtotime($date));

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

function AccionDisponibilidad($reg){
	$respuesta="";
	$respuesta.= '<button type="button"  title="Gestión" class="btn btn-info btn-sm m-1" onclick="Gestion_Tarea('.$reg->idProyecto.','.$reg->idActividad.','.$reg->idTarea.')"><i class="fas fa-share fa-lg"></i>
            </button>';

	if ($reg->Documento != "" || $reg->Documento != null) {
			  $respuesta .= '<a href="../../vista/DocumentoTarea/'. $reg->Documento . '" target="_blank" class="btn btn-danger btn-sm ml-1"><i class="fas fa-file-pdf"></i></a>';
		 }

	return $respuesta;
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
               "2"=>$reg->CantidadParticipantes,
               "3"=>$reg->CantidadActividades,
               "4"=>$reg->CantidadTareas,
               "5"=>$reg->Diasproyecto." Dias",
               "6"=>"S/. ".number_format($reg->CostoTotalProyecto,2),
               "7"=>"S/. ".number_format(($reg->CostoTotalProyecto/$reg->Diasproyecto)*$reg->DiasGestion,2),
               "8"=>"S/. ".number_format(($reg->CostoTotalProyecto/$reg->Diasproyecto)*($reg->Diasproyecto-$reg->DiasGestion),2),
               "9"=>number_format((($reg->DiasGestion*100)/$reg->Diasproyecto),2)." %",
               "10"=>number_format(100-(($reg->DiasGestion*100)/$reg->Diasproyecto),2)." %"

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
        $rspta=$gestion->Recuperar_Parametros();
        echo json_encode($rspta);
    break;
	case 'RecuperarInformacionTarea':
        $rspta=$gestion->RecuperarInformacionTarea($idTarea);
        echo json_encode($rspta);
    break;
	case 'RecuperarInformacionFechas':
        $rspta=$gestion->RecuperarInformacionFechas($idTarea);
        echo json_encode($rspta);
    break;

    case 'RecuperarReporteFechas':
			$rspta=$gestion->RecuperarReporteFechas($inicio,$fin,$idProyecto);
         echo json_encode($rspta);
      break;



     case 'MostrarDisponibilidad':
         $rspta=$gestion->ListaDisponibilidad($login_idLog);
         $data= array();
         while ($reg=$rspta->fetch_object()){
         $data[]=array(
               "0"=>'',
               "1"=>$reg->NombreProyecto,
				   "2"=>BuscarEstado($reg),
               "3"=>$reg->NombreActividad,
               "4"=>$reg->NombreTarea,
               "5"=>AccionDisponibilidad($reg)
            );
         }
         $results = array(
            "sEcho"=>1, //Información para el datatables
            "iTotalRecords"=>count($data), //enviamos el total registros al datatable
            "iTotalDisplayRecords"=>count($data), //enviamos el total registros a visualizar
            "aaData"=>$data);
         echo json_encode($results);
    break;
     case 'RegistroGestionTarea':
		 	$rspta=array("Error"=>false,"Mensaje"=>"","Registro"=>false);
                if($rspta["Error"]){
                    $rspta["Mensaje"].="Por estas razones no se puede Registrar la Gestión de Tarea.";
                }else{
                    $RespuestaRegistro=$gestion->RegistroGestionTarea($idTarea,$detalle,$inicio,$fin,$login_idLog);
                    if($RespuestaRegistro){
                        $rspta["Registro"]=true;
                        $rspta["Mensaje"]="Gestión de Tarea se registro Correctamente.";
                    }else{
                        $rspta["Registro"]=false;
                        $rspta["Mensaje"]="Gestión de Tarea no se puede registrar comuniquese con el area de soporte.";
                    }
                }


         echo json_encode($rspta);
       break;
		case 'RecuperarReporte2':

		   $rspta=$gestion->RecuperarReporte($inicio,$fin,$idProyecto);
         $data= array();
         while ($reg=$rspta->fetch_object()){
         $data[]=array(
              "0"=>'',
						"1"=>$reg->campo1,
						"2"=>$reg->campo2,
						"3"=>"S/. ".number_format($reg->campo3,2),
						"4"=>number_format($reg->campo4/100,2),
						"5"=>number_format(($reg->campo3*($reg->campo4/100)),2)
            );
         }
         $results = array(
            "sEcho"=>1, //Información para el datatables
            "iTotalRecords"=>count($data), //enviamos el total registros al datatable
            "iTotalDisplayRecords"=>count($data), //enviamos el total registros a visualizar
            "aaData"=>$data);
         echo json_encode($results);
		break;
			case 'RecuperarReporte1':

		   $rspta=$gestion->RecuperarReporte($inicio,$fin,$idProyecto);
         $data= array();
         while ($reg=$rspta->fetch_object()){
         $data[]=array(
              "0"=>'',
						"1"=>$reg->campo1,
						"2"=>$reg->campo2,
						"3"=>number_format(($reg->campo3*($reg->campo4/100)),2),
						"4"=>"S/. ".number_format($reg->campo3,2),
						"5"=>number_format((($reg->campo3*($reg->campo4/100))/$reg->campo3),2)
            );
         }
         $results = array(
            "sEcho"=>1, //Información para el datatables
            "iTotalRecords"=>count($data), //enviamos el total registros al datatable
            "iTotalDisplayRecords"=>count($data), //enviamos el total registros a visualizar
            "aaData"=>$data);
         echo json_encode($results);
		break;
		case 'RecuperarReporte1':
		   $response=Array();
			$respuesta=$gestion->RecuperarReporte($inicio,$fin,$idProyecto);

			while ($Actividad=$respuesta->fetch_object()){
				$temporal=array();
				$temporal["actividad"]=$Actividad->campo1;
				$temporal["fecha"]=$Actividad->campo2;
				$temporal["presupuesto"]=$Actividad->campo3;
				$temporal["avance"]=$Actividad->campo4;
				$temporal["noavance"]=$Actividad->campo5;
				$response[]=$temporal;
			}

		   echo json_encode($response);
		break;
    case 'EliminarGestion':
         $rspta = array("Mensaje"=>"","Eliminar"=>false,"Error"=>false);
         /*------ Cuando el usuario ya se esta facturando, ya no se puede eliminar --------*/
         $rspta['Eliminar']=$gestion->EliminarGestion($idGestion,$idTarea);

         $rspta['Eliminar']?$rspta['Mensaje']="Gestión Eliminado.":$rspta['Mensaje']="Gestión no se pudo eliminar porque tiene Tareas Registradas.";
         echo json_encode($rspta);
      break;
	 case 'Finalizar':
         $rspta = array("Mensaje"=>"","Finalizar"=>false,"Error"=>false);

			$Documento = "";
            if ($_FILES["adjuntar_documento"]["name"] != '') {
                $tipoFile = $_FILES['adjuntar_documento']['type'];
                if ($tipoFile == "application/pdf") {
                    $Documento = "Tarea".$idTarea.".pdf";
                } else {
                    $Documento      = null;
                    $rspta["Error"] = true;
                    $rspta["Mensaje"] .= " Documento Adjunto no es un Archivo PDF valido.";
                }
            } else {
                $Documento = null;
            }
   //
			$rspta['Finalizar']=$gestion->FinalizarTarea($idTarea,$Documento);

			 if($Documento!=null)
					 {
						$Subida     = $recursos->upload_documento($idTarea,"Tarea".$idTarea.".pdf");
					 }

         $rspta['Finalizar']?$rspta['Mensaje']="Tarea Finalizada Correctamente.":$rspta['Mensaje']="Tarea no se pudo Finalizar contactese con el soporte del sistema.";
         echo json_encode($rspta);
      break;



      case 'JsonArbol':
         $response= Array();
         $general=Array();
         $general["text"]='<span class="badge badge-dark ml-2 mr-2"><i class="fa fa-star mr-2 ml-2" aria-hidden="true"></i>Portafolio de Proyectos</span>';

         $rspta_proyecto=$gestion->ListarProyectos();

          while ($reg_proyecto=$rspta_proyecto->fetch_object()){
              $Proyecto= Array();
              $Proyecto["text"]='<span class="badge badge-warning ml-2 mr-2"><i class="fa fa-folder mr-2 ml-2" aria-hidden="true"></i>PROYECTO : '.$reg_proyecto->NombreProyecto.' ---------- Fecha de Inicio: '.$reg_proyecto->Inicio.' ----------  Fecha de Fin: '.$reg_proyecto->Fin.'</span> <span class="badge badge-success ">'.$reg_proyecto->PorcentajeAvance.'</span>';

               $rspta_Actividad=$gestion->ListarActividades($reg_proyecto->idProyecto);
              while($reg_Acti=$rspta_Actividad->fetch_object()){
                  $Actividad=Array();
                  $Actividad["text"]='<span class="badge badge-primary ml-2 mr-2"><i class="fa fa-folder   mr-2 ml-2" aria-hidden="true"></i>ACTIVIDAD: '.$reg_Acti->NombreTarea.'---------- Fecha de Inicio: '.$reg_Acti->Inicio.' ----------  Fecha de Fin: '.$reg_Acti->Fin.' </span><span class="badge badge-success ">'.$reg_Acti->ActividadAvance.'</span>';

                 $rsta_tareas=$gestion->ListarTareas($reg_Acti->idActividad);
                   while($reg_Tarea=$rsta_tareas->fetch_object()){
                      $Tarea=Array();
                      $Tarea["text"]='<span class="badge badge-info ml-2 mr-2"><i class="fa fa-folder  mr-2 ml-2" aria-hidden="true"></i>TAREA: '.$reg_Tarea->NombreTarea.'---------- Fecha de Inicio: '.$reg_Tarea->Inicio.' ----------  Fecha de Fin: '.$reg_Tarea->Fin.'</span><span class="badge badge-success ">'.$reg_Tarea->TareadAvance.'</span>';

                      $Actividad["children"][]=$Tarea;
                  }

                  $Proyecto["children"][]=$Actividad;


              }

              $general["children"][]=$Proyecto;

          }

         $response[]=$general;

        echo json_encode($response);
    break;

	}



?>
