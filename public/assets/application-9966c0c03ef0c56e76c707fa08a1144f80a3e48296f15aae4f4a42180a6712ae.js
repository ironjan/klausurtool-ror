var addClickListener=function(e){e=flashes[i],e.addEventListener("click",function(e){e.currentTarget.style.display="none"},!1)},addCloseAfterOneMinute=function(e){const n=6e4;setTimeout(function(){e.style.display="none"},n)},addEventsToFlashes=function(){var e=document.querySelectorAll(".alert, .warning, .notice");for(i=0;i<e.length;i++)flash=e[i],addClickListener(flash),addCloseAfterOneMinute(flash);var n=document.querySelectorAll(".close");for(i=0;i<n.length;i++)addClickListener(n[i])};onload=addEventsToFlashes;