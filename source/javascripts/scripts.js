import domready    from "domready"
import viewloader  from "viewloader"
import initializer from "./modules/initializer"

domready(() => {
  document.documentElement.classList.add("js")
  viewloader.execute(initializer)
})
