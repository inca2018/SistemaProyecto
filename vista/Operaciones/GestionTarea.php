<?php
    if(isset($_POST['idTarea'])){

    }else{
        header('Location: ../../vista/Operaciones/Operaciones.php');
    }
?>
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
		<!-- <div class="content-heading">
              <div>Mantenimiento Grados</div>
            </div> -->
		<!-- START card-->
		<form method="post" id="formularioTarea">

		<input type="hidden" id="PerfilCodigo" name="PerfilCodigo" value="<?php echo $_SESSION['perfil'];?>">
		<input type="hidden" id="idProyecto" name="idProyecto" value="<?php echo $_POST['idProyecto'];?>">
		<input type="hidden" id="idActividad" name="idActividad" value="<?php echo $_POST['idActividad'];?>">
		<input type="hidden" id="idTarea" name="idTarea" value="<?php echo $_POST['idTarea'];?>">


		<div class="card sombra2 ">
			<div class="card-body" id="panel_gestion_tareas">
				<div class="row ">
					<div class="col-md-12 w-100 text-center ">
						<h3>Gestión de Tareas:</h3>
					</div>
				</div>
				 <hr class="mt-3 mb-3">
                <h5 class="mt-3 mb-3 titulo_area"><em><b>Información de Tarea:</b></em></h5>
                <div class="row m-1">
                    <div class="col-12 col-md-3 br  bb bl bt">
                        <div class="form-group">
                            <label class="text-center w-100  text-muted"><em>Nombre del Tarea:</em></label>
                            <h5 class="text-center " id="tarea_1"><b> </b></h5>
                        </div>
                    </div>
                    <div class="col-12 col-md-3 br  bb bl bt">
                        <div class="form-group">
                            <label class="text-center w-100 text-muted"><em>Fecha Inicio:</em></label>
                            <h5 class="text-center" id="tarea_2"><b> </b></h5>
                        </div>
                    </div>
                    <div class="col-12 col-md-3 br  bb bl bt">
                        <div class="form-group">
                            <label class="text-center w-100 text-muted"><em>Fecha Fin:</em></label>
                            <h5 class="text-center" id="tarea_3"><b> </b></h5>
                        </div>
                    </div>
                     <div class="col-12 col-md-3 br  bb bl bt">
                        <div class="form-group">
                            <label class="text-center w-100 text-muted"><em>Dias Asignados:</em></label>
                            <h5 class="text-center" id="tarea_4"><b> </b></h5>
                        </div>
                    </div>
                    <div class="col-12 col-md-3 br  bb bl  ">
                        <div class="form-group">
                            <label class="text-center w-100  text-muted"><em>Avance de Tarea:</em></label>
                            <h5 class="text-center " id="tarea_avance"><b> </b></h5>
                        </div>
                    </div>
                     <div class="col-12 col-md-3 br  bb bl  ">
                        <div class="form-group">
                            <label class="text-center w-100  text-muted"><em>Descripción de la Tarea:</em></label>
                            <h5 class="text-center " id="tarea_5"><b> </b></h5>
                        </div>
                    </div>
                    <div class="col-12 col-md-3 br  bb bl">
							<div class="form-group">
								<label>Ajuntar Documento:</label>
								<input class="form-control filestyle" type="file" name="adjuntar_documento" id="adjuntar_documento" data-classbutton="btn btn-secondary sombra3" data-classinput="form-control inline" data-icon="&lt;span class='fa fa-upload mr-2 '&gt;&lt;/span&gt;" accept="application/pdf" required>
							</div>
						</div>
                  <div class="col-12 col-md-3 br  bb bl">
							<div class="form-group">
								<label>Finalizar Tarea:</label>
								<button type="submit" class="btn btn-primary btn-block "  id="finalizarOpcion" disabled>FINALIZAR</button>
							</div>
						</div>

                </div>
				<hr class="mt-2 mb-2">

                <div class="row">
                    <div class="col-md-2">
                        <button type="button" class="btn btn-info btn-block btn-sm" onclick="volver();"><i class="fas fa-chevron-circle-left fa-lg mr-2"></i> Operaciones</button>
                    </div>
                    <div class="col-md-2 offset-8">
                        <button  type="button" class="btn btn-success btn-block btn-sm" onclick="NuevaGestion();"><i class="fa fa-plus fa-lg mr-2"></i> Nueva Registro de Dias</button>
                    </div>
                </div>
            <hr class="mt-2 mb-2">
				<h5 class="mt-3 mb-3 titulo_area"><em><b>Información de Avance:</b></em></h5>
				<div class="row ">
					<div class="col-md-12">
						<div class="row">
							<div class="col-md-12">
								<table class="table w-100 table-hover table-sm dt-responsive nowrap" id="tablaGestionTarea" style="font-size:13px">
									<thead class="thead-light text-center">
										<tr>
											<th data-priority="1">#</th>
											<th>TAREA</th>
											<th>DETALLE DE AVANCE</th>
											<th>DIAS TOTALES</th>
											<th>DIAS AVANCE</th>
											<th>FECHA AVANCE</th>
											<th>ACCION</th>
										</tr>
									</thead>
									<tbody>
									</tbody>
								</table>
							</div>

						</div>
					</div>
				</div>

			</div>
		</div>
		</form>
	</div>
