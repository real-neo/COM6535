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
    alert('Please log in to continue');
}

function showBlockedMessage() {
    alert('Sorry, Your account has been blocked!');
}

function changeStarColor(star_no) {
    if (star_no >= 5)
        $('#star-5').find('.rating-star').addClass('temp-checked-star');
    else
        $('#star-5').find('.rating-star').addClass('temp-unchecked-star');
    if (star_no >= 4)
        $('#star-4').find('.rating-star').addClass('temp-checked-star');
    else
        $('#star-4').find('.rating-star').addClass('temp-unchecked-star');
    if (star_no >= 3)
        $('#star-3').find('.rating-star').addClass('temp-checked-star');
    else
        $('#star-3').find('.rating-star').addClass('temp-unchecked-star');
    if (star_no >= 2)
        $('#star-2').find('.rating-star').addClass('temp-checked-star');
    else
        $('#star-2').find('.rating-star').addClass('temp-unchecked-star');
    if (star_no >= 1)
        $('#star-1').find('.rating-star').addClass('temp-checked-star');
    else
        $('#star-1').find('.rating-star').addClass('temp-unchecked-star');
}

function resetStarColor() {
    $('#star-5').find('.rating-star').removeClass('temp-checked-star').removeClass('temp-unchecked-star');
    $('#star-4').find('.rating-star').removeClass('temp-checked-star').removeClass('temp-unchecked-star');
    $('#star-3').find('.rating-star').removeClass('temp-checked-star').removeClass('temp-unchecked-star');
    $('#star-2').find('.rating-star').removeClass('temp-checked-star').removeClass('temp-unchecked-star');
    $('#star-1').find('.rating-star').removeClass('temp-checked-star').removeClass('temp-unchecked-star');
}