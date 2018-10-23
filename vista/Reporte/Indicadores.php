<!-- Inicio de Cabecera-->
<?php require_once('../layaout/Header.php');?>
<!-- fin Cabecera-->
<!-- Inicio del Cuerpo y Nav -->
<?php require_once('../layaout/Nav.php');?>
<!-- Fin  del Cuerpo y Nav -->
<!-- Cuerpo del sistema de Menu -->
   <!-- Main section-->
   <section class="section-container">
      <!-- Page content-->
      	<div class="content-wrapper">
            <div class="content-heading">
              <div>Indicadores</div>
            </div>
            <!-- START card-->
            <div class="card card-default">
               <div class="card-body">

                <div class="row">
                    		<div class="col-md-3 col-12">
										<div class="form-group">
										<label>Seleccione Proyecto:</label>
										   <select class="form-control" id="SeleccionProyecto">
										</select>
										</div>
                            </div>
                            <div class="col-md-3 col-12">


                                <button class=" btn btn-success sombra3 mt-4 btn-block" type="button"  onclick="buscar_reporte()"><i class="fa fa-search fa-1x mr-2  "></i>BUSCAR</button>

                            </div>
                    </div>

                    <div class="row" >
                      	<div class="col-md-6 col-12 br"  id="reporte_indicador1">
                            <h5 class="mt-3 mb-3 titulo_area" ><em><b>Indicador de Valor Ganado:</b></em></h5>
                            <div class="row">
 										<div class="col-12 col-md-4 br  ">
												<div class="form-group">
												  <label class="text-center w-100  text-muted"><em>Dias Pendientes:</em></label>
													<h5 class="text-center " id="variable1" ><b> </b></h5>
												</div>
										</div>
										<div class="col-12 col-md-4 br">
												<div class="form-group">
													<label class="text-center w-100 text-muted"><em>Dias Realizadas:</em></label>
													<h5 class="text-center" id="variable2"><b> </b></h5>
												</div>
										</div>
										<div class="col-12 col-md-4">
												<div class="form-group">
												  <label class="text-center w-100 text-muted" id="tipo_servicio_titulo"><em>Costo Presupuestado:</em></label>
													<h5 class="text-center" id="variable3"><b>-</b></h5>
												</div>
										</div>
 								</div>
                      	    <div class="row">
                      	      <div class="col-md-12">
                      	          <canvas id="chart1" class="mb-3"></canvas>
                      	      </div>
                      	    </div>

                      </div>
                      	<div class="col-md-6 col-12 br" id="reporte_indicador2">
                             <h5 class="mt-3 mb-3 titulo_area" ><em><b>Indicador de Desempeño del Cronograma:</b></em></h5>
                             <div class="row">
 										<div class="col-12 col-md-3 br  ">
												<div class="form-group">
												  <label class="text-center w-100  text-muted"><em>Costo Realizado:</em></label>
													<h5 class="text-center " id="variable4" ><b> </b></h5>
												</div>
										</div>
										<div class="col-12 col-md-3 br">
												<div class="form-group">
													<label class="text-center w-100 text-muted"><em>Costo No Realizado:</em></label>
													<h5 class="text-center" id="variable5"><b> </b></h5>
												</div>
										</div>
										<div class="col-12 col-md-3 br">
												<div class="form-group">
												  <label class="text-center w-100 text-muted" id="tipo_servicio_titulo"><em>% Avance:</em></label>
													<h5 class="text-center" id="variable6"><b>-</b></h5>
												</div>
										</div>
										<div class="col-12 col-md-3">
												<div class="form-group">
												  <label class="text-center w-100 text-muted" id="tipo_servicio_titulo"><em>% Pendiente:</em></label>
													<h5 class="text-center" id="variable7"><b>-</b></h5>
												</div>
										</div>
 								</div>
                      	    <div class="row">
                      	      <div class="col-md-12">
                      	          <canvas id="chart2" class="mb-3"></canvas>
                      	      </div>
                      	    </div>
                      </div>
                    </div>

               </div>
           </div>
         </div>
   </section>
    <!-- Fin Modal Agregar-->
<!-- Fin del Cuerpo del Sistema del Menu-->
<!-- Inicio del footer -->
<?php require_once('../layaout/Footer.php');?>
<!-- Fin del Footer -->

<script src="<?php echo $conexionConfig->rutaOP(); ?>vista/js/Indicadores.js"></script>
