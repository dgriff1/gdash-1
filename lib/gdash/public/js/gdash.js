(function() {
    var toggle = function() {
        var fullscreen = window.location.hash === '#fullscreen';

        $('body').toggleClass('fullscreen', fullscreen);

        $('.fullscreen-toggle').attr('href', fullscreen ? '#' : '#fullscreen');

        $('.fullscreen-expanded').toggleClass('span12', fullscreen);
        $('.fullscreen-expanded').toggleClass('span10', !fullscreen);

        if (fullscreen) {
            $(document.body).keyup(function(event) {
                if(event.keyCode == 27) {
                    window.location = window.location.origin + window.location.pathname;
                }
            });
        }
    };

    $(document).ready(function(){
        toggle();
        $(window).on('hashchange', toggle);

        setTimeout(function() {
            window.location.reload();
        }, GDash.refreshInterval * 1000);

        $('.snapshot').click(function() {
            return confirm('Snapshotting GDash will take a long time and a potentially large amount of disk space. Are you sure you want to continue?');
        });

        $(".click-enlarge").click(function(e) {
            if(e.metaKey || e.ctrlKey) {
                return true;
            } else {
                var element = $(e.target);

                $("#xxlarge-lightbox img").attr("src", element.attr("xxlarge"));
                $("#xxlarge-lightbox").lightbox();
                
                return false;
            }
        });
    });
})();
