$(function() {
    $('#advanced ol').hide();
    $('#advanced legend').click(function() {
        $(this).text() == 'Advanced »' ? $(this).children('span').text('Advanced «') : $(this).children('span').text('Advanced »');
        $(this).next().slideToggle();
    });
});
