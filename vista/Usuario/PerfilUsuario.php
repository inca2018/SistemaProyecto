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
            <div>Perfil Usuario</div>
        </div>
        <!-- START card-->
        <div class="card card-default">
            <div class="card-body">
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

            </div>
        </div>
    </div>
</section>
<!-- Fin Modal Agregar-->
<!-- Fin del Cuerpo del Sistema del Menu-->
<!-- Inicio del footer -->
<?php require_once('../layaout/Footer.php');?>
<!-- Fin del Footer -->

<script src="<?php echo $conexionConfig->rutaOP(); ?>vista/js/PerfilUsuario.js"></script>
