var tablaCliente;
function init(){
   Iniciar_Componentes();
   Listar_Cliente();
	Listar_Estado();
}
function Iniciar_Componentes(){
   //var fecha=hoyFecha();

	//$('#date_fecha_comprobante').datepicker('setDate',fecha);

    $("#FormularioCliente").on("submit",function(e)
	{
	      RegistroCliente(e);
	});

}
function RegistroCliente(event){
	  //cargar(true);
	event.preventDefault(); //No se activará la acción predeterminada del evento
    var error="";

    $(".validarPanel").each(function(){
			if($(this).val()==" " || $(this).val()==0){
				error=error+$(this).data("message")+"<br>";
			}
    });

    if(error==""){
		$("#ModalCliente #cuerpo").addClass("whirl");
		$("#ModalCliente #cuerpo").addClass("ringed");
		setTimeout('AjaxRegistroCliente()', 2000);
	}else{
 		notificar_warning("Complete :<br>"+error);
	}
}
function AjaxRegistroCliente(){
    var formData = new FormData($("#FormularioCliente")[0]);
		console.log(formData);
		$.ajax({
			url: "../../controlador/Mantenimiento/CCliente.php?op=AccionCliente",
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
						$("#ModalCliente #cuerpo").removeClass("whirl");
						$("#ModalCliente #cuerpo").removeClass("ringed");
						$("#ModalCliente").modal("hide");
						swal("Error:", Mensaje);
						LimpiarCliente();
						tablaCliente.ajax.reload();
					}else{
						$("#ModalCliente #cuerpo").removeClass("whirl");
						$("#ModalCliente #cuerpo").removeClass("ringed");
						$("#ModalCliente").modal("hide");
					   swal("Acción:", Mensaje);
						LimpiarCliente();
						tablaCliente.ajax.reload();
					}
			 }
		});
}
function Listar_Estado(){
	 $.post("../../controlador/Mantenimiento/CCliente.php?op=listar_estados", function (ts) {
      $("#ClienteEstado").append(ts);
   });
}
function Listar_Cliente(){

	tablaCliente = $('#tablaCliente').dataTable({
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
               , "targets": [1,2]
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
			url: '../../controlador/Mantenimiento/CCliente.php?op=Listar_Cliente',
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
	tablaCliente.on('order.dt search.dt', function () {
		tablaCliente.column(0, {
			search: 'applied',
			order: 'applied'
		}).nodes().each(function (cell, i) {
			cell.innerHTML = i + 1;
		});
	}).draw();
}
function NuevoCliente(){
    $("#ModalCliente").modal({
      backdrop: 'static'
      , keyboard: false
    });
    $("#ModalCliente").modal("show");
    $("#tituloModalCliente").empty();
    $("#tituloModalCliente").append("Nuevo Cliente:");
}
function EditarCliente(idCliente){
    $("#ModalCliente").modal({
      backdrop: 'static'
      , keyboard: false
    });
    $("#ModalCliente").modal("show");
    $("#tituloModalCliente").empty();
    $("#tituloModalCliente").append("Editar Cliente:");
	RecuperarCliente(idCliente);
}
function RecuperarCliente(idCliente){
	//solicitud de recuperar Proveedor
	$.post("../../controlador/Mantenimiento/CCliente.php?op=RecuperarInformacion_Cliente",{"idCliente":idCliente}, function(data, status){
		data = JSON.parse(data);
		console.log(data);

	$("#idCliente").val(data.idCliente);
	$("#ClienteNombre").val(data.NombreCliente);
    $("#ClienteContacto").val(data.Contacto);
    $("#ClienteDireccion").val(data.Direccion);
	$("#ClienteEstado").val(data.Estado_idEstado);

	});
}
function EliminarCliente(idCliente){
      swal({
      title: "Eliminar?",
      text: "Esta Seguro que desea Eliminar Cliente!",
      type: "warning",
      showCancelButton: true,
      confirmButtonColor: "#DD6B55",
      confirmButtonText: "Si, Eliminar!",
      closeOnConfirm: false
   }, function () {
      ajaxEliminarCliente(idCliente);
   });
}
function ajaxEliminarCliente(idCliente){
    $.post("../../controlador/Mantenimiento/CCliente.php?op=Eliminar_Cliente", {idCliente: idCliente}, function (data, e) {
      data = JSON.parse(data);
      var Error = data.Error;
      var Mensaje = data.Mensaje;
      if (Error) {
         swal("Error", Mensaje, "error");
      } else {
         swal("Eliminado!", Mensaje, "success");
         tablaCliente.ajax.reload();
      }
   });
}
function HabilitarCliente(idCliente){
      swal({
      title: "Habilitar?",
      text: "Esta Seguro que desea Habilitar Cliente!",
      type: "info",
      showCancelButton: true,
      confirmButtonColor: "#DD6B55",
      confirmButtonText: "Si, Habilitar!",
      closeOnConfirm: false
   }, function () {
      ajaxHabilitarCliente(idCliente);
   });
}
function ajaxHabilitarCliente(idCliente){
       $.post("../../controlador/Mantenimiento/CCliente.php?op=Recuperar_Cliente", {idCliente: idCliente}, function (data, e) {
      data = JSON.parse(data);
      var Error = data.Error;
      var Mensaje = data.Mensaje;
      if (Error) {
         swal("Error", Mensaje, "error");
      } else {
         swal("Eliminado!", Mensaje, "success");
         tablaCliente.ajax.reload();
      }
   });
}
function LimpiarCliente(){
   $('#FormularioCliente')[0].reset();
	$("#idCliente").val("");

}
function Cancelar(){
    LimpiarCliente();
    $("#ModalCliente").modal("hide");
}


init();
