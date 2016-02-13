var addClickListener = function (element) {
    element = flashes[i];
    element.addEventListener("click", function (event) {
        event.currentTarget.style.display = 'none';
    }, false);
};

var addCloseAfterOneMinute = function (flash) {
    const delay_one_minute = 60000;
    setTimeout(function () {
        flash.style.display = 'none';
    }, delay_one_minute);
};

var addEventsToFlashes = function () {
    var flashes = document.querySelectorAll('.alert, .warning, .notice');

    for (i = 0; i < flashes.length; i++) {
        flash = flashes[i];
        addClickListener(flash);
        addCloseAfterOneMinute(flash);
    }

    var xButtons = document.querySelectorAll('.close');
    for(i = 0; i<xButtons.length; i++){
        addClickListener(xButtons[i]);
    }
};

onload = addEventsToFlashes;
