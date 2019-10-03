var model = {};

module.exports = function(canvasContainerId, toElm) {
    function fail (failure) {
        toElm("canvas manager error", failure);
    }

    return {
        init: function (payload) {
            var canvasContainer = document.getElementById(canvasContainerId);

            if (canvasContainer !== null) {
                fail("canvas container does not exist at initialization");
                return;
            }
            console.log("Payload in init", payload);


        }
    };
};