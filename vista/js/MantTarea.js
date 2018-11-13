var tablaTarea;
function init(){
    var idProyecto=$("#idProyectoRecu").val();
   Iniciar_Componentes();
     Listar_Tarea(idProyecto);
    Listar_Estado();
    Listar_Personas();
    Recuperar_Informacion_Proyecto(idProyecto);
}
function Recuperar_Informacion_Proyecto(idProyecto){
    	//solicitud de recuperar Proveedor
	$.post("../../controlador/Mantenimiento/CTarea.php?op=RecuperarInformacionProyecto",{"idProyectolista":idProyecto}, function(data, status){
		data = JSON.parse(data);
		console.log(data);

    $("#proyecto_1").append();
    $("#proyecto_1").html("<b>"+(data.NombreProyecto).toUpperCase()+"</b>");
    $("#proyecto_2").append();
    $("#proyecto_2").html("<b>"+(data.NombreCliente).toUpperCase()+"</b>");
    $("#proyecto_3").append();
    $("#proyecto_3").html("<b>"+(data.NombreJefe).toUpperCase()+"</b>");
    $("#proyecto_4").append();
    $("#proyecto_4").html("<b>"+0+"</b>");
	});
}
function Iniciar_Componentes(){
   //var fecha=hoyFecha();

	//$('#date_fecha_comprobante').datepicker('setDate',fecha);

    $("#FormularioTarea").on("submit",function(e)
	{
	      RegistroTarea(e);
	});

}
function RegistroTarea(event){
	  //cargar(true);
	event.preventDefault(); //No se activará la acción predeterminada del evento
    var error="";

    $(".validarPanel").each(function(){
			if($(this).val()==" " || $(this).val()==0){
				error=error+$(this).data("message")+"<br>";
			}
    });

    if(error==""){
		$("#ModalTarea #cuerpo").addClass("whirl");
		$("#ModalTarea #cuerpo").addClass("ringed");
		setTimeout('AjaxRegistroTarea()', 2000);
	}else{
 		notificar_warning("Complete :<br>"+error);
	}
}
function AjaxRegistroTarea(){
    var formData = new FormData($("#FormularioTarea")[0]);
		console.log(formData);
		$.ajax({
			url: "../../controlador/Mantenimiento/CTarea.php?op=AccionTarea",
			 type: "POST",
			 data: formData,
			 contentType: false,
			 processData: false,
			 success: function(data, status)
			 {
					data = JSON.parse(data);
					console.log(data);
					var Mensaje=data.Mensaje;
				 	var Error=data.Registro;
					if(!Error){
						$("#ModalTarea #cuerpo").removeClass("whirl");
						$("#ModalTarea #cuerpo").removeClass("ringed");
						$("#ModalTarea").modal("hide");
						swal("Error:", Mensaje);
						LimpiarTarea();
						tablaTarea.ajax.reload();
					}else{
						$("#ModalTarea #cuerpo").removeClass("whirl");
						$("#ModalTarea #cuerpo").removeClass("ringed");
						$("#ModalTarea").modal("hide");
					   swal("Acción:", Mensaje);
						LimpiarTarea();
						tablaTarea.ajax.reload();
					}
			 }
		});
}
function Listar_Estado(){
	 $.post("../../controlador/Mantenimiento/CTarea.php?op=listar_estados", function (ts) {
      $("#TareaEstado").append(ts);
   });
}
function Listar_Personas(){
	 $.post("../../controlador/Mantenimiento/CTarea.php?op=listar_personas", function (ts) {
      $("#TareaPersona").append(ts);
   });
}
function Listar_Tarea(idProyecto){

	tablaTarea = $('#tablaTarea').dataTable({
		"aProcessing": true,
		"aServerSide": true,
		"processing": true,
		"paging": true, // Paginacion en tabla
		"ordering": true, // Ordenamiento en columna de tabla
		"info": true, // Informacion de cabecera tabla
		"responsive": true, // Accion de responsive
	  dom: 'lBfrtip',
        "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
          "order": [[0, "asc"]],
		"bDestroy": true
        , "columnDefs": [
            {
               "className": "text-center"
               , "targets": [1,2,8]
            }
            , {
               "className": "text-left"
               , "targets": [0]
            }
         , ]
         , buttons: [
            {
               extend: 'copy'
               , className: 'btn-info'
            }
            , {
               extend: 'csv'
               , className: 'btn-info'
            }
            , {
               extend: 'excel'
               , className: 'btn-info'
               , title: 'Facturacion'
            }
            , {
               extend: 'pdf'
               , className: 'btn-info'
               , title: $('title').text()
            }
            , {
               extend: 'print'
               , className: 'btn-info'
            }
            ],
          "ajax": { //Solicitud Ajax Servidor
			url: '../../controlador/Mantenimiento/CTarea.php?op=Listar_Tarea',
			type: "POST",
			dataType: "JSON",
            data:{'idProyectolista':idProyecto},
			error: function (e) {
				console.log(e.responseText);
			}
		},
		// cambiar el lenguaje de datatable
		oLanguage: español,
	}).DataTable();
	//Aplicar ordenamiento y autonumeracion , index
	tablaTarea.on('order.dt search.dt', function () {
		tablaTarea.column(0, {
			search: 'applied',
			order: 'applied'
		}).nodes().each(function (cell, i) {
			cell.innerHTML = i + 1;
		});
	}).draw();
}
function NuevoTarea(){
    $("#ModalTarea").modal({
      backdrop: 'static'
      , keyboard: false
    });
    $("#ModalTarea").modal("show");
    $("#tituloModalTarea").empty();
    $("#tituloModalTarea").append("Nueva Actividad:");
}
function EditarTarea(idTarea){
    $("#ModalTarea").modal({
      backdrop: 'static'
      , keyboard: false
    });
    $("#ModalTarea").modal("show");
    $("#tituloModalTarea").empty();
    $("#tituloModalTarea").append("Editar Actividad:");
	RecuperarTarea(idTarea);
}
function RecuperarTarea(idTarea){
	//solicitud de recuperar Proveedor
	$.post("../../controlador/Mantenimiento/CTarea.php?op=RecuperarInformacion_Tarea",{"idTarea":idTarea}, function(data, status){
		data = JSON.parse(data);
		console.log(data);

        $("#idTarea").val(data.idActividad);
        $("#TareaNombre").val(data.NombreTarea);
        $("#TareaHoras").val(data.CantidadHoras);
        $("#TareaDescripcion").val(data.Descripcion);
        $("#TareaCosto").val(data.Costo);
        $("#TareaEstado").val(data.Estado_idEstado);
        $("#TareaPersona").val(data.Persona_idPersona);

	});
}

