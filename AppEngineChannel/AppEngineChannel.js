var iframe = null;
var queue  = [];

var create_iframe = function() {
    iframe = document.createElement('iframe');
    iframe.style.display = 'none';
    iframe.src = 'appenginechannel://ready';
    document.body.appendChild(iframe);
};

var remove_iframe = function () {
    document.body.removeChild(iframe);
};

var fetch = function() {
    remove_iframe();
    var json = JSON.stringify(queue);
    queue.length = 0;
    return json;
};

var dispatch = function(command, params) {
    queue.push([command, params]);
    create_iframe();
};

var channel = new goog.appengine.Channel('%@');
var socket = channel.open({
    onmessage: function(data ) { dispatch('onmessage', data ); },
    onerror:   function(error) { dispatch('onerror',   error); },
    onopen:    function()      { dispatch('onopen'          ); },
    onclose:   function()      { dispatch('onclose'         ); },
});