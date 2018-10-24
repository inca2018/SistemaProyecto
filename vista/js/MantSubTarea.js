var tablaSubTarea;

function init() {
    var idActividad = $("#idActividad").val();
    Iniciar_Componentes();
    Listar_SubTarea(idActividad);
    Listar_Estado();

}

function Iniciar_Componentes() {


    $("#FormularioSubTarea").on("submit", function (e) {
        RegistroSubTarea(e);
    });

    $('#date_inicio').datepicker({
        format: 'dd/mm/yyyy',
    });
    $('#date_fin').datepicker({
        format: 'dd/mm/yyyy',
    });

    $('#date_inicio').datepicker().on('changeDate', function (ev) {
                var f_inicio = $("#inicio").val();
                var f_fin = $("#fin").val();
                var day = parseInt(f_inicio.substr(0, 2));
                var month = parseInt(f_inicio.substr(3, 2));
                var year = parseInt(f_inicio.substr(6, 8));

                $('#date_fin').datepicker('setStartDate', new Date(year, (month - 1), day));
      });

     $('#date_fin').datepicker().on('changeDate', function (ev) {
                var f_inicio = $("#inicio").val();
                var f_fin = $("#fin").val();
                var day = parseInt(f_fin.substr(0, 2));
                var month = parseInt(f_fin.substr(3, 2));
                var year = parseInt(f_fin.substr(6, 8));
                $('#date_inicio').datepicker('setEndDate', new Date(year, (month - 1), day));
            });

}

function RecuperarFecha(idActividad) {

    $.post("../../controlador/Mantenimiento/CSubTarea.php?op=RecuperarFecha", {
        "idActividad": idActividad
    }, function (data, status) {
        data = JSON.parse(data);
        console.log(data);
        var fecha=data.fecha;

        if(fecha=="NO ENCONTRO"){


           }else{

                var day = parseInt(fecha.substr(0, 2));
                var month = parseInt(fecha.substr(3, 2));
                var year = parseInt(fecha.substr(6, 8));
                $('#date_inicio').datepicker('setStartDate', new Date(year, (month - 1), day));

           }


    });
}

function RegistroSubTarea(event) {
    //cargar(true);
    event.preventDefault(); //No se activará la acción predeterminada del evento
    var error = "";

    $(".validarPanel").each(function () {
        if ($(this).val() == " " || $(this).val() == 0) {
            error = error + $(this).data("message") + "<br>";
        }
    });

    if (error == "") {
        $("#ModalSubTarea #cuerpo").addClass("whirl");
        $("#ModalSubTarea #cuerpo").addClass("ringed");
        setTimeout('AjaxRegistroSubTarea()', 2000);
    } else {
        notificar_warning("Complete :<br>" + error);
    }
}

function AjaxRegistroSubTarea() {
    var formData = new FormData($("#FormularioSubTarea")[0]);
    console.log(formData);
    var idProyecto=$("#idProyecto").val();
    var idActividad=$("#idActividad").val();
    formData.append("idProyecto",idProyecto);
    formData.append("idActividad",idActividad);
    $.ajax({
        url: "../../controlador/Mantenimiento/CSubTarea.php?op=AccionSubTarea",
        type: "POST",
        data: formData,
        contentType: false,
        processData: false,
        success: function (data, status) {
            data = JSON.parse(data);
            console.log(data);
            var Mensaje = data.Mensaje;
            var Error = data.Registro;
            if (!Error) {
                $("#ModalSubTarea #cuerpo").removeClass("whirl");
                $("#ModalSubTarea #cuerpo").removeClass("ringed");
                $("#ModalSubTarea").modal("hide");
                swal("Error:", Mensaje);
                LimpiarSubTarea();
                tablaSubTarea.ajax.reload();
            } else {
                $("#ModalSubTarea #cuerpo").removeClass("whirl");
                $("#ModalSubTarea #cuerpo").removeClass("ringed");
                $("#ModalSubTarea").modal("hide");
                swal("Acción:", Mensaje);
                LimpiarSubTarea();
                tablaSubTarea.ajax.reload();
            }
        }
    });
}

function Listar_Estado() {
    $.post("../../controlador/Mantenimiento/CSubTarea.php?op=listar_estados", function (ts) {
        $("#SubTareaEstado").append(ts);
    });
}

function Listar_Personas() {
    $.post("../../controlador/Mantenimiento/CSubTarea.php?op=listar_personas", function (ts) {
        $("#SubTareaPersona").append(ts);
    });
}

