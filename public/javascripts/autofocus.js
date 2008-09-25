// Activates (focuses and selects) the appropriate control on a page, either a
// control having the 'autofocus' CSS class or otherwise the first control
// encountered.
Event.observe(window, 'load', function() {
  // Find and focus the first element having the 'autofocus' class.
  var control = $$('.autofocus').first();
  if (control != null) {
    Form.Element.activate(control);
    return;
  }
  
  // Failing that, find and focus the first user-input control.
  var control = $$('input[type="checkbox"], input[type="file"], '  +
                   'input[type="password"], input[type="radio"], ' +
                   'input[type="search"],   input[type="text"], '  +
                   'select,                 textarea').first();
  if (control != null) {
    Form.Element.activate(control);
    return;
  }
  
  // Failing that, find and focus any kind of control.
  var control = $$('input').first();
  if (control != null) {
    Form.Element.activate(control);
    return;
  }
});
