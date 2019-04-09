//= require jquery
//= require jquery_ujs
//= require ajax_setup
//= require ajax_modal
//= require bootstrap
//= require flash_message
//= require visibility_map
//= require modal
//= require select2
//= require select2_init

function toggleNav() {
    $('#myNav').toggleClass('active');
}

function showLoginMessage() {
    $.flashAlert('Log in to be able to post', 'alert');
}
