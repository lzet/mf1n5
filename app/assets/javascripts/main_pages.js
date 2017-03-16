function nextInt() {
  return Math.floor(Math.random()*255) % 255;
}
function randcolor() {
  var r = nextInt().toString(16);
  var g = nextInt().toString(16);
  var b = nextInt().toString(16);
  clr = '#'+r+g+b
  $("#view_color").css('background-color', clr);
  $("#tag_color").val(clr);
}
$(document).on('click', '#waiting', function(){
  $('#loading').show();
});

function getiteminfo(elem, itemurl, id) {
  after = elem.next('.modalhtml');
  if(after.html() === '') {
    $.ajax({
      url: itemurl,
      method: 'GET',
      headers: {'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')}, //X-CSRF-TOKEN is used for Ruby on Rails Tokens
      data: {nofull: 'true'},
      dataType: 'html'
    }).done(function(data) {after.html(data); $('#item_modal_'+id).modal('show');});
  } else {
    $('#item_modal_'+id).modal('show');
  }
}

function getgraph(gurl) {
  $.ajax({
    url: gurl,
    method: 'GET',
    headers: {'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')}, //X-CSRF-TOKEN is used for Ruby on Rails Tokens
    data: {nofull: 'true'},
    dataType: 'html'
  }).done(function(data) {$('#graphdiv').html(data); $('#graph').modal('show');});
}

function showmobilemenu() {
  $('#sidearea').toggle();
}
