var datos;
var datos2;
var config;
var config2;

function init(){
    Listar_Proyectos();

    Mostrar_Indicadores1();
    Mostrar_Indicadores2();
}

function buscar_reporte(){
    var idProyecto=$("#SeleccionProyecto").val();
    if(idProyecto==0 || idProyecto=='0'){
        notificar_warning("Seleccione Proyecto para visualizar información.");
    }else{
        accion(idProyecto);
    }

}

function Listar_Proyectos(){
	 $.post("../../controlador/Reporte/CReporte.php?op=listar_Proyectos", function (ts) {
      $("#SeleccionProyecto").append(ts);
   });
}

function accion(idProyecto){

 actualizar_indicadores(idProyecto);


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
function actualizar_indicadores(idProyecto){

$.post("../../controlador/Reporte/CReporte.php?op=RecuperarIndicadores",{'idProyecto':idProyecto}, function(data, status){
      data = JSON.parse(data);
		console.log(data);

    var horasNoProgramadas = parseInt(data.HorasProgramadas);
    var horasRealizadas = parseInt(data.HorasRealizadas);
    var costoPresupuesto = parseInt(data.CostoPresupuestado);
    var costoRealizado = parseInt(data.CostoRealizado);
    var costoNoRealizado = parseInt(data.CostoNoRealizado);
    var porcAvance = parseInt(data.PorcentajeAvance);
    var porcNoAvance = parseInt(data.PorcentajeNoAvance);

     $("#variable1").append();
     $("#variable2").append();
     $("#variable3").append();
     $("#variable4").append();
     $("#variable5").append();
     $("#variable6").append();
     $("#variable7").append();

     $("#variable1").html("<b>"+horasNoProgramadas+" h.</b>");
     $("#variable2").html("<b>"+horasRealizadas+"h.</b>");
     $("#variable3").html("<b>S/. "+Formato_Moneda(costoPresupuesto,2)+"</b>");
     $("#variable4").html("<b>S/. "+Formato_Moneda(costoRealizado,2)+"</b>");
     $("#variable5").html("<b>S/. "+Formato_Moneda(costoNoRealizado,2)+"</b>");
     $("#variable6").html("<b>"+porcAvance+" %</b>");
     $("#variable7").html("<b>"+porcNoAvance+" %</b>");

		datos.data.datasets.splice(0);


		var newData = {
									backgroundColor : [
										"#F93E3A",
										"#6BE030",

									],
									data : [costoRealizado,costoNoRealizado]
								};
		datos.data.datasets.push(newData);
		window.pie.update();


        datos2.data.datasets.splice(0);

		var newData = {
									backgroundColor : [
										"#F93E3A",
										"#6BE030",

									],
									data : [porcAvance,porcNoAvance]
								};
		datos2.data.datasets.push(newData);
		window.pie2.update();
    });
}
init();
