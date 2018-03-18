function getAll(Client, toElm, payload) {
    Client.getDrawings({
        onSuccess: function(result) {
            toElm("drawings loaded", result.data)
        },
        onFailure: function(err) {
            console.log("Error!", err);
        }
    });
}

function delete_(Client, toElm, payload) {
    Client.deleteDrawing(payload, {
        onSuccess: function(result) {
            toElm("delete succeeded", payload);
        }, 
        onFailure: function(error) {
            toElm("delete failed", {
                id: payload,
                error: String(error)
            });
        }
    }); 
}

module.exports = function(Client, toElm) {
    return {
        getAll: function(payload) {
            getAll(Client, toElm, payload);   
        },
        delete: function(payload) {
            delete_(Client, toElm, payload);
        }
    };
};