$(function(){
  $('form').submit(function() {
    var message = $(this).find('#message').val();

    $.post('/channel/echo', {message: message});
    return false;
  });

  var render_message = function(client_id, message) {
    $('#messages').append('<li>' + message + '</li>');
  };

  var onopen = function() {
    console.log('channel opened');
  };

  var onmessage = function(data) {
    console.log('channel data:');
    console.log(data);

    var data = $.parseJSON(data.data);

    render_message(data.client_id, data.message);
  };

  var onerror = function(error) {
    console.log('channel error: code=' + error.code + ' desc=' + error.description);
  };

  var onclose = function() {
    console.log('channel closeed');
  };

  var connect = function(data) {
    var channel = new goog.appengine.Channel(data.token);
    var socket = channel.open({
      onopen: onopen,
      onmessage: onmessage,
      onerror: onerror,
      onclose: onclose
    });
  };

  $.getJSON('/channel', {client_id: client_id}, connect);
});
