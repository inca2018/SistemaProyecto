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
            <div class="card  m-1 sombra2">
               <div class="card-body ">
                        <div class="row ">
                            <div class="col-md-12 w-100 text-center ">
                                <h3>Mantenimiento de Usuario:</h3>
                            </div>
                        </div>
                        <hr class="mt-2 mb-2">
                         <div class="row"  >
                           <div class="col-md-12">
                                <div class="row">
                                   <div class="col-xl-3 col-lg-6">
                                      <!-- START card-->
                                      <div class="card bg-warning-dark border-0 sombra1">
                                         <div class="card-header">
                                            <div class="row align-items-center">
                                               <div class="col-3">
                                                  <em class="fa fa-user fa-4x"></em>

                                               </div>
                                               <div class="col-9 text-right">
                                                  <div class="text-lg" id="total_1">0</div>
                                                    <h4><p class="m-0"></p>Administrador</h4>
                                               </div>
                                            </div>
                                         </div>

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
                                                  <div class="text-lg" id="total_2">0</div>
                                                      <h4> <p class="m-0">Jefe de Proyecto</p> </h4>

                                               </div>
                                            </div>
                                         </div>

                                      </div>
                                      <!-- END card-->
                                   </div>
                                   <div class="col-xl-3 col-lg-6">
                                      <!-- START card-->
                                      <div class="card bg-purple-dark border-0 sombra1">
                                         <div class="card-header">
                                            <div class="row align-items-center">
                                               <div class="col-3">
                                                  <em class="fa fa-user fa-4x"></em>
                                               </div>
                                               <div class="col-9 text-right">
                                                  <div class="text-lg" id="total_3">0</div>
                                                            <h4> <p class="m-0">Empleados</p></h4>

                                               </div>
                                            </div>
                                         </div>

                                      </div>
                                      <!-- END card-->
                                   </div>
                                    <div class="col-xl-3 col-lg-6">
                                      <!-- START card-->
                                      <div class="card bg-info-dark border-0 sombra1">
                                         <div class="card-header">
                                            <div class="row align-items-center">
                                               <div class="col-3">
                                                  <em class="fa fa-user fa-4x"></em>
                                               </div>
                                               <div class="col-9 text-right">
                                                  <div class="text-lg" id="total_4">0</div>
                                                            <h4> <p class="m-0">Total Usuarios</p></h4>

                                               </div>
                                            </div>
                                         </div>

                                      </div>
                                      <!-- END card-->
                                   </div>
                                </div>
                           </div>

                        </div>
                        <hr>
                         <div class="row">

                            <div class="col-md-2 offset-10">
                                <button class="btn btn-success btn-block btn-sm" onclick="NuevoUsuario();"><i class="fa fa-plus fa-lg mr-2"></i> Nuevo Usuario</button>
                            </div>
                        </div>
                        <h5 class="mt-3 mb-3 titulo_area" ><em><b>Lista General de Usuario:</b></em></h5>
                        <div class="row ">
                            <div class="col-md-12">
                                <div class="row">
                                   <div class="col-md-12">
                                        <table class="table w-100 table-hover table-sm dt-responsive nowrap sombra2" id="tablaUsuario">
                                            <thead class="thead-light text-center">
                                                <tr>
                                                    <th data-priority="1">#</th>
                                                    <th>ESTADO</th>
                                                    <th>PERFIL</th>
                                                    <th>PERSONA</th>
                                                    <th>USUARIO</th>
                                                    <th>REGISTRO</th>
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

<div class="modal fade " id="ModalUsuario" role="dialog" aria-labelledby="myModalLabelLarge" aria-hidden="true">
	<div class="modal-dialog modal-lg  ">
		<div class="modal-content">
            <div class="row m-1 bb">
                <div class="col-md-12">
                    <h4 class="text-center text-" id="tituloModalUsuario"></h4>
                </div>
            </div>
			<div class="modal-body " >
				<form id="FormularioUsuario" method="POST" autocomplete="off">
                     <input type="hidden" name="idUsuario" id="idUsuario">
                     <div class="row mb-3 mt-1">
                         <div class="col-md-3">
                             <label class=""><span class="red">(*) Campos Obligatorios</span></label>
                         </div>
                         <div class="col-md-1 offset-8">
                              <button type="button" class="btn btn-info btn-sm btn-display" title="Limpiar Campos" onclick="LimpiarUsuario();">
                              <i class="fa fa-trash-alt fa-lg "></i>
                              </button>
                         </div>
                     </div>

					 <div class="row" id="cuerpo">
					      <div class="col-md-12 bl">

                                <div class="row">
                                      <div class="col-md-6 br">
                                        <div class="form-group row">
                                            <label for="UsuarioPersona" class="col-md-5 col-form-label"><i class="fa fa-male fa-lg mr-3"></i>Persona<span class="red">*</span>:</label>
                                            <div class="col-md-7">
                                                <select class="form-control validarPanel" id="UsuarioPersona" name="UsuarioPersona" data-message="- Campo Persona">

                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                      <div class="col-md-6 ">
                                           <div class="form-group row">
                                                <label for="UsuarioUsuario " class="col-md-5 col-form-label  "><i class="fa fa-user mr-2"></i>Usuario<span class="red">*</span>:</label>
                                                <div class="col-md-7">
                                                    <input type="text" class="form-control validarPanel" placeholder="Usuario" name="UsuarioUsuario" id="UsuarioUsuario" data-message="- Campo Usuario">
                                                </div>
                                            </div>
                                     </div>

                                     <div class="col-md-6 br">
                                        <div class="form-group row">
                                            <label for="UsuarioPerfil" class="col-md-5 col-form-label"><i class="fa fa-address-card mr-2"></i>Perfil<span class="red">*</span>:</label>
                                            <div class="col-md-7">
                                                <select class="form-control validarPanel" id="UsuarioPerfil" name="UsuarioPerfil" data-message="- Campo Perfil">

                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                      <div class="col-md-6">
                                           <div class="form-group row">
                                                <label for="UsuarioPassword " class="col-md-5 col-form-label"><i class="fa fa-lock mr-2"></i>Contraseña<span class="red">*</span>:</label>
                                                <div class="col-md-7">
                                                    <input type="text" class="form-control validarPanel" placeholder="Contraseña" name="UsuarioPassword" id="UsuarioPassword" data-message="- Campo Contraseña">
                                                </div>
                                            </div>
                                     </div>
                                    <div class="col-md-6 br">
                                        <div class="form-group row">
                                            <label for="UsuarioEstado" class="col-md-5 col-form-label"><i class="fa fa-sun fa-lg mr-3"></i>Estado<span class="red">*</span>:</label>
                                            <div class="col-md-7">
                                                <select class="form-control validarPanel" id="UsuarioEstado" name="UsuarioEstado" data-message="- Campo Estado">

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


<script src="<?php echo $conexionConfig->rutaOP(); ?>vista/js/MantUsuarios.js"></script>
