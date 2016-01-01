$ -> $(".notice, .alert").on("click", (event)->
    $(event.target).hide("slow")
)