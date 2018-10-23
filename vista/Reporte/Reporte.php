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

            <!-- START card-->
            <div class="card card-default">
               <div class="card-body">
							<div class="row ">
                            <div class="col-md-12 w-100 text-center ">
                                <h3>Panel de Reporte:</h3>
                            </div>
							</div>
							<div class="row">
								<div class="col-md-6 col-12">
										<div class="form-group">
										<label>Seleccione Proyecto:</label>
										   <select class="form-control" id="SeleccionProyecto">
										</select>
										</div>
                            </div>
							</div>

 							<div class="row justify-content-center m-3">
								 <div class="col-md-4 col-12">
                                        <div class="form-group row">
                                            <label for="inicio1" class="col-md-5 col-form-label"><i class="far fa-calendar-check fa-lg mr-2"></i>Fecha Inicio:<span class="red">*</span>:</label>
                                            <div class="col-md-7">
                                                <div class=" row">
																<div class="input-group date  col-md-12" id="date_inicio1"   >
																	<input class="form-control validarPanel" type="text" id="inicio1" name="inicio1"  autocomplete="off" data-message="- Fecha de Nacimiento">
																	<span class="input-group-append input-group-addon">
																		<span class="input-group-text "><i class="fa fa-calendar fa-lg"></i></span>
																	</span>
																</div>
															</div>
                                            </div>
                                        </div>
									</div>
                          <div class="col-md-4 col-12">
                                        <div class="form-group row">
                                            <label for="fin1" class="col-md-5 col-form-label"><i class="far fa-calendar-check fa-lg mr-2"></i>Fecha Fin:<span class="red">*</span>:</label>
                                            <div class="col-md-7">
                                                <div class=" row">
																<div class="input-group date  col-md-12" id="date_fin1"   >
																	<input class="form-control validarPanel" type="text" id="fin1" name="fin1"  autocomplete="off" data-message="- Fecha de Nacimiento">
																	<span class="input-group-append input-group-addon">
																		<span class="input-group-text "><i class="fa fa-calendar fa-lg"></i></span>
																	</span>
																</div>
															</div>
                                            </div>
                                        </div>
									</div>


                    </div>
                     <div class="row justify-content-center m-3">
                        <button type="button" class="btn btn-success col-md-6" onclick="buscar_reporte()">BUSCAR RESULTADOS</button>
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
                      	     <div class="row justify-content-center m-2">
                                    <button type="button" class="btn btn-info col-md-6" onclick="detalles1()">DETALLES</button>
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
                      	    <div class="row justify-content-center m-2">
                                    <button type="button" class="btn btn-info col-md-6" onclick="detalles2()">DETALLES</button>
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



  <div class="modal fade" id="modal_detalles1"  role="dialog" aria-labelledby="myModalLabelLarge" aria-hidden="true">
   <div class="modal-dialog modal-lg">
      <div class="modal-content">
         <div class="modal-header">
            <h4 class="modal-title" id="myModalLabelLarge">Indice de Desempeño del Cronograma: </h4>
            <button class="close" type="button" data-dismiss="modal" aria-label="Close" >
               <span aria-hidden="true">&times;</span>
            </button>
         </div>
         <div class="modal-body">
         <form id="formularioCliente" class="form-horizontal" method="POST">

              <table class="table my-4 w-100 table-hover table-sm dt-responsive nowrap" id="datatable_clientes">
                     <thead class="thead-light">
                       <tr>
                         <th data-priority="1">#</th>
                         <th>Fecha</th>
								 <th>Actividad</th>
                         <th>Valor Ganado(EV)</th>
                         <th>Valor Planfinicado(PV)</th>
                         <th>SPI=(EV/PV)</th>

                       </tr>
                     </thead>
                     <tbody id="body_detalles1">

                     </tbody>
                  </table>

            <div class="modal-footer">
               <button class="btn btn-secondary" type="button" data-dismiss="modal" >Cerrar</button>

            </div>
         </form>
         </div>
      </div>
   </div>
</div>

  <div class="modal fade" id="modal_detalles2"  role="dialog" aria-labelledby="myModalLabelLarge" aria-hidden="true">
   <div class="modal-dialog modal-lg">
      <div class="modal-content">
         <div class="modal-header">
            <h4 class="modal-title" id="myModalLabelLarge">Valor Ganado:</h4>
            <button class="close" type="button" data-dismiss="modal" aria-label="Close" >
               <span aria-hidden="true">&times;</span>
            </button>
         </div>
         <div class="modal-body">
         <form id="formularioCliente" class="form-horizontal" method="POST">

              <table class="table my-4 w-100 table-hover table-sm dt-responsive nowrap" id="datatable_clientes">
                     <thead class="thead-light">
                       <tr>
                         <th data-priority="1">#</th>
                         <th>Fecha</th>
                         <th>Actividad</th>
                         <th>Precio de Actividad (PAP)</th>
                         <th>Avance Real (%AR)</th>
                         <th>EV=(PAP X %AR)</th>

                       </tr>
                     </thead>
                     <tbody id="body_detalles2">

                     </tbody>
                  </table>

            <div class="modal-footer">
               <button class="btn btn-secondary" type="button" data-dismiss="modal" >Cerrar</button>

            </div>
         </form>
         </div>
      </div>
   </div>
</div>



<script src="<?php echo $conexionConfig->rutaOP(); ?>vista/js/Reporte.js"></script>
