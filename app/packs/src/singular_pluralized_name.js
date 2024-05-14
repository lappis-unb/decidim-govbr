document.addEventListener("DOMContentLoaded", function() {
    var singular = document.getElementById("singular_name");
    var pluralized = document.getElementById("pluralized_name");
    var menu = document.getElementById("menu_name");

    if (singular.value=="Página Inicial"){
        pluralized.value = "Páginas Iniciais";
        menu.value = "Páginas Iniciais";
    } else if(singular.value.endsWith("ões")){
        singular.value = singular.value.slice(0,-3)+"ão";
    } else if(singular.value.endsWith("s")){
        singular.value = singular.value.slice(0,-1);
    } else {
        pluralized.value = pluralized.value + "s";
        menu.value = pluralized.value;
    }

});