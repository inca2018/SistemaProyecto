var cronograma;

function init() {
    Mostrar_Cronograma();
}

function Mostrar_Cronograma() {
    cronograma = $('#arbol').jstree({
        'core': {
            'data': {
                "url": "../../controlador/Gestion/CGestion.php?op=JsonArbol",
                "dataType": "json" // needed only if you do not supply JSON headers
            }
        }
    });

    cronograma.on('ready.jstree', function () {
        cronograma.jstree("open_all");
        cronograma.jstree("toggle_icons");
    });
}


init();
