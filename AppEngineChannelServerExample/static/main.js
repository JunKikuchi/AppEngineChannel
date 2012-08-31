$(function(){
  $('form').submit(function() {
    message = $(this).find('#message').val();

    $.post('/channel/echo', {message: message});
    return false;
  });

  var render_message = function(client_id, message) {
    $('#messages').append('<dt>' + client_id + '</dt>');
    $('#messages').append('<dd>' + message + '</dd>');
  };

  var connect = function(data) {
    channel = new goog.appengine.Channel(data.token);
    socket = channel.open();

    socket.onopen = function() {
      console.log('channel opened');
    };

    socket.onmessage = function(data) {
      console.log('channel data:');
      console.log(data);

      var data = $.parseJSON(data.data);

      render_message(data.client_id, data.message);
    };

    socket.onerror = function(error) {
      console.log('channel error: code=' + error.code + ' desc=' + error.description);
    };

    socket.onclose = function() {
      console.log('channel closeed');
    };
  };

  $.getJSON('/channel', {client_id: client_id}, connect);
});
