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

function toggleSortButtonTime() {
    const sortTime = $('#sort_time');
    sortTime.toggleClass('down');
    if (sortTime.hasClass('down')) {
        sortTime.html('Time ⬇️');
    } else {
        sortTime.html('Time ⬆️');
    }
}

function toggleSortButtonComments() {
    const sortComments = $('#sort_comments');
    sortComments.toggleClass('down');
    if (sortComments.hasClass('down')) {
        sortComments.html('Comments ⬇️');
    } else {
        sortComments.html('Comments ⬆️');
    }
}

function toggleSortButtonLikes() {
    const sortLikes = $('#sort_likes');
    sortLikes.toggleClass('down');
    if (sortLikes.hasClass('down')) {
        sortLikes.html('Likes ⬇️');
    } else {
        sortLikes.html('Likes ⬆️');
    }
}
