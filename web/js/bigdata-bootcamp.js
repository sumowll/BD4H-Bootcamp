/*!
 * Clean Blog v1.0.0 (http://startbootstrap.com)
 * Copyright 2015 Start Bootstrap
 * Licensed under Apache 2.0 (https://github.com/IronSummitMedia/startbootstrap/blob/gh-pages/LICENSE)
 */

// Tooltip Init
$(function() {
    $("[data-toggle='tooltip']").tooltip();
});

// Contact Form Scripts

$(function() {
    $("a[data-toggle=\"tab\"]").click(function(e) {
        e.preventDefault();
        $(this).tab("show");
    });
});

// make all images responsive
$(function() {
	$("img").addClass("img-responsive");
});

// responsive tables
$(document).ready(function() {
	$("table").wrap("<div class='table-responsive'></div>");
	$("table").addClass("table");
});

// responsive embed videos
$(document).ready(function () { 
    $('iframe[src*="youtube.com"]').wrap('<div class="embed-responsive embed-responsive-16by9"></div>');
	$('iframe[src*="youtube.com"]').addClass('embed-responsive-item');
    $('iframe[src*="vimeo.com"]').wrap('<div class="embed-responsive embed-responsive-16by9"></div>');
	$('iframe[src*="vimeo.com"]').addClass('embed-responsive-item');
});

// Table of Content
$(function() {
    $("#toc").tocify({
        // 0-th is the header
        context: ".container:eq( 1 )",
        extendPage: false
    });
})

// Navigation Scripts to Show Header on Scroll-Up
jQuery(document).ready(function($) {
    var MQL = 1170;

    //primary navigation slide-in effect
    if ($(window).width() > MQL) {
        var headerHeight = $('.navbar-custom').height();
        $(window).on('scroll', {
            previousTop: 0
        },
        function() {
            var currentTop = $(window).scrollTop();
            //check if user is scrolling up
            if (currentTop < this.previousTop) {
                //if scrolling up...
                if (currentTop > 0 && $('.navbar-custom').hasClass('is-fixed')) {
                    $('.navbar-custom').addClass('is-visible');
                } else {
                    $('.navbar-custom').removeClass('is-visible is-fixed');
                }
            } else {
                //if scrolling down...
                $('.navbar-custom').removeClass('is-visible');
                if (currentTop > headerHeight && !$('.navbar-custom').hasClass('is-fixed')) $('.navbar-custom').addClass('is-fixed');
            }
            this.previousTop = currentTop;
        });
    }
});

// use ACE editor
$(function() {
    $(".codetabs pre code").each(function() {
        $(this).text($(this).text().trim());
    });

    $(".highlight pre code").parent().each(function() {
        var lang = $(this).find('code').data("lang");
        var editor = ace.edit(this);

        editor.setTheme("ace/theme/github");
        editor.setReadOnly(true);
        editor.setOptions({
            maxLines: 100
        });
        editor.getSession().setUseWrapMode(true);
        if (lang === 'python') {
            editor.getSession().setMode('ace/mode/python');
        } else if (lang === 'bash') {
            editor.getSession().setMode('ace/mode/sh');
        } else if (lang === 'scala') {
            editor.getSession().setMode('ace/mode/scala');
        } else if (lang === 'java') {
            editor.getSession().setMode('ace/mode/java');
        }
    });
})


// hack way of removing unknow empty p
$(function () {
    $("p").each(function () {
        $this = $(this)
        if ($this.text().length == 0) {
            $this.remove()
        }
    })
})

