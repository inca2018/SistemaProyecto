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
              <div>Mantenimiento Proyectos</div>
            </div> -->
            <!-- START card-->
            <div class="card card-default m-1 ">
               <div class="card-body ">
                        <div class="row ">
                            <div class="col-md-12 w-100 text-center ">
                                <h3>Mantenimiento de Proyecto:</h3>
                            </div>
                        </div>
                        <hr class="mt-2 mb-2">
                         <div class="row">
                            <div class="col-md-2 offset-10">
                                <button class="btn btn-success btn-block btn-sm" onclick="NuevoProyecto();"><i class="fa fa-plus fa-lg mr-2"></i> Nuevo Proyecto</button>
                            </div>
                        </div>
                        <h5 class="mt-3 mb-3 titulo_area" ><em><b>Lista General de Proyecto:</b></em></h5>
                        <div class="row ">
                            <div class="col-md-12">
                                <div class="row">
                                   <div class="col-md-12">
                                        <table class="table w-100 table-hover table-sm dt-responsive " id="tablaProyecto">
                                            <thead class="thead-light text-center">
                                                <tr>
                                                    <th data-priority="1" width="2%">#</th>
                                                    <th width="5%">ESTADO</th>
                                                    <th width="15%">NOMBRE DE PROYECTO</th>
                                                    <th width="10%">PRESUPUESTO</th>
                                                    <th width="10%">CLIENTE</th>
                                                    <th width="15%">JEFE DE PROYECTO</th>
                                                    <th width="10%">ACTIVIDADES</th>
                                                    <th width="13%">FECHA DE PROYECTO</th>
                                                    <th width="10%">ACCION</th>
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
         </div>
   </section>
    <!-- Fin Modal Agregar-->
<!-- Fin del Cuerpo del Sistema del Menu-->
<!-- Inicio del footer -->
<?php require_once('../layaout/Footer.php');?>
<!-- Fin del Footer -->

<div class="modal fade " id="ModalProyecto" role="dialog" aria-labelledby="myModalLabelLarge" aria-hidden="true">
	<div class="modal-dialog modal-lg  ">
		<div class="modal-content">
            <div class="row m-1 bb">
                <div class="col-md-12">
                    <h4 class="text-center text-" id="tituloModalProyecto"></h4>
                </div>
            </div>
			<div class="modal-body " >
				<form id="FormularioProyecto" method="POST" autocomplete="off">
                     <input type="hidden" name="idProyecto" id="idProyecto">
                     <div class="row mb-3 mt-1">
                         <div class="col-md-3">
                             <label class=""><span class="red">(*) Campos Obligatorios</span></label>
                         </div>
                         <div class="col-md-1 offset-8">
                              <button type="button" class="btn btn-info btn-sm btn-display" title="Limpiar Campos" onclick="LimpiarProyecto();">
                              <i class="fa fa-trash-alt fa-lg "></i>
                              </button>
                         </div>
                     </div>

					 <div class="row" id="cuerpo">
					      <div class="col-md-12   bl">

                                <div class="row">
                                      <div class="col-md-6 br">
                                        <div class="form-group row">
                                            <label for="ProyectoNombre" class="col-md-5 col-form-label">Nombre de Proyecto<span class="red">*</span>:</label>
                                            <div class="col-md-7">
                                                <input class="form-control validarPanel" id="ProyectoNombre" name="ProyectoNombre" data-message="- Campo  Nombre de Proyecto"  placeholder="Nombre de Proyecto" type="text" maxlength="150">

                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6 br">
                                        <div class="form-group row">
                                            <label for="ProyectoCliente" class="col-md-5 col-form-label">Cliente<span class="red">*</span>:</label>
                                            <div class="col-md-7">
                                                <select class="form-control validarPanel" id="ProyectoCliente" name="ProyectoCliente" data-message="- Campo Cliente del Proyecto">

                                                </select>
                                            </div>
                                        </div>
                                    </div>


                                     <div class="col-md-6 br">
                                        <div class="form-group row">
                                            <label for="ProyectoDescripcion" class="col-md-5 col-form-label">Descripción:</label>
                                            <div class="col-md-7">
                                                 <textarea id="ProyectoDescripcion" name="ProyectoDescripcion" rows="4" class="form-control text-left validarPanel" data-message="- Campo  Descripción de Proyecto">
                                                 </textarea>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6 br">
                                        <div class="form-group row">
                                            <label for="ProyectoJefe" class="col-md-5 col-form-label">Jefe de Proyecto<span class="red">*</span>:</label>
                                            <div class="col-md-7">
                                                <select class="form-control validarPanel" id="ProyectoJefe" name="ProyectoJefe" data-message="- Campo Jefe del Proyecto">

                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                  <div class="col-md-6 br">
                                        <div class="form-group row">
                                            <label for="ProyectoEstado" class="col-md-5 col-form-label">Estado<span class="red">*</span>:</label>
                                            <div class="col-md-7">
                                                <select class="form-control validarPanel" id="ProyectoEstado" name="ProyectoEstado" data-message="- Campo Estado">

                                                </select>
                                            </div>
                                        </div>
                                    </div>


                                </div>
                                <div class="row mr-1 ml-1">
                                           <button type="submit" class="col-md-2 btn btn-success btn-sm" title="Guardar">
                                              <i class="fa fa-save fa-lg mr-2"></i>GUARDAR
                                           </button>

                                           <button type="button" class="col-md-2 btn btn-danger btn-sm  offset-8" title="Cancelar" onclick="Cancelar();">
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


<script src="<?php echo $conexionConfig->rutaOP(); ?>vista/js/MantProyecto.js"></script>
