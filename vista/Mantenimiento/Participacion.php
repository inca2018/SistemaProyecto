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
              <div>Mantenimiento Tareas</div>
            </div> -->
        <input type="hidden" name="idActividad" id="idActividad" value="<?php echo $_POST['idTarea'];?>">
        <input type="hidden" name="idProyectoRe" id="idProyectoRe">
        <!-- START card-->
        <div class="card card-default m-1 ">
            <div class="card-body ">
                <div class="row ">
                    <div class="col-md-12 w-100 text-center ">
                        <h3>Relación de Participantes en la Actividad:</h3>
                    </div>
                </div>
                <hr class="mt-3 mb-3">
                <h5 class="mt-3 mb-3 titulo_area"><em><b>Información de Actividad:</b></em></h5>
                <div class="row m-1">
                   <div class="col-12 col-md-3 br  bb bl bt">
                        <div class="form-group">
                            <label class="text-center w-100  text-muted"><em>Proyecto:</em></label>
                            <h5 class="text-center " id="actividad_1"><b> </b></h5>
                        </div>
                    </div>
                    <div class="col-12 col-md-3 br  bb bl bt">
                        <div class="form-group">
                            <label class="text-center w-100  text-muted"><em>Actividad:</em></label>
                            <h5 class="text-center " id="actividad_2"><b> </b></h5>
                        </div>
                    </div>
                    <div class="col-12 col-md-3 br  bb bl bt">
                        <div class="form-group">
                            <label class="text-center w-100 text-muted"><em>Presupuesto:</em></label>
                            <h5 class="text-center" id="actividad_3"><b> </b></h5>
                        </div>
                    </div>
                    <div class="col-12 col-md-3 br  bb bl bt">
                        <div class="form-group">
                            <label class="text-center w-100 text-muted"><em>Fecha Estimada:</em></label>
                            <h5 class="text-center" id="actividad_4"><b> </b></h5>
                        </div>
                    </div>
                </div>

                <div class="row mt-4">
                    <div class="col-md-2">
                        <button class="btn btn-info btn-block btn-sm" id="OpcionVolver" ><i class="fas fa-chevron-circle-left fa-lg mr-2"></i> Actividades</button>
                    </div>
                    <div class="col-md-2 offset-8">
                        <button class="btn btn-success btn-block btn-sm" onclick="AgregarParticipantes();"><i class="fa fa-plus fa-lg mr-2"></i>Agregar Participantes</button>
                    </div>
                </div>
                <h5 class="mt-3 mb-3 titulo_area"><em><b>Lista de Participantes:</b></em></h5>
                <div class="row ">
                    <div class="col-md-12">
                        <div class="row">
                            <div class="col-md-12">
                                <table class="table w-100 table-hover table-sm dt-responsive nowrap" id="tablaParticipantes" style="font-size:11px">
                                    <thead class="thead-light text-center">
                                        <tr>
                                            <th data-priority="1">#</th>
                                            <th>PARTICIPANTE</th>
                                            <th>DNI</th>

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

<div class="modal fade " id="ModalDisponibles" role="dialog" aria-labelledby="myModalLabelLarge" aria-hidden="true">
    <div class="modal-dialog modal-lg  ">
        <div class="modal-content">
            <div class="row m-1 bb">
                <div class="col-md-12">
                    <h4 class="text-center text-" id="tituloModalTarea"></h4>
                </div>
            </div>
            <div class="modal-body ">
                  <div class="row">
                            <div class="col-md-12">
                                <table class="table w-100 table-hover table-sm dt-responsive nowrap" id="tablaParticipantesDisponibles" style="font-size:11px">
                                    <thead class="thead-light text-center">
                                        <tr>
                                            <th data-priority="1">#</th>
                                            <th>PARTICIPANTE</th>
                                            <th>DNI</th>
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

<script src="<?php echo $conexionConfig->rutaOP(); ?>vista/js/Participacion.js"></script>