function Listar_SubTarea(idTarea) {

    tablaSubTarea = $('#tablaSubTarea').dataTable({
        "aProcessing": true,
        "aServerSide": true,
        "processing": true,
        "paging": true, // Paginacion en tabla
        "ordering": true, // Ordenamiento en columna de tabla
        "info": true, // Informacion de cabecera tabla
        "responsive": true, // Accion de responsive
        dom: 'lBfrtip',
        "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
        "order": [[0, "asc"]],
        "bDestroy": true,
        "columnDefs": [
            {
                "className": "text-center",
                "targets": [1, 2]
            }
            , {
                "className": "text-left",
                "targets": [0]
            }
         , ],
        buttons: [
            {
                extend: 'copy',
                className: 'btn-info'
            }
            , {
                extend: 'csv',
                className: 'btn-info'
            }
            , {
                extend: 'excel',
                className: 'btn-info',
                title: 'Facturacion'
            }
            , {
                extend: 'pdf',
                className: 'btn-info',
                title: $('title').text()
            }
            , {
                extend: 'print',
                className: 'btn-info'
            }
            ],
        "ajax": { //Solicitud Ajax Servidor
            url: '../../controlador/Mantenimiento/CSubTarea.php?op=Listar_SubTarea',
            type: "POST",
            dataType: "JSON",
            data: {
                idTareaE: idTarea
            },
            error: function (e) {
                console.log(e.responseText);
            }
        },
        // cambiar el lenguaje de datatable
        oLanguage: español,
    }).DataTable();
    //Aplicar ordenamiento y autonumeracion , index
    tablaSubTarea.on('order.dt search.dt', function () {
        tablaSubTarea.column(0, {
            search: 'applied',
            order: 'applied'
        }).nodes().each(function (cell, i) {
            cell.innerHTML = i + 1;
        });
    }).draw();
}

function NuevoSubTarea() {
    $("#ModalSubTarea").modal({
        backdrop: 'static',
        keyboard: false
    });
    $("#ModalSubTarea").modal("show");
    $("#tituloModalSubTarea").empty();
    $("#tituloModalSubTarea").append("Nuevo Tarea:");
     var idActividad = $("#idActividad").val();
     RecuperarFecha(idActividad);
}

function EditarSubTarea(idSubTarea) {
    $("#ModalSubTarea").modal({
        backdrop: 'static',
        keyboard: false
    });
    $("#ModalSubTarea").modal("show");
    $("#tituloModalSubTarea").empty();
    $("#tituloModalSubTarea").append("Editar Tarea:");
    RecuperarSubTarea(idSubTarea);
}

function RecuperarSubTarea(idSubTarea) {
    //solicitud de recuperar Proveedor
    $.post("../../controlador/Mantenimiento/CSubTarea.php?op=RecuperarInformacion_SubTarea", {
        "idSubTarea": idSubTarea
    }, function (data, status) {
        data = JSON.parse(data);
        console.log(data);

        $("#idSubTarea").val(data.idTarea);
        $("#TareaNombre").val(data.NombreTarea);

        $("#SubTareaDescripcion").val(data.Descripcion);

        $("#SubTareaEstado").val(data.Estado_idEstado);
        $("#inicio").val(data.fechaInicio);
        $("#fin").val(data.fechaFin);

    });
}

function EliminarSubTarea(idSubTarea) {
    swal({
        title: "Eliminar?",
        text: "Esta Seguro que desea Eliminar SubTarea!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: "#DD6B55",
        confirmButtonText: "Si, Eliminar!",
        closeOnConfirm: false
    }, function () {
        ajaxEliminarSubTarea(idSubTarea);
    });
}

function ajaxEliminarSubTarea(idSubTarea) {
    $.post("../../controlador/Mantenimiento/CSubTarea.php?op=Eliminar_SubTarea", {
        idSubTarea: idSubTarea
    }, function (data, e) {
        data = JSON.parse(data);
        var Error = data.Error;
        var Mensaje = data.Mensaje;
        if (Error) {
            swal("Error", Mensaje, "error");
        } else {
            swal("Eliminado!", Mensaje, "success");
            tablaSubTarea.ajax.reload();
        }
    });
}

function HabilitarSubTarea(idSubTarea) {
    swal({
        title: "Habilitar?",
        text: "Esta Seguro que desea Habilitar SubTarea!",
        type: "info",
        showCancelButton: true,
        confirmButtonColor: "#DD6B55",
        confirmButtonText: "Si, Habilitar!",
        closeOnConfirm: false
    }, function () {
        ajaxHabilitarSubTarea(idSubTarea);
    });
}

function ajaxHabilitarSubTarea(idSubTarea) {
    $.post("../../controlador/Mantenimiento/CSubTarea.php?op=Recuperar_SubTarea", {
        idSubTarea: idSubTarea
    }, function (data, e) {
        data = JSON.parse(data);
        var Error = data.Error;
        var Mensaje = data.Mensaje;
        if (Error) {
            swal("Error", Mensaje, "error");
        } else {
            swal("Eliminado!", Mensaje, "success");
            tablaSubTarea.ajax.reload();
        }
    });
}

function LimpiarSubTarea() {
    $('#FormularioSubTarea')[0].reset();
    $("#idSubTarea").val("");
    $('#date_inicio').datepicker( "option" , {
        minDate: null,
        maxDate: null} );
    $('#date_fin').datepicker( "option" , {
        minDate: null,
        maxDate: null} );
 }
function Cancelar() {
    LimpiarSubTarea();
    $("#ModalSubTarea").modal("hide");
}

function SubSubTareas(idSubTarea) {
    $.redirect('MantSubSubTarea.php', {
        'idSubTarea': idSubTarea
    });
}

function Volver() {
    var idProyecto = $("#idProyecto").val();
    $.redirect('MantTarea.php', {
        'idProyecto': idProyecto
    });
}
init();
