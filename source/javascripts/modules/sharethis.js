let shareThis = {}

let social  = document.getElementById("js-social")

if (social) {
  var script  = document.createElement("script")
  script.type = "text/javascript"
  script.src  = "//platform-api.sharethis.com/js/sharethis.js#property=58ea34c2b23bb10011d6ce9a&product=inline-share-buttons"
  social.appendChild(script)
}

export default shareThis
