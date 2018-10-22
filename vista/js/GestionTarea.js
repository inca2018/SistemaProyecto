var tablaTareaGestion;
function init(){
	var idProyecto=$("#idProyecto").val();
	var idActividad=$("#idActividad").val();
	var idTarea=$("#idTarea").val();

	MostrarInformacionTarea(idTarea);
	Listar_Gestion(idTarea);
	$("#FormularioGestionTarea").on("submit",function(e)
	{
	      RegistroGestionTarea(e);
	});

	 $('#date_inicio').datepicker({
        format: 'dd/mm/yyyy',
    });
    $('#date_fin').datepicker({
        format: 'dd/mm/yyyy',
    });
	 $('#date_inicio').datepicker().on('changeDate', function (ev) {
                var f_inicio = $("#inicio").val();
                var f_fin = $("#fin").val();
                var day = parseInt(f_inicio.substr(0, 2));
                var month = parseInt(f_inicio.substr(3, 2));
                var year = parseInt(f_inicio.substr(6, 8));

                $('#date_fin').datepicker('setStartDate', new Date(year, (month - 1), day));
      });
    $('#date_fin').datepicker().on('changeDate', function (ev) {
                var f_inicio = $("#inicio").val();
                var f_fin = $("#fin").val();
                var day = parseInt(f_fin.substr(0, 2));
                var month = parseInt(f_fin.substr(3, 2));
                var year = parseInt(f_fin.substr(6, 8));
                $('#date_inicio').datepicker('setEndDate', new Date(year, (month - 1), day));
            });
}

function RegistroGestionTarea(e){
	//cargar(true);
    event.preventDefault(); //No se activará la acción predeterminada del evento
    var error = "";

    $(".validarPanel").each(function () {
        if ($(this).val() == " " || $(this).val() == 0) {
            error = error + $(this).data("message") + "<br>";
        }
    });

    if (error == "") {
        $("#ModalGestionTarea #cuerpo").addClass("whirl");
        $("#ModalGestionTarea #cuerpo").addClass("ringed");
        setTimeout('AjaxRegistroGestionTarea()', 2000);
    } else {
        notificar_warning("Complete :<br>" + error);
    }
}
function AjaxRegistroGestionTarea() {
    var formData = new FormData($("#FormularioGestionTarea")[0]);
    console.log(formData);
    var idProyecto=$("#idProyecto").val();
    var idActividad=$("#idActividad").val();
	 var idTarea=$("#idTarea").val();
    formData.append("idProyecto",idProyecto);
    formData.append("idActividad",idActividad);
    formData.append("idTarea",idTarea);
    $.ajax({
        url: "../../controlador/Gestion/CGestion.php?op=RegistroGestionTarea",
        type: "POST",
        data: formData,
        contentType: false,
        processData: false,
        success: function (data, status) {
            data = JSON.parse(data);
            console.log(data);
            var Mensaje = data.Mensaje;
            var Error = data.Registro;
            if (!Error) {
                $("#ModalGestionTarea #cuerpo").removeClass("whirl");
                $("#ModalGestionTarea #cuerpo").removeClass("ringed");
                $("#ModalGestionTarea").modal("hide");
                swal("Error:", Mensaje);
                LimpiarGestionTarea();
                tablaTareaGestion.ajax.reload();
            } else {
                $("#ModalGestionTarea #cuerpo").removeClass("whirl");
                $("#ModalGestionTarea #cuerpo").removeClass("ringed");
                $("#ModalGestionTarea").modal("hide");
                swal("Acción:", Mensaje);
                LimpiarGestionTarea();
                tablaTareaGestion.ajax.reload();
            }
        }
    });
}
function MostrarInformacionTarea(idTarea){
	 	//solicitud de recuperar Proveedor
	$.post("../../controlador/Gestion/CGestion.php?op=RecuperarInformacionTarea",{"idTarea":idTarea}, function(data, status){
		data = JSON.parse(data);
		console.log(data);

    $("#tarea_1").append();
    $("#tarea_1").html("<b>"+(data.NombreTarea).toUpperCase()+"</b>");
    $("#tarea_2").append();
    $("#tarea_2").html("<b>"+(data.fechaInicio).toUpperCase()+"</b>");
    $("#tarea_3").append();
    $("#tarea_3").html("<b>"+(data.fechaFin).toUpperCase()+"</b>");
	 $("#tarea_4").append();
    $("#tarea_4").html("<b>"+(data.diasT).toUpperCase()+"</b>");

	});
}
function Listar_Gestion(idTarea){
	tablaTareaGestion = $('#tablaGestionTarea').dataTable({
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
               , "targets": [0,1,2]
            }
            , {
               "className": "text-left"
               , "targets": [1,2,3]
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
            /*, {
               extend: 'pdf'
               , className: 'btn-info'
               , title: $('title').text()
            }*/
            , {
               extend: 'print'
               , className: 'btn-info'
            }
            ],
         "ajax": { //Solicitud Ajax Servidor
			url: '../../controlador/Gestion/CGestion.php?op=ListarGestionTarea',
			type: "POST",
			dataType: "JSON",
			data:{idTarea:idTarea},
			error: function (e) {
				console.log(e.responseText);
			}
		},
		// cambiar el lenguaje de datatable
		oLanguage: español,
	}).DataTable();
	//Aplicar ordenamiento y autonumeracion , index
	tablaTareaGestion.on('order.dt search.dt', function () {
		tablaTareaGestion.column(0, {
			search: 'applied',
			order: 'applied'
		}).nodes().each(function (cell, i) {
			cell.innerHTML = i + 1;
		});
	}).draw();
}
function LimpiarGestionTarea() {
    $('#FormularioGestionTarea')[0].reset();
    $('#date_inicio').datepicker( "option" , {
        minDate: null,
        maxDate: null} );
    $('#date_fin').datepicker( "option" , {
        minDate: null,
        maxDate: null} );
 }
function CancelarGestion(){
	LimpiarGestionTarea();
	$("#ModalGestionTarea").modal("hide");
}
function volver(){
	var idProyecto = $("#idProyecto").val();
    $.redirect('Operaciones.php', {
        'idProyecto': idProyecto
    });
}
function NuevaGestion(){
	var idTarea=$("#idTarea").val();
	Recuperar_Fechas(idTarea);


}
function Recuperar_Fechas(idTarea){
	 	//solicitud de recuperar Proveedor
	$.post("../../controlador/Gestion/CGestion.php?op=RecuperarInformacionFechas",{"idTarea":idTarea}, function(data, status){
		data = JSON.parse(data);
		console.log(data);

		 var fechaInicio=data.FechaInicio;
		 var fechaFin=data.FechaFin;

		 var day = parseInt(fechaInicio.substr(0, 2));
		 var month = parseInt(fechaInicio.substr(3, 2));
	    var year = parseInt(fechaInicio.substr(6, 8));
		 var day2 = parseInt(fechaFin.substr(0, 2));
		 var month2 = parseInt(fechaFin.substr(3, 2));
	    var year2 = parseInt(fechaFin.substr(6, 8));
		 $('#date_inicio').datepicker('setStartDate', new Date(year, (month - 1), day));
		 $('#date_fin').datepicker('setEndDate', new Date(year2, (month2 - 1), day2));

   $("#ModalGestionTarea").modal({
      backdrop: 'static'
      , keyboard: false
    });
	$("#ModalGestionTarea").modal("show");
	});

}
init();
