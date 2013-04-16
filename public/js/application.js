$(function(){
  ws = new WebSocket("ws://localhost:8080");
  
  ws.onmessage = function(evt) {
    console.log(evt.data);
    $('#chatarea').append("<li>"+evt.data+"</li>")
  };
  
  ws.onclose = function() { 
    ws.send("Leaves the chat");
  };
  
  ws.onopen = function() {
    ws.send("Join the chat");
  };
  
  
  $("form#chat").submit(function(e) {
    var message = $("#msg").val();
    if(message.length > 0){
      ws.send(message);
      $("#msg").val("");
    }
    return false;
  });
  
  $("#clear").click( function() {
    $('#chat tbody tr').remove();
  });
  
});