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

    $idPlan=isset($_POST["idPlan"])?limpiarCadena($_POST["idPlan"]):"";
    $idAlumno=isset($_POST["idAlumno"])?limpiarCadena($_POST["idAlumno"]):"";
    $idCuota=isset($_POST["idCuota"])?limpiarCadena($_POST["idCuota"]):"";

	$login_idLog=$_SESSION['idUsuario'];


    $PagoTipoPago=isset($_POST["PagoTipoPago"])?limpiarCadena($_POST["PagoTipoPago"]):"";
    $PagoTipoTarjeta=isset($_POST["PagoTipoTarjeta"])?limpiarCadena($_POST["PagoTipoTarjeta"]):"";

    $pago_detalle=isset($_POST["pago_detalle"])?limpiarCadena($_POST["pago_detalle"]):"";
    $numPago=isset($_POST["numPago"])?limpiarCadena($_POST["numPago"]):"";

    $importePago=isset($_POST["MontoIngreso"])?limpiarCadena($_POST["MontoIngreso"]):"";
    $importeBase=isset($_POST["importeBase"])?limpiarCadena($_POST["importeBase"]):"";
    $importeMora=isset($_POST["importeMora"])?limpiarCadena($_POST["importeMora"]):"";


 $idProyecto=isset($_POST["idProyecto"])?limpiarCadena($_POST["idProyecto"]):"";

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


      case 'listar_Proyectos':

      		$rpta = $general->Listar_Proyectos();
           echo '<option value="0">-- SELECCIONAR--</option>';
         	while ($reg = $rpta->fetch_object()){
					echo '<option   value=' . $reg->idProyecto . '>' . $reg->NombreProyecto . '</option>';
         	}
       break;

     case 'listar_tipoPago':

      		$rpta = $general->Listar_TipoPago();
         	while ($reg = $rpta->fetch_object()){
					echo '<option   value=' . $reg->idTipoPago . '>' . $reg->Descripcion . '</option>';
         	}
       break;

 case 'RecuperarIndicadores':
			$rspta=$general->Recuperar_Indicadores($idProyecto);
         echo json_encode($rspta);
      break;

   }


?>
