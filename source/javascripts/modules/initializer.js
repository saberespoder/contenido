import shareThis           from "./share_this"
import platformPlaceholder from "./platform_placeholder"

let initializer = {}

initializer.shareThis = (el, props) => shareThis(props)
initializer.platformPlaceholder = (el, props) => new platformPlaceholder(el, props)

export default initializer
