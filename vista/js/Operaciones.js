var tablaOperacion
var tablaOperacionUsuario;

function init(){

var perfil=$("#PerfilCodigo").val();
MostrarVentana(perfil);



Recuperar_Informacion();


}

function MostrarVentana(perfil){
 console.log(perfil);
if(perfil==6){
    $("#panel_administrador").hide();
    $("#panel_empleado").show();
    Mostrar_Informacion_Persona();
   }else{
    $("#panel_administrador").show();
    $("#panel_empleado").hide();
    Listar_Operacion();
   }

}
function Mostrar_Informacion_Persona(){
	tablaOperacionUsuario = $('#tablaOperaciones2').dataTable({
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
               , "targets": [0,1,2,3,4]
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
			url: '../../controlador/Gestion/CGestion.php?op=Listar_Operaciones_Usuario',
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
	tablaOperacionUsuario.on('order.dt search.dt', function () {
		tablaOperacionUsuario.column(0, {
			search: 'applied',
			order: 'applied'
		}).nodes().each(function (cell, i) {
			cell.innerHTML = i + 1;
		});
	}).draw();
}
function Recuperar_Informacion(){

    //solicitud de recuperar Proveedor
	$.post("../../controlador/Gestion/CGestion.php?op=RecuperarInformacion",function(data, status){
		data = JSON.parse(data);
		console.log(data);
$("#total_proyectos").append();
$("#total_tareas").append();
$("#total_empleados").append();
$("#total_usuarios").append();

$("#total_proyectos").html("<b>"+data.Proyectos+"</b>");
$("#total_tareas").html("<b>"+data.Tareas+"</b>");
$("#total_empleados").html("<b>"+data.Empleados+"</b>");
$("#total_usuarios").html("<b>"+data.Usuarios+"</b>");
	});

}



function Listar_Operacion(){
	tablaOperacion = $('#tablaOperaciones').dataTable({
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
			url: '../../controlador/Gestion/CGestion.php?op=Listar_Operaciones',
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
	tablaOperacion.on('order.dt search.dt', function () {
		tablaOperacion.column(0, {
			search: 'applied',
			order: 'applied'
		}).nodes().each(function (cell, i) {
			cell.innerHTML = i + 1;
		});
	}).draw();
}

function MostrarGestionAlumnos(){
    $.redirect('../Mantenimiento/MantAlumno.php');
}

function MostrarGestionApoderados(){
    $.redirect('../Mantenimiento/MantApoderado.php');
}

function PagoMatricula(idPlan,idAlumno){
    $.redirect('../Operaciones/PagoMatricula.php',{'idPlan':idPlan,'idAlumno':idAlumno});

}
function PagoCuota(idPlan,idAlumno){
    $.redirect('../Operaciones/PagoCuota.php',{'idPlan':idPlan,'idAlumno':idAlumno});
}

function verSubtareas(idProyecto,idTarea){
     $.redirect('../Mantenimiento/MantSubTarea.php',{'idTarea':idTarea,'idProyecto':idProyecto});
}
init();
