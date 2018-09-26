$(function() {
    $('.select-all').click(function() {
        var id = $(".select-all").closest("div").prop("id");
        $('#' + id + ' option').prop('selected', true);
    });
});
