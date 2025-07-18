import consumer from "./consumer"

consumer.subscriptions.create("ConversationChannel", {
  connected() { 
	   console.log(" successfully connected to conversation channel " );
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
	  console.log("disconnected " );
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
	  console.log("received data : " ,data);
  }
});
