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
             <input type="hidden" id="PerfilCodigo" value="<?php echo $_SESSION['perfil'];?>">
             <input type="hidden" id="idUsuario" value="<?php echo $_SESSION['idUsuario'];?>">

            <div class="card sombra2 ">
               <div class="card-body" id="panel_administrador" style="display:none">
                        <div class="row ">
                            <div class="col-md-12 w-100 text-center ">
                                <h3>Panel de Control:</h3>
                            </div>
                        </div>
                        <hr class="mt-2 mb-2">
                        <div class="row"  >
                           <div class="col-md-12">
                                <div class="row">
                                   <div class="col-xl-3 col-lg-6">
                                      <!-- START card-->
                                      <div class="card bg-info-dark border-0 sombra1">
                                         <div class="card-header">
                                            <div class="row align-items-center">
                                               <div class="col-3">
                                                  <em class="fa fa-book fa-4x"></em>
                                               </div>
                                               <div class="col-9 text-right">
                                                  <div class="text-lg" id="total_proyectos">0</div>
                                                  <h4><p class="m-0">Proyectos</p> </h4>
                                               </div>
                                            </div>
                                         </div>
                                         <a class="card-footer p-2 bg-info  bt0 clearfix btn-block d-flex" href="#" onclick="MostrarProyectos();">
                                            <span>Gestión</span>
                                            <span class="ml-auto">
                                               <em class="fa fa-chevron-circle-right"></em>
                                            </span>
                                         </a>

                                         <!-- END card-->
                                      </div>
                                   </div>
                                   <div class="col-xl-3 col-lg-6">
                                      <!-- START card-->
                                      <div class="card bg-warning-dark border-0 sombra1">
                                         <div class="card-header">
                                            <div class="row align-items-center">
                                               <div class="col-3">
                                                  <em class="fas fa-bookmark fa-4x"></em>

                                               </div>
                                               <div class="col-9 text-right">
                                                  <div class="text-lg" id="total_tareas">0</div>
                                                    <h4><p class="m-0"></p>Tareas</h4>
                                               </div>
                                            </div>
                                         </div>
                                         <a class="card-footer p-2 bg-warning bt0 clearfix btn-block d-flex" href="#" onclick=" ">
                                            <span> </span>
                                            <span class="ml-auto">
                                               <em class="fa fa-chevron-circle-right"></em>
                                            </span>
                                         </a>

                                      </div>
                                      <!-- END card-->
                                   </div>
                                   <div class="col-xl-3 col-lg-6">
                                      <!-- START card-->
                                      <div class="card bg-green-dark border-0 sombra1" >
                                         <div class="card-header">
                                            <div class="row align-items-center">
                                               <div class="col-3">
                                                 <em class="fa fa-user fa-4x"></em>
                                               </div>
                                               <div class="col-9 text-right">
                                                  <div class="text-lg" id="total_empleados">0</div>
                                                      <h4> <p class="m-0">Empleados</p> </h4>

                                               </div>
                                            </div>
                                         </div>

                                         <a class="card-footer p-2 bg-green  bt0 clearfix btn-block d-flex"  href="#" onclick=" ">
                                            <span></span>
                                            <span class="ml-auto">
                                               <em class="fa fa-chevron-circle-right"></em>
                                            </span>
                                         </a>

                                      </div>
                                      <!-- END card-->
                                   </div>
                                   <div class="col-xl-3 col-lg-6">
                                      <!-- START card-->
                                      <div class="card bg-purple-dark border-0 sombra1">
                                         <div class="card-header">
                                            <div class="row align-items-center">
                                               <div class="col-3">
                                                  <em class="fas fa-male fa-4x"></em>
                                               </div>
                                               <div class="col-9 text-right">
                                                  <div class="text-lg" id="total_usuarios">0</div>
                                                            <h4> <p class="m-0">Usuarios</p></h4>

                                               </div>
                                            </div>
                                         </div>
                                         <a class="card-footer p-2 bg-purple-light  bt0 clearfix btn-block d-flex"  href="#" onclick="MostrarInformacionAsignado();">
                                            <span>Detalles</span>
                                            <span class="ml-auto">
                                               <em class="fa fa-chevron-circle-right"></em>
                                            </span>
                                         </a>

                                      </div>
                                      <!-- END card-->
                                   </div>
                                </div>
                           </div>

                        </div>
                        <h5 class="mt-3 mb-3 titulo_area" ><em><b>Información General:</b></em></h5>
                        <div class="row "  >
                            <div class="col-md-12">
                                <div class="row">
                                   <div class="col-md-12">
                                        <table class="table w-100 table-hover table-sm dt-responsive nowrap" id="tablaOperaciones" style="font-size:13px">
                                            <thead class="thead-light text-center">

                                                <tr>
                                                    <th data-priority="1">#</th>
                                                    <th>PROYECTOS</th>
                                                    <th>N° DE TAREAS</th>
                                                    <th>HORAS PROGRAMADAS</th>
                                                    <th>HORAS TRABAJADAS</th>
                                                    <th>COSTO PRESUPUESTADO</th>
                                                    <th>COSTO REALIZADO</th>
                                                    <th>% AVANCE</th>

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
               <div class="card-body" id="panel_empleado" style="display:none">
                        <div class="row ">
                            <div class="col-md-12 w-100 text-center ">
                                <h3>Gestión de Proyectos:</h3>
                            </div>
                        </div>
                        <hr class="mt-2 mb-2">
                        <h5 class="mt-3 mb-3 titulo_area" ><em><b>Información de Proyectos:</b></em></h5>
                        <div class="row "  >
                            <div class="col-md-12">
                                <div class="row">
                                   <div class="col-md-12">
                                        <table class="table w-100 table-hover table-sm dt-responsive nowrap" id="tablaOperaciones2" style="font-size:13px">
                                            <thead class="thead-light text-center">

                                                <tr>
                                                    <th data-priority="1">#</th>
                                                    <th>PROYECTOS</th>
                                                    <th>ESTADO</th>
                                                    <th>ACTIVIDADES</th>
                                                    <th>TAREAS</th>
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


<script src="<?php echo $conexionConfig->rutaOP(); ?>vista/js/Operaciones.js"></script>
