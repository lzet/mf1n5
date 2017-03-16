function addzero(i) { return i < 10 ? "0" + i : i.toString(); }

function readyinit() {
  $("input[id^='calendar']").datepicker({
    todayBtn: "linked",
    language: $('html').attr('lang'),
    format: "yyyy-mm-dd",
    autoclose: true
  });
}

$(document).on('turbolinks:load', readyinit);


function change_id_text(brid, caller, curid) {
  branch = $(brid);
  valit = branch.find('.pvalue');
  txtit = branch.find('.ptext');
  valit.val(curid);
  if(txtit) {
    txtit.html(caller.text()+'<span class="caret"></span>');
  }
}

function closeButton(brid) {
  $(brid).children('.to-hide').hide();
};

function closeClass(brid) {
  branch = $(brid);
  branch.removeClass('open');
}

function escapeRegExp(str) {
  return str.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&");
}

function add_tag(caller) {
  branch = caller.parent().parent();
  taglist = branch.find('input');
  txt = taglist.val();
  adtxt = caller.text();
  if(txt.search(new RegExp('(^|[, ])'+escapeRegExp(adtxt)+'([\s,]+|$)')) < 0){
    if(txt.length!=0 && !txt.endsWith(',') && !txt.endsWith(', ')) {
      adtxt = ', ' + adtxt;
    }
    taglist.val(txt+adtxt+', ');
  }
}
