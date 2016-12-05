var GetURL = function() {};

GetURL.prototype = {
    run: function(args) {
        args.completionFunction({"URL": document.URL});
    }
}

var ExtensionPreprocessingJS = new GetURL;
