var datos;
var datos2;
var config;
var config2;
var sumaDisponible=0;
var sumaNoDisponible=0;
var sumaDisponible2=0;
var sumaNoDisponible2=0;
var cuerpo="";
var cuerpo2="";
var cont=0;

var tabladetalle1;
var tabladetalle2;

function init(){
Listar_Proyectos();
	iniciar();
	Mostrar_Indicadores1();
	Mostrar_Indicadores2();
}

function Listar_Proyectos(){
	 $.post("../../controlador/Reporte/CReporte.php?op=listar_Proyectos", function (ts) {
      $("#SeleccionProyecto").append(ts);
   });
}

function iniciar(){

    $('#date_inicio1').datepicker({
			 format: 'dd/mm/yyyy',

        });
	$('#date_fin1').datepicker({

		    format: 'dd/mm/yyyy',
    });

	$('#date_inicio1').datepicker().on('changeDate', function (ev) {
	    var f_inicio=$("#inicio1").val();
		 var f_fin=$("#fin1").val();
	   var day = parseInt(f_inicio.substr(0,2));
		var month = parseInt(f_inicio.substr(3,2));
		var year = parseInt(f_inicio.substr(6,8));
	 $('#date_fin1').datepicker('setStartDate',new Date(year,(month-1),day));
   });

	$('#date_fin1').datepicker().on('changeDate', function (ev) {
	    var f_inicio=$("#inicio1").val();
		 var f_fin=$("#fin1").val();
		var day = parseInt(f_fin.substr(0,2));
		var month = parseInt(f_fin.substr(3,2));
		var year = parseInt(f_fin.substr(6,8));

	 $('#date_inicio1').datepicker('setEndDate',new Date(year,(month-1),day));
   });

}
function Mostrar_Indicadores1(){
		 datos = {
						               type: "pie",
										data : {
											datasets :[{
												data :[
														1,
														1,

													],
												backgroundColor: [

													"#F93E3A",
													"#6BE030",


												],
											}],

											labels : [

												"Precio de lo pendiente por Avanzar",
												"Precio total del Avance Real",


											]
										   },
										options : {
											responsive : true,

										}

									};

			                 var canvas = document.getElementById('chart1').getContext('2d');
					         window.pie = new Chart(canvas, datos);
}
function Mostrar_Indicadores2(){
		 datos2 = {
						               type: "pie",
										data : {
											datasets :[{
												data :[
														1,
														1,

													],
												backgroundColor: [

													"#F93E3A",
													"#6BE030",


												],
											}],

											labels : [

												"Porcentaje de lo Pendiente",
												"Porcentaje de lo Avanzado",


											]
										   },
										options : {
											responsive : true,

										}

									};

			                 var canvas2 = document.getElementById('chart2').getContext('2d');
					         window.pie2 = new Chart(canvas2, datos2);
}
function buscar_reporte(){

   var f_inicio=$("#inicio1").val();
   var f_fin=$("#fin1").val();
	var idPro=$("#SeleccionProyecto").val();

	if(f_inicio=='' || f_fin=='' || idPro==''){
		  	notificar_warning("Seleccione Fechas y Proyecto")
		}else{
			actualizar_indicadores1(f_inicio,f_fin,idPro);
			$("#body_detalles1").empty();
         $("#body_detalles2").empty();
		}
}
function actualizar_indicadores1(f_inicio,f_fin,idPro){

	$.post("../../controlador/Gestion/CGestion.php?op=RecuperarReporteFechas",{inicio:f_inicio,fin:f_fin,idProyecto:idPro}, function(data, status){
      data = JSON.parse(data);
		console.log(data);

	 var horasProgramadas = parseFloat(data.HorasProgramadas);
    var horasRealizadas = parseFloat(data.HorasRealizadas);
    var costoPresupuesto = parseFloat(data.CostoPresupuestado);
    var costoRealizado = parseFloat(data.CostoRealizado).toFixed(2);
    var costoNoRealizado = parseFloat(data.CostoNoRealizado).toFixed(2);
    var porcAvance = parseFloat(data.PorcentajeAvance).toFixed(2);
    var porcNoAvance = parseFloat(data.PorcentajeNoAvance).toFixed(2);

    var costoDia=parseFloat(costoPresupuesto/horasProgramadas).toFixed(2);
    var costoRealizado=parseFloat(costoDia*horasRealizadas).toFixed(2);
     var costoPendiente=parseFloat(costoDia*(horasProgramadas-horasRealizadas));
    var DiaPend=parseFloat(horasProgramadas-horasRealizadas);

     $("#variable1").append();
     $("#variable2").append();
     $("#variable3").append();
     $("#variable4").append();
     $("#variable5").append();
     $("#variable6").append();
     $("#variable7").append();

     $("#variable1").html("<b>"+DiaPend+" Dias</b>");
     $("#variable2").html("<b>"+horasRealizadas+" Dias</b>");
     $("#variable3").html("<b>S/. "+Formato_Moneda(costoPresupuesto,2)+"</b>");
     $("#variable4").html("<b>S/. "+Formato_Moneda(costoRealizado,2)+"</b>");
     $("#variable5").html("<b>S/. "+Formato_Moneda(costoPendiente,2)+"</b>");
     $("#variable6").html("<b>"+porcAvance+" %</b>");
     $("#variable7").html("<b>"+porcNoAvance+" %</b>");

		datos.data.datasets.splice(0);


		var newData = {
									backgroundColor : [
										"#F93E3A",
										"#6BE030",

									],
									data : [parseFloat(costoPendiente).toFixed(2),parseFloat(costoRealizado).toFixed(2)]
								};
		datos.data.datasets.push(newData);
		window.pie.update();


        datos2.data.datasets.splice(0);

		var newData = {
									backgroundColor : [
										"#F93E3A",
										"#6BE030",

									],
									data : [parseFloat(porcNoAvance).toFixed(2),parseFloat(porcAvance).toFixed(2)]
								};
		datos2.data.datasets.push(newData);
		window.pie2.update();

    });
}
function detalles1(){

    var inicio=$("#inicio1").val();
    var fin=$("#fin1").val();
	 var idPro=$("#SeleccionProyecto").val();
    if(inicio=='' || fin=='' || idPro==''){
         swal("Error!", "Seleccione todos los indicadores para buscar reporte!.", "warning");
    }else{
        $('#modal_detalles2').modal({backdrop: 'static', keyboard: false})
        $("#modal_detalles2").modal('show');

       mostrar_Tabla_detalles1(inicio,fin,idPro);
    }

}
function detalles2(){

   var inicio=$("#inicio1").val();
    var fin=$("#fin1").val();
	 var idPro=$("#SeleccionProyecto").val();
    if(inicio=='' || fin=='' || idPro==''){
      swal("Error!", "Seleccione todos los indicadores para buscar reporte!.", "warning");
    }else{
        $('#modal_detalles1').modal({backdrop: 'static', keyboard: false})
        $("#modal_detalles1").modal('show');

       mostrar_Tabla_detalles2(inicio,fin,idPro);
    }

}