</section>
<!-- Fin Modal Agregar-->
<!-- Fin del Cuerpo del Sistema del Menu-->
<!-- Inicio del footer -->
<?php require_once('../layaout/Footer.php');?>
<!-- Fin del Footer -->


<div class="modal fade " id="ModalGestionTarea" role="dialog" aria-labelledby="myModalLabelLarge" aria-hidden="true">
    <div class="modal-dialog modal-lg  ">
        <div class="modal-content">
            <div class="row m-1 bb">
                <div class="col-md-12">
                    <h4 class="text-center text-">Gestión de Tarea</h4>
                </div>
            </div>
            <div class="modal-body ">
                <form id="FormularioGestionTarea" method="POST" autocomplete="off">

                    <input type="hidden" name="idSubTarea" id="idSubTarea">
                    <div class="row mb-3 mt-1">
                        <div class="col-md-3">
                            <label class=""><span class="red">(*) Campos Obligatorios</span></label>
                        </div>
                        <div class="col-md-1 offset-8">
                            <button type="button" class="btn btn-info btn-sm btn-display" title="Limpiar Campos" onclick="LimpiarGestionTarea();">
                                <i class="fa fa-trash-alt fa-lg "></i>
                            </button>
                        </div>
                    </div>

                    <div class="row" id="cuerpo">
                        <div class="col-md-12   bl">

                            <div class="row">

                                <div class="col-md-12">
                                    <label for="SubTareaDescripcion" class="col-form-label">Detalle de Avance de Tarea:</label>
                                    <textarea id="detalle" name="detalle" rows="4" class="form-control text-left validarPanel" data-message="- Campo  Descripción de Tarea">
                                    </textarea>
                                </div>
                                <div class="col-md-4">
                                   <label class="col-form-label">Fecha Inicio:</label>
                                   <div class="input-group date" id="date_inicio" >
                                       <input class="form-control validarPanel" type="text" id="inicio" name="inicio" data-message="- Campo Fecha de Inicio">
                                       <span class="input-group-append input-group-addon">
                                       <span class="input-group-text"><i class="fa fa-calendar"></i></span>
                                       </span>
                                   </div>
                                </div>
                                <div class="col-md-4">
                                   <label class="col-form-label">Fecha Fin:</label>
                                   <div class="input-group date" id="date_fin" >
                                       <input class="form-control validarPanel" type="text" id="fin" name="fin" data-message="- Campo Fecha Fin">
                                       <span class="input-group-append input-group-addon">
                                       <span class="input-group-text"><i class="fa fa-calendar"></i></span>
                                       </span>
                                   </div>
                                </div>

                            </div>
                            <hr>
                            <div class="row mr-1 ml-1">
                                <button type="submit" class="col-md-2 btn btn-success btn-sm" title="Guardar">
                                    <i class="fa fa-save fa-lg mr-2"></i>GUARDAR
                                </button>

                                <button type="button" class="col-md-2 btn btn-danger btn-sm  offset-8" title="Cancelar" onclick="CancelarGestion();">
                                    <i class="fa fa-times fa-lg mr-2"></i>CANCELAR
                                </button>

                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>


<script src="<?php echo $conexionConfig->rutaOP(); ?>vista/js/GestionTarea.js"></script>
