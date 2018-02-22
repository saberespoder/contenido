import shareThis           from "./share_this"
import platformPlaceholder from "./platform_placeholder"
import Trackable           from "./trackable"

let initializer = {}

initializer.shareThis = (el, props) => shareThis(props)
initializer.platformPlaceholder = (el, props) => new platformPlaceholder(el, props)
initializer.Trackable = (el, props) => new Trackable(el, props)

export default initializer
