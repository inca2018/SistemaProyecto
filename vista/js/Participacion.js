var tablaAgregados;
var tablaDisponibles;
function init (){

    var idActividad=$("#idActividad").val();
    Recuperar_Informacion_Actividad(idActividad);
    Listar_Empleados_Agregados(idActividad);
    Listar_Empleados_Disponibles(idActividad);
}

function Listar_Empleados_Agregados(idActividad){
    tablaAgregados = $('#tablaParticipantes').dataTable({
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
               , "targets": [0,1,2,3]
            }
            , {
               "className": "text-left"
               , "targets": []
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
			url: '../../controlador/Mantenimiento/CTarea.php?op=ListarAgregados',
			type: "POST",
			dataType: "JSON",
            data:{'idActividad':idActividad},
			error: function (e) {
				console.log(e.responseText);
			}
		},
		// cambiar el lenguaje de datatable
		oLanguage: español,
	}).DataTable();
	//Aplicar ordenamiento y autonumeracion , index
	tablaAgregados.on('order.dt search.dt', function () {
		tablaAgregados.column(0, {
			search: 'applied',
			order: 'applied'
		}).nodes().each(function (cell, i) {
			cell.innerHTML = i + 1;
		});
	}).draw();
}
function Listar_Empleados_Disponibles(idActividad){

    tablaDisponibles = $('#tablaParticipantesDisponibles').dataTable({
		"aProcessing": true,
		"aServerSide": true,
		"processing": true,
		"paging": true, // Paginacion en tabla
		"ordering": true, // Ordenamiento en columna de tabla
		"info": false, // Informacion de cabecera tabla
		"responsive": true, // Accion de responsive

          "order": [[0, "asc"]],

          "ajax": { //Solicitud Ajax Servidor
			url: '../../controlador/Mantenimiento/CTarea.php?op=ListarDisponibles',
			type: "POST",
			dataType: "JSON",
            data:{'idActividad':idActividad},
			error: function (e) {
				console.log(e.responseText);
			}
		},
        "bDestroy": true,
		"drawCallback": function(settings) { // Evento de repintado
		$('#tablaParticipantesDisponibles tr').each(function() {
			//Al pasar el mouse por la celda,aplica los cambios
			$(this).parent().on('mouseover', 'tr', function() {
				$(this).css('background-color', '#5d9cec');
				$(this).css('color', 'white');
				//Al dejar de pasar el mouse por la celda,aplica los cambios
			$(this).bind("mouseout", function() {
				$(this).css('background-color', '');
				$(this).css('color', '#656565');
				});
			});
		});
		},
		// cambiar el lenguaje de datatable
		oLanguage: español,
	}).DataTable();
	//Aplicar ordenamiento y autonumeracion , index
	tablaDisponibles.on('order.dt search.dt', function () {
		tablaDisponibles.column(0, {
			search: 'applied',
			order: 'applied'
		}).nodes().each(function (cell, i) {
			cell.innerHTML = i + 1;
		});
	}).draw();
}
function Recuperar_Informacion_Actividad(idActividad){
      	//solicitud de recuperar Proveedor
	$.post("../../controlador/Mantenimiento/CTarea.php?op=RecuperarInformacionActividad",{"idActividad":idActividad}, function(data, status){
		data = JSON.parse(data);
		console.log(data);

    $("#idProyectoRe").val(data.idProyecto);
    $("#actividad_1").append();
    $("#actividad_1").html("<b>"+(data.NombreProyecto).toUpperCase()+"</b>");
    $("#actividad_2").append();
    $("#actividad_2").html("<b>"+(data.NombreTarea).toUpperCase()+"</b>");
    $("#actividad_3").append();
    $("#actividad_3").html("<b>S/. "+Formato_Moneda(parseFloat(data.Costo),2)+"</b>");
    $("#actividad_4").append();
    $("#actividad_4").html("<b>-</b>");
    $("#OpcionVolver").removeAttr("onclick");
    $("#OpcionVolver").attr("onclick","Volver("+data.idProyecto+");");

	});
}
function Volver(idProyecto){
    $.redirect('MantTarea.php', {'idProyecto':idProyecto});
}
function AgregarParticipantes(){

    $("#ModalDisponibles").modal("show");
}


function EliminarAgregado(idParticipante){

      swal({
      title: "Eliminar?",
      text: "Esta Seguro que desea Eliminar Empleado!",
      type: "warning",
      showCancelButton: true,
      confirmButtonColor: "#DD6B55",
      confirmButtonText: "Si, Eliminar!",
      closeOnConfirm: false
   }, function () {
      ajaxEliminarEmpleado(idParticipante);
   });


}
function ajaxEliminarEmpleado(idParticipante){

    var idActividad=$("#idActividad").val();
   //solicitud de recuperar Proveedor
	$.post("../../controlador/Mantenimiento/CTarea.php?op=EliminarParticipante",{"idActividad":idActividad,"idParticipacion":idParticipante}, function(data, status){
		data = JSON.parse(data);
        var Eliminar=data.Eliminar;
        var Mensaje=data.Mensaje;
		if(Eliminar){
             swal("Eliminado", Mensaje, "success");
			tablaAgregados.ajax.reload();
            tablaDisponibles.ajax.reload();
		}else{
			swal("Error", Mensaje, "error");
		}
	});

}

function AgregarEmpleado(idEmpleado){
    var idActividad=$("#idActividad").val();
   //solicitud de recuperar Proveedor
	$.post("../../controlador/Mantenimiento/CTarea.php?op=AgregarParticipante",{"idActividad":idActividad,"idEmpleado":idEmpleado}, function(data, status){
		data = JSON.parse(data);
        var Agregar=data.Agregar;
        var Mensaje=data.Mensaje;
		if(Agregar){
			$("#ModalDisponibles").modal("hide");
            notificar_success(Mensaje);
			tablaAgregados.ajax.reload();
            tablaDisponibles.ajax.reload();
		}else{
			notificar_warning(Mensaje);
		}
	});

}
init();
