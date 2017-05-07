class platformPlaceholder {

  constructor(parent, enabled) {
    this.parent   = parent
    this.messages = [
      ["Preguntas sobre educación - escuelas locales, clases de inglés, GED? ¡Envíelas a 72237 y obtenga una respuesta directamente a su teléfono!"],
      ["¿Sabía usted que puede ganar dinero haciendo horas extras con su teléfono celular? Haga clic aquí para aprender cómo!", "/ofertas/trabajo/como-ser-miembro-del-grupo-de-opinion-de-saberespoder"],
      ["¿Ha escuchado que puede ganar $1, $5, hasta $10 contestando encuestas? Haga clic aquí para aprender cómo!", "/ofertas/trabajo/como-ser-miembro-del-grupo-de-opinion-de-saberespoder"]
    ]

    if (enabled == "true") {
      this.render()
    }
  }

  render() {
    let container = document.createElement("div")
    container.className = "container"
    container.innerHTML = `<h2>${this.getMessage()}</h2>`
    this.parent.appendChild(container)
  }

  getMessage() {
    let message = this.messages[Math.floor(Math.random()*this.messages.length)]
    if (message[1]) {
      return `<a href="${message[1]}">${message[0]}</a>`
    } else {
      return message[0]
    }
  }
}

export default platformPlaceholder
