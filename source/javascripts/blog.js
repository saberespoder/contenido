(function() {
  var readyState = document.readyState;
  if (readyState === "interactive" || readyState === "complete") {
    var script  = document.createElement("script")
    script.type = "text/javascript"
    script.src  = "//platform-api.sharethis.com/js/sharethis.js#property=58ea34c2b23bb10011d6ce9a&product=inline-share-buttons"
    document.body.appendChild(script);
  }
  else setTimeout(arguments.callee, 100);
})();
