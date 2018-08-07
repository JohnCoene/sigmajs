$('#formats a').click(function (e) {
  e.preventDefault()
  $(this).tab('show')
})

$('#shiny a').click(function (e) {
  e.preventDefault()
  $(this).tab('show')
})

$('#dynamism a').click(function (e) {
  e.preventDefault()
  $(this).tab('show')
})

var alerted = localStorage.getItem('alerted') || '';
if (alerted != 'yes') {
 alert("My alert.");
 localStorage.setItem('alerted','yes');
}