<?php
    if(isset($_POST['idProyecto'])){

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
              <div>Mantenimiento Tareas</div>
            </div> -->
        <input type="hidden" name="idProyectoRecu" id="idProyectoRecu" value="<?php echo $_POST['idProyecto'];?>">
        <!-- START card-->
        <div class="card card-default m-1 ">
            <div class="card-body ">
                <div class="row ">
                    <div class="col-md-12 w-100 text-center ">
                        <h3>Mantenimiento de Actividades:</h3>
                    </div>
                </div>
                <hr class="mt-3 mb-3">
                <h5 class="mt-3 mb-3 titulo_area"><em><b>Información de Proyecto:</b></em></h5>
                <div class="row m-1">
                    <div class="col-12 col-md-3 br  bb bl bt">
                        <div class="form-group">
                            <label class="text-center w-100  text-muted"><em>Nombre del Proyecto:</em></label>
                            <h5 class="text-center " id="proyecto_1"><b> </b></h5>
                        </div>
                    </div>
                    <div class="col-12 col-md-3 br  bb bl bt">
                        <div class="form-group">
                            <label class="text-center w-100 text-muted"><em>Cliente del Proyecto:</em></label>
                            <h5 class="text-center" id="proyecto_2"><b> </b></h5>
                        </div>
                    </div>
                    <div class="col-12 col-md-3 br  bb bl bt">
                        <div class="form-group">
                            <label class="text-center w-100 text-muted"><em>Jefe del Proyecto:</em></label>
                            <h5 class="text-center" id="proyecto_3"><b> </b></h5>
                        </div>
                    </div>
                    <div class="col-12 col-md-3 br  bb bl bt">
                        <div class="form-group">
                            <label class="text-center w-100 text-muted" id="tipo_servicio_titulo"><em>Presupuesto del Proyecto:</em></label>
                            <h5 class="text-center" id="proyecto_4"><b>0</b></h5>
                        </div>
                    </div>
                </div>

                <div class="row mt-4">
                    <div class="col-md-2">
                        <button class="btn btn-info btn-block btn-sm" onclick="Volver();"><i class="fas fa-chevron-circle-left fa-lg mr-2"></i> Proyectos</button>
                    </div>
                    <div class="col-md-2 offset-8">
                        <button class="btn btn-success btn-block btn-sm" onclick="NuevoTarea();"><i class="fa fa-plus fa-lg mr-2"></i> Nueva Actividad</button>
                    </div>
                </div>
                <h5 class="mt-3 mb-3 titulo_area"><em><b>Lista General de Actividades:</b></em></h5>
                <div class="row ">
                    <div class="col-md-12">
                        <div class="row">
                            <div class="col-md-12">
                                <table class="table w-100 table-hover table-sm dt-responsive nowrap" id="tablaTarea" style="font-size:11px">
                                    <thead class="thead-light text-center">
                                        <tr>
                                            <th data-priority="1">#</th>
                                            <th>PARTICIPANTES</th>
                                            <th>ESTADO</th>
                                            <th>NOMBRE DE TAREA</th>
                                            <th>PROYECTO</th>
                                            <th>COSTO</th>
                                            <th>SUBTAREAS</th>
                                            <th>PARTICIPANTES</th>
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

<div class="modal fade " id="ModalTarea" role="dialog" aria-labelledby="myModalLabelLarge" aria-hidden="true">
    <div class="modal-dialog modal-lg  ">
        <div class="modal-content">
            <div class="row m-1 bb">
                <div class="col-md-12">
                    <h4 class="text-center text-" id="tituloModalTarea"></h4>
                </div>
            </div>
            <div class="modal-body ">
                <form id="FormularioTarea" method="POST" autocomplete="off">
                    <input type="hidden" name="idProyecto" id="idProyecto" value="<?php echo $_POST['idProyecto'];?>">
                    <input type="hidden" name="idTarea" id="idTarea">
                    <div class="row mb-3 mt-1">
                        <div class="col-md-3">
                            <label class=""><span class="red">(*) Campos Obligatorios</span></label>
                        </div>
                        <div class="col-md-1 offset-8">
                            <button type="button" class="btn btn-info btn-sm btn-display" title="Limpiar Campos" onclick="LimpiarTarea();">
                                <i class="fa fa-trash-alt fa-lg "></i>
                            </button>
                        </div>
                    </div>

                    <div class="row" id="cuerpo">
                        <div class="col-md-12   bl">

                            <div class="row">
                                <div class="col-md-12 ">
                                    <label for="TareaNombre" class=" col-form-label">Nombre de Actividad<span class="red">*</span>:</label>
                                    <input class="form-control validarPanel" id="TareaNombre" name="TareaNombre" data-message="- Campo    Nombre de Actividad" placeholder="Nombre de Actividad" type="text" maxlength="50">
                                </div>
                                <div class="col-md-12 ">
                                    <label for="TareaDescripcion" class="col-form-label">Descripción de Actividad:</label>
                                    <textarea id="TareaDescripcion" name="TareaDescripcion" rows="4" class="form-control text-left validarPanel" data-message="- Campo  Descripción de Actividad">
                                     </textarea>
                                </div>
                                <div class="col-md-6 ">
                                    <label for="TareaCosto" class="  col-form-label">Costo de Presupuesto<span class="red">*</span>:</label>
                                    <input class="form-control validarPanel" id="TareaCosto" name="TareaCosto" data-message="- Campo  Costo de Actividad" placeholder="Costo de Actividad" type="text" onkeypress="return SoloNumerosModificado(event,9,this.id);">
                                </div>

                                <div class="col-md-6 ">
                                        <label for="TareaEstado" class=" col-form-label"> Estado<span class="red">*</span>:</label>

                                            <select class="form-control validarPanel" id="TareaEstado" name="TareaEstado" data-message="- Campo Estado">
                                            </select>


                                </div>


                            </div>
                            <hr>
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


<script src="<?php echo $conexionConfig->rutaOP(); ?>vista/js/MantTarea.js"></script>
