$(function() {
  $('input').change(function() {
    $('#black-score').text(calculateBlackScore());
    $('#white-score').text(calculateWhiteScore());
  });
});

function calculateBlackScore(){
  return parseInt($('#white-lost-stones').text()) + parseInt($('#black-territory').val());
}

function calculateWhiteScore(){
  return parseInt($('#black-lost-stones').text()) + parseInt($('#white-territory').val());
}
