module.exports = {
    open: function() {
        window.location = "/app";
    },
    openWithParams: function(payload) {
        window.location = "/app" + payload;
    },
    openUrl: function(payload) {
        window.location = "/app/url/" + payload; 
    },
    openDrawing: function(payload) {
        window.location = "/app/id/" + payload;
    }
}