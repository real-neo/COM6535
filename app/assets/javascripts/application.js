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
    $.flashAlert('Please log in to continue', 'alert');
}

function showBlockedMessage() {
    $.flashAlert('Your account has been blocked due to inappropriate behaviour', 'alert');
}