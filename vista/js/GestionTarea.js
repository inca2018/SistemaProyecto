var tablaTareaGestion;
function init(){
	var idProyecto=$("#idProyecto").val();
	var idActividad=$("#idActividad").val();
	var idTarea=$("#idTarea").val();

	MostrarInformacionTarea(idTarea);

	$("#FormularioGestionTarea").on("submit",function(e)
	{
	      RegistroTarea(e);
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

	});
}
function Listar_Operacion(){
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
               , "targets": [0,1,2,3,4,5,6,7]
            }
            , {
               "className": "text-left"
               , "targets": [1,2,3,4]
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

function Cancelar(){
	$("#ModalGestionTarea").show("hide");
}

init();
