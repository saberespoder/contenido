let shareThis = (path) => {
  let script  = document.createElement("script")

  script.type = "text/javascript"
  script.src  = path
  document.body.appendChild(script)
}

export default shareThis
