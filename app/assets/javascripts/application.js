// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require jquery-ui/widgets/sortable
//= require jquery_ujs
//= require twitter/bootstrap
//= require activestorage
//= require turbolinks
//= require bootstrap-datepicker
//= require_tree ./channels
//= require_tree .
function get_loading_container() {
    loadingContainer = $('.loader-big', this.el);
}

function hide_loading() {
    get_loading_container();
    loadingContainer.hide();
}

setInterval(function () {
    $('.alert').fadeOut();
}, 3000);

$(document).on("turbolinks:click", function () {
    show_loading();
    $(".loader").show();
});

$(document).on("turbolinks:load", function () {
    $.fn.datepicker.defaults['format'] = "dd/mm/yyyy";
    loadingContainer.hide();
});

SHOW_LOADING = true;
var loadingContainer;

$(function () {
    // Toggle loading container when ajax call
    get_loading_container();
    loadingContainer.ajaxStart(function (e) {
        show_loading();
    });

    loadingContainer.ajaxStop(function (e) {
        loadingContainer.hide();
        $('#loaderMessage').html("");
    });

    $('form').on('submit', function () {
        get_loading_container();
        show_loading();
    });
});

$("a[data-remote!='true'][data-fancybox-type!='iframe']").on('click', function (e) {
    metaClick = e.metaKey || e.ctrlKey;
    if (!metaClick && should_show_overlay($(this))) {
        get_loading_container();
        show_loading();
    }
});

$("a[data-remote='true']").on('click', function (e) {
        get_loading_container();
        show_loading();
});

$(document).ready(function () {
    get_loading_container();
    loadingContainer.hide();
    $('#loaderMessage').html("");
});


function should_show_overlay(el) {
    return !el.attr("not-trigger-loading") &&
        el.attr("href") &&
        el.attr("href").slice(0, 1) != "#" &&
        el.attr("href") != "javascript:;" &&
        el.attr("href").slice(0, 1) != "" &&
        el.attr("target") != "_blank" && !el.attr("data-confirm") &&
        el.attr("data-method") != "delete"
}

function show_loading() {
    if (!!SHOW_LOADING) {
        if (typeof(reloadResourceInterval) != 'undefined')
            clearInterval(reloadResourceInterval);
        loadingContainer.css({
            'opacity': '0',
            'transition': 'transform 0.2s, opacity 0.2s',
            'transform': 'scale(1.4)',
            'display': 'block'
        });
        setTimeout(function () {
            loadingContainer.css({
                'opacity': '1',
                'transform': 'scale(1)'
            });
        }, 50);
    }
}
$(document).ready(function () {
    $("[data-message]").on("click", function () {
        message = $(this).attr('data-message');
        $('#loaderMessage').html(message);
    });
});
//
//    window.ClientSideValidations.callbacks.form.pass = function (form, callback) {
//        console.log('form-passs');
//        get_loading_container();
//        show_loading();
//    }
function redirect_to_target_and_show_loader(target) {
    window.location.href = target;
    setTimeout(function () {
        show_loading();
    }, 1);
}


$('table.sortable').ready(function () {
    $('table.sortable tbody').sortable(
        {
            handle: '.handle',
            update: function (event, ui) {
                // $('.loader-big').show();
                positions = {};
                $.each($('table.sortable tbody tr'), function (position, obj) {
                    reg = /(\w+_?)+_(\d+)/;
                    parts = reg.exec($(obj).attr('id'));
                    if (parts) {
                        positions['positions[' + parts[2] + ']'] = position;
                    }
                });
                $.ajax({
                    type: 'POST',
                    dataType: 'script',
                    url: $(ui.item).closest("table.sortable").data("sortable-link"),
                    data: positions,
                    success: function (data) {
                        $('.loader-big').hide();
                    }
                });
            }
        });
});
$(function(){
    $.fn.datepicker.defaults['format'] = "dd/mm/yyyy";

});