function EliminarTarea(idTarea){
      swal({
      title: "Eliminar?",
      text: "Esta Seguro que desea Eliminar Tarea!",
      type: "warning",
      showCancelButton: true,
      confirmButtonColor: "#DD6B55",
      confirmButtonText: "Si, Eliminar!",
      closeOnConfirm: false
   }, function () {
      ajaxEliminarTarea(idTarea);
   });
}
function ajaxEliminarTarea(idTarea){
    $.post("../../controlador/Mantenimiento/CTarea.php?op=Eliminar_Tarea", {idTarea: idTarea}, function (data, e) {
      data = JSON.parse(data);
      var Error = data.Error;
      var Mensaje = data.Mensaje;
      if (Error) {
         swal("Error", Mensaje, "error");
      } else {
         swal("Eliminado!", Mensaje, "success");
         tablaTarea.ajax.reload();
      }
   });
}
function HabilitarTarea(idTarea){
      swal({
      title: "Habilitar?",
      text: "Esta Seguro que desea Habilitar Tarea!",
      type: "info",
      showCancelButton: true,
      confirmButtonColor: "#DD6B55",
      confirmButtonText: "Si, Habilitar!",
      closeOnConfirm: false
   }, function () {
      ajaxHabilitarTarea(idTarea);
   });
}
function ajaxHabilitarTarea(idTarea){
       $.post("../../controlador/Mantenimiento/CTarea.php?op=Recuperar_Tarea", {idTarea: idTarea}, function (data, e) {
      data = JSON.parse(data);
      var Error = data.Error;
      var Mensaje = data.Mensaje;
      if (Error) {
         swal("Error", Mensaje, "error");
      } else {
         swal("Eliminado!", Mensaje, "success");
         tablaTarea.ajax.reload();
      }
   });
}
function LimpiarTarea(){
   $('#FormularioTarea')[0].reset();
	$("#idTarea").val("");

}
function Cancelar(){
    LimpiarTarea();
    $("#ModalTarea").modal("hide");
}
function SubTareas(idActividad){
       var idProyecto=$("#idProyectoRecu").val();
     $.redirect('MantSubTarea.php', {'idActividad':idActividad,'idProyecto':idProyecto});
}
function Participantes(idTarea){
     $.redirect('Participacion.php', {'idTarea':idTarea});
}

function Volver(){

     $.redirect('MantProyecto.php');
}
init();
