
<?php
    if(isset($_POST['idTarea'])){

    }else{
        header('Location: ../../vista/Mantenimiento/MantProyecto.php');
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
              <div>Mantenimiento SubTareas</div>
            </div> -->
            <input type="hidden" id="idProyecto" value="<?php echo $_POST['idProyecto'];?>">
            <input type="hidden" id="idTareaE" value="<?php echo $_POST['idTarea'];?>">
            <!-- START card-->
            <div class="card card-default m-1 ">
               <div class="card-body ">
                        <div class="row ">
                            <div class="col-md-12 w-100 text-center ">
                                <h3>Mantenimiento de SubTarea:</h3>
                            </div>
                        </div>
                        <hr class="mt-2 mb-2">
                         <div class="row">
                            <div class="col-md-2">
                                <button class="btn btn-info btn-block btn-sm" onclick="Volver();"><i class="fas fa-chevron-circle-left fa-lg mr-2"></i> Tareas</button>
                            </div>
                            <div class="col-md-2 offset-8">
                                <button class="btn btn-success btn-block btn-sm" onclick="NuevoSubTarea();"><i class="fa fa-plus fa-lg mr-2"></i> Nueva SubTarea</button>
                            </div>
                        </div>
                        <h5 class="mt-3 mb-3 titulo_area" ><em><b>Lista General de SubTarea:</b></em></h5>
                        <div class="row ">
                            <div class="col-md-12">
                                <div class="row">
                                   <div class="col-md-12">
                                        <table class="table w-100 table-hover table-sm dt-responsive nowrap" id="tablaSubTarea">
                                            <thead class="thead-light text-center">
                                                <tr>
                                                    <th data-priority="1">#</th>
                                                    <th>ESTADO</th>
                                                    <th>DESCRIPCION</th>
                                                    <th>HORAS REALIZADAS</th>
                                                    <th>TAREA</th>
                                                    <th>FECHA REGISTRO</th>
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
         </div>
   </section>
    <!-- Fin Modal Agregar-->
<!-- Fin del Cuerpo del Sistema del Menu-->
<!-- Inicio del footer -->
<?php require_once('../layaout/Footer.php');?>
<!-- Fin del Footer -->

<div class="modal fade " id="ModalSubTarea" role="dialog" aria-labelledby="myModalLabelLarge" aria-hidden="true">
	<div class="modal-dialog modal-lg  ">
		<div class="modal-content">
            <div class="row m-1 bb">
                <div class="col-md-12">
                    <h4 class="text-center text-" id="tituloModalSubTarea"></h4>
                </div>
            </div>
			<div class="modal-body " >
				<form id="FormularioSubTarea" method="POST" autocomplete="off">
                    <input type="hidden" name="idTarea" id="idTarea" value="<?php echo $_POST['idTarea'];?>">
                     <input type="hidden" name="idSubTarea" id="idSubTarea">
                     <div class="row mb-3 mt-1">
                         <div class="col-md-3">
                             <label class=""><span class="red">(*) Campos Obligatorios</span></label>
                         </div>
                         <div class="col-md-1 offset-8">
                              <button type="button" class="btn btn-info btn-sm btn-display" title="Limpiar Campos" onclick="LimpiarSubTarea();">
                              <i class="fa fa-trash-alt fa-lg "></i>
                              </button>
                         </div>
                     </div>

					 <div class="row" id="cuerpo">
					      <div class="col-md-12   bl">

                                <div class="row">

                                    <div class="col-md-6 br">
                                        <div class="form-group row">
                                            <label for="SubTareaDescripcion" class="col-md-5 col-form-label">Descripción:</label>
                                            <div class="col-md-7">
                                                 <textarea id="SubTareaDescripcion" name="SubTareaDescripcion" rows="4"  class="form-control text-left validarPanel" data-message="- Campo  Descripción de SubTarea">
                                                 </textarea>
                                            </div>
                                        </div>
                                    </div>
                                     <div class="col-md-6 br">
                                        <div class="form-group row">
                                            <label for="SubTareaHoras" class="col-md-5 col-form-label">Horas Realizadas<span class="red">*</span>:</label>
                                            <div class="col-md-7">
                                                <input class="form-control validarPanel" id="SubTareaHoras" name="SubTareaHoras" data-message="- Campo  Horas de SubTarea"  placeholder="Hora Realizada" type="text"   onkeypress="return SoloNumerosModificado(event,9,this.id);">

                                            </div>
                                        </div>
                                    </div>


                                      <div class="col-md-6 br">
                                        <div class="form-group row">
                                            <label for="SubTareaEstado" class="col-md-5 col-form-label">Estado<span class="red">*</span>:</label>
                                            <div class="col-md-7">
                                                <select class="form-control validarPanel" id="SubTareaEstado" name="SubTareaEstado" data-message="- Campo Estado">

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


<script src="<?php echo $conexionConfig->rutaOP(); ?>vista/js/MantSubTarea.js"></script>
