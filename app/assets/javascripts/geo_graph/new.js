$(function() {
    $('.toggler > ol').hide();
    $('.toggler > legend > span').each(function() {
        $(this).text($(this).text() + ' »');
    });

    $('.toggler > legend').click(function() {
        var text = $(this).text();
        if (text.search(' »') > -1) {
            $(this).children('span').text(text.replace(' »', ' «'));
        }
        else {
            $(this).children('span').text(text.replace(' «', ' »'));
        }
        $(this).next('ol').slideToggle();
    });
});