function mostrar_Tabla_detalles1_REP(inicio,fin,idp){
	  cuerpo="";
	 $.post("../../controlador/Gestion/CGestion.php?op=RecuperarReporte",{inicio:inicio,fin:fin,idProyecto:idp}, function(data, status){
      data = JSON.parse(data);
         console.log(data);

     for (var i in data) {
         //console.log("entro:"+i);
       var dato=data[i];
        //console.log(data);
		 var actividad=dato.actividad;
		 var fecha=dato.fecha;
		 var presupuesto=dato.presupuesto;
		 var avance=dato.avance;
		 var noavance=dato.noavance;
        var corre=(parseInt(i)+1);
         cuerpo=cuerpo+"<tr><th>"+corre+"</th><th class='text-center'>"+actividad+"</th><th class='text-center'>"+fecha+"</th><th class='text-center'>"+verificar(parseFloat(presupuesto))+"</th><th class='text-center'>"+verificar(parseFloat(avance/100))+"</th><th class='text-center'>"+verificar(parseFloat(presupuesto)*parseFloat(avance/100))+"</th></tr>";
        }
        $("#body_detalles2").empty();
        $("#body_detalles2").append(cuerpo);
   });
}

function mostrar_Tabla_detalles2_REP(inicio,fin,ipd){
	     cuerpo2="";
	 $.post("../../controlador/Gestion/CGestion.php?op=RecuperarReporte",{inicio:inicio,fin:fin,idProyecto:ipd}, function(data, status){
      data = JSON.parse(data);
         console.log(data);

     for (var i in data) {

         //console.log("entro:"+i);
       var dato=data[i];
        //console.log(data);
       var actividad=dato.actividad;
		 var fecha=dato.fecha;
		 var presupuesto=dato.presupuesto;
		 var avance=dato.avance;
		 var noavance=dato.noavance;

         var corre=(parseInt(i)+1);
         cuerpo2=cuerpo2+"<tr><th>"+corre+"</th><th class='text-center'>"+actividad+"</th><th class='text-center'>"+fecha+"</th><th class='text-center'>"+verificar(parseFloat(presupuesto)*parseFloat(avance/100))+"</th><th class='text-center'>"+verificar(parseFloat(presupuesto))+"</th><th class='text-center'>"+verificar( parseFloat((parseFloat(presupuesto)*parseFloat(avance/100))/(verificar(parseFloat(presupuesto)))).toFixed(2) )+"</th></tr>";
        }

        $("#body_detalles1").empty();
        $("#body_detalles1").append(cuerpo2);

   });
}
function mostrar_Tabla_detalles2(inicio,fin,ipd){
	tabladetalle1 = $('#tablaDetalles1').dataTable({
		"aProcessing": true,
		"aServerSide": true,
		"processing": true,
		"paging": false, // Paginacion en tabla
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
               , "targets": [1]
            }
            , {
               "className": "text-left"
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
               , title: 'Reporte'
            }
            , {
				extend: 'pdfHtml5',
				className: 'btn-info sombra3',
				title: "Reporte",
				orientation: 'landscape',
				pageSize: 'LEGAL'
            }
            , {
               extend: 'print'
               , className: 'btn-info'
            }
            ],
         "ajax": { //Solicitud Ajax Servidor
			url: '../../controlador/Gestion/CGestion.php?op=RecuperarReporte1',
			type: "POST",
			dataType: "JSON",
			data:{inicio:inicio,fin:fin,idProyecto:ipd},
			error: function (e) {
				console.log(e.responseText);
			}
		},
		// cambiar el lenguaje de datatable
		oLanguage: español,
	}).DataTable();
	//Aplicar ordenamiento y autonumeracion , index
	tabladetalle1.on('order.dt search.dt', function () {
		tabladetalle1.column(0, {
			search: 'applied',
			order: 'applied'
		}).nodes().each(function (cell, i) {
			cell.innerHTML = i + 1;
		});
	}).draw();
}
function mostrar_Tabla_detalles1(inicio,fin,ipd){
	tabladetalle2 = $('#tablaDetalles2').dataTable({
		"aProcessing": true,
		"aServerSide": true,
		"processing": true,
		"paging": false, // Paginacion en tabla
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
               , "targets": [1]
            }
            , {
               "className": "text-left"
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
               , title: 'Reporte'
            }
            , {
				extend: 'pdfHtml5',
				className: 'btn-info sombra3',
				title: "Reporte",
				orientation: 'landscape',
				pageSize: 'LEGAL'
            }
            , {
               extend: 'print'
               , className: 'btn-info'
            }
            ],
         "ajax": { //Solicitud Ajax Servidor
			url: '../../controlador/Gestion/CGestion.php?op=RecuperarReporte2',
			type: "POST",
			dataType: "JSON",
			data:{inicio:inicio,fin:fin,idProyecto:ipd},
			error: function (e) {
				console.log(e.responseText);
			}
		},
		// cambiar el lenguaje de datatable
		oLanguage: español,
	}).DataTable();
	//Aplicar ordenamiento y autonumeracion , index
	tabladetalle2.on('order.dt search.dt', function () {
		tabladetalle2.column(0, {
			search: 'applied',
			order: 'applied'
		}).nodes().each(function (cell, i) {
			cell.innerHTML = i + 1;
		});
	}).draw();
}


function verificar(dato){
    if(isNaN(dato)){
        return 0;
    }else{
        var dato_Redondenado=Math.round(dato * 100) / 100;
        return dato_Redondenado;
    }
}

init();
