var addClickListener = function (element) {
    element.addEventListener("click", function (event) {
        event.currentTarget.style.display = "none";
    }, false);
};

var addCloseAfterOneMinute = function (flash) {
    const delayOneMinute = 60000;
    setTimeout(function () {
        flash.style.display = "none";
    }, delayOneMinute);
};

var addEventsToFlashes = function () {
    var flashes = document.querySelectorAll(".alert, .warning, .notice");

    var i;
    for (i = 0; i < flashes.length; i++) {
        var flash = flashes[i];
        addClickListener(flash);
        addCloseAfterOneMinute(flash);
    }

    var xButtons = document.querySelectorAll(".close");
    for(i = 0; i<xButtons.length; i++){
        addClickListener(xButtons[i]);
    }
};

onload = addEventsToFlashes;
