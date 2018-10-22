<?php
    if(isset($_POST['idActividad'])){

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
        <input type="hidden" id="idProyecto" name="idProyecto"  value="<?php echo $_POST['idProyecto'];?>">
        <input type="hidden" name="idActividad" id="idActividad" value="<?php echo $_POST['idActividad'];?>">
        <!-- START card-->
        <div class="card card-default m-1 ">
            <div class="card-body ">
                <div class="row ">
                    <div class="col-md-12 w-100 text-center ">
                        <h3>Mantenimiento de Tareas:</h3>
                    </div>
                </div>
                <hr class="mt-2 mb-2">
                <div class="row">
                    <div class="col-md-2">
                        <button class="btn btn-info btn-block btn-sm" onclick="Volver();"><i class="fas fa-chevron-circle-left fa-lg mr-2"></i> Actividades</button>
                    </div>
                    <div class="col-md-2 offset-8">
                        <button class="btn btn-success btn-block btn-sm" onclick="NuevoSubTarea();"><i class="fa fa-plus fa-lg mr-2"></i> Nueva Tarea</button>
                    </div>
                </div>
                <h5 class="mt-3 mb-3 titulo_area"><em><b>Lista General de Tarea:</b></em></h5>
                <div class="row ">
                    <div class="col-md-12">
                        <div class="row">
                            <div class="col-md-12">
                                <table class="table w-100 table-hover table-sm dt-responsive nowrap" id="tablaSubTarea">
                                    <thead class="thead-light text-center">
                                        <tr>
                                            <th data-priority="1">#</th>
                                            <th>ESTADO</th>
                                            <th>ACTIVIDAD</th>
                                            <th>TAREA</th>
                                            <th>DESCRIPCIÓN</th>
                                            <th>F.INICIO-F.FIN</th>
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
            <div class="modal-body ">
                <form id="FormularioSubTarea" method="POST" autocomplete="off">

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
                                <div class="col-md-12">
                                            <label for="ClienteNombre" class="col-form-label">Tarea<span class="red">*</span>:</label>
                                            <input class="form-control validarPanel" id="TareaNombre" name="TareaNombre" data-message="- Campo  Nombre de Tarea"  placeholder="Nombre de Tarea" type="text" maxlength="150">
                                </div>
                                <div class="col-md-12">
                                    <label for="SubTareaDescripcion" class="col-form-label">Descripción de Tarea:</label>
                                    <textarea id="SubTareaDescripcion" name="SubTareaDescripcion" rows="4" class="form-control text-left validarPanel" data-message="- Campo  Descripción de Tarea">
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
                                <div class="col-md-4">
                                    <label for="SubTareaEstado" class="col-form-label">Estado<span class="red">*</span>:</label>
                                    <select class="form-control validarPanel" id="SubTareaEstado" name="SubTareaEstado" data-message="- Campo Estado">
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


<script src="<?php echo $conexionConfig->rutaOP(); ?>vista/js/MantSubTarea.js"></script>
