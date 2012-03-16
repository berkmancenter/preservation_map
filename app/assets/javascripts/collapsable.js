$(function() {
    $('.toggler > ol').hide();
    $('.toggler > legend > span').each(function() {
        $(this).html('<a href="#">' + $(this).text() + ' &raquo;</a>');
    });

    $('.toggler > legend').click(function() {
        var text = $(this).text();
        if (text.search(' »') > -1) {
            $(this).find('a').html(text.replace(' »', ' &laquo;'));
        }
        else {
            $(this).find('a').html(text.replace(' «', ' &raquo;'));
        }
        $(this).next('ol').slideToggle();
    });
});
