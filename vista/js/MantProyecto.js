var tablaProyecto;
function init(){
   Iniciar_Componentes();
    Listar_Proyecto();
	Listar_Estado();
    Listar_Clientes();
    Listar_JefeProyecto();
}
function Iniciar_Componentes(){
   //var fecha=hoyFecha();

	//$('#date_fecha_comprobante').datepicker('setDate',fecha);

    $("#FormularioProyecto").on("submit",function(e)
	{
	      RegistroProyecto(e);
	});

}
function RegistroProyecto(event){
	  //cargar(true);
	event.preventDefault(); //No se activará la acción predeterminada del evento
    var error="";

    $(".validarPanel").each(function(){
			if($(this).val()==" " || $(this).val()==0){
				error=error+$(this).data("message")+"<br>";
			}
    });

    if(error==""){
		$("#ModalProyecto #cuerpo").addClass("whirl");
		$("#ModalProyecto #cuerpo").addClass("ringed");
		setTimeout('AjaxRegistroProyecto()', 2000);
	}else{
 		notificar_warning("Complete :<br>"+error);
	}
}
function AjaxRegistroProyecto(){
    var formData = new FormData($("#FormularioProyecto")[0]);
		console.log(formData);
		$.ajax({
			url: "../../controlador/Mantenimiento/CProyecto.php?op=AccionProyecto",
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
						$("#ModalProyecto #cuerpo").removeClass("whirl");
						$("#ModalProyecto #cuerpo").removeClass("ringed");
						$("#ModalProyecto").modal("hide");
						swal("Error:", Mensaje);
						LimpiarProyecto();
						tablaProyecto.ajax.reload();
					}else{
						$("#ModalProyecto #cuerpo").removeClass("whirl");
						$("#ModalProyecto #cuerpo").removeClass("ringed");
						$("#ModalProyecto").modal("hide");
					   swal("Acción:", Mensaje);
						LimpiarProyecto();
						tablaProyecto.ajax.reload();
					}
			 }
		});
}
function Listar_Estado(){
	 $.post("../../controlador/Mantenimiento/CProyecto.php?op=listar_estados", function (ts) {
      $("#ProyectoEstado").append(ts);
   });
}
function Listar_Clientes(){
	 $.post("../../controlador/Mantenimiento/CProyecto.php?op=listar_clientes", function (ts) {
      $("#ProyectoCliente").append(ts);
   });
}
function Listar_JefeProyecto(){
	 $.post("../../controlador/Mantenimiento/CProyecto.php?op=listar_jefe_proyecto", function (ts) {
      $("#ProyectoJefe").append(ts);
   });
}
function Listar_Proyecto(){

	tablaProyecto = $('#tablaProyecto').dataTable({
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
               , "targets": [0,1,4,5,6]
            }
            , {
               "className": "text-left"
               , "targets": [2]
            },
            {
               "className": "text-right"
               , "targets": [3]
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
			url: '../../controlador/Mantenimiento/CProyecto.php?op=Listar_Proyecto',
			type: "POST",
			dataType: "JSON",
			error: function (e) {
				console.log(e.responseText);
			}
		},
		// cambiar el lenguaje de datatable
		oLanguage: español,
	}).DataTable();
	//Aplicar ordenamiento y autonumeracion , index
	tablaProyecto.on('order.dt search.dt', function () {
		tablaProyecto.column(0, {
			search: 'applied',
			order: 'applied'
		}).nodes().each(function (cell, i) {
			cell.innerHTML = i + 1;
		});
	}).draw();
}
function NuevoProyecto(){
    $("#ModalProyecto").modal({
      backdrop: 'static'
      , keyboard: false
    });
    $("#ModalProyecto").modal("show");
    $("#tituloModalProyecto").empty();
    $("#tituloModalProyecto").append("Nuevo Proyecto:");
}
function EditarProyecto(idProyecto){
    $("#ModalProyecto").modal({
      backdrop: 'static'
      , keyboard: false
    });
    $("#ModalProyecto").modal("show");
    $("#tituloModalProyecto").empty();
    $("#tituloModalProyecto").append("Editar Proyecto:");
	RecuperarProyecto(idProyecto);
}
function RecuperarProyecto(idProyecto){
	//solicitud de recuperar Proveedor
	$.post("../../controlador/Mantenimiento/CProyecto.php?op=RecuperarInformacion_Proyecto",{"idProyecto":idProyecto}, function(data, status){
		data = JSON.parse(data);
		console.log(data);

	$("#idProyecto").val(data.idProyecto);
	$("#ProyectoNombre").val(data.NombreProyecto);
    $("#ProyectoCliente").val(data.Cliente_idCliente);
    $("#ProyectoDescripcion").val(data.Descripcion);
	$("#ProyectoEstado").val(data.Estado_idEstado);
    $("#ProyectoJefe").val(data.Persona_idPersona);
	});
}
function EliminarProyecto(idProyecto){
      swal({
      title: "Eliminar?",
      text: "Esta Seguro que desea Eliminar Proyecto!",
      type: "warning",
      showCancelButton: true,
      confirmButtonColor: "#DD6B55",
      confirmButtonText: "Si, Eliminar!",
      closeOnConfirm: false
   }, function () {
      ajaxEliminarProyecto(idProyecto);
   });
}
function ajaxEliminarProyecto(idProyecto){
    $.post("../../controlador/Mantenimiento/CProyecto.php?op=Eliminar_Proyecto", {idProyecto: idProyecto}, function (data, e) {
      data = JSON.parse(data);
      var Error = data.Error;
      var Mensaje = data.Mensaje;
      if (Error) {
         swal("Error", Mensaje, "error");
      } else {
         swal("Eliminado!", Mensaje, "success");
         tablaProyecto.ajax.reload();
      }
   });
}
function HabilitarProyecto(idProyecto){
      swal({
      title: "Habilitar?",
      text: "Esta Seguro que desea Habilitar Proyecto!",
      type: "info",
      showCancelButton: true,
      confirmButtonColor: "#DD6B55",
      confirmButtonText: "Si, Habilitar!",
      closeOnConfirm: false
   }, function () {
      ajaxHabilitarProyecto(idProyecto);
   });
}
function ajaxHabilitarProyecto(idProyecto){
       $.post("../../controlador/Mantenimiento/CProyecto.php?op=Recuperar_Proyecto", {idProyecto: idProyecto}, function (data, e) {
      data = JSON.parse(data);
      var Error = data.Error;
      var Mensaje = data.Mensaje;
      if (Error) {
         swal("Error", Mensaje, "error");
      } else {
         swal("Eliminado!", Mensaje, "success");
         tablaProyecto.ajax.reload();
      }
   });
}
function LimpiarProyecto(){
   $('#FormularioProyecto')[0].reset();
	$("#idProyecto").val("");

}
function Cancelar(){
    LimpiarProyecto();
    $("#ModalProyecto").modal("hide");
}

function Tareas(idProyecto){
     $.redirect('MantTarea.php', {'idProyecto':idProyecto});
}
init();
