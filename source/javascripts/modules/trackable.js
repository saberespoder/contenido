import queryString from "query-string"

class Trackable {
  constructor(el, param) {
    let query = queryString.parse(location.search)
    let links = el.getElementsByTagName('a')

    if (query[param]) {
      for(var i=0; i < links.length; i++) {
        // Convert link href to object
        let href_object = queryString.parseUrl(links[i].href)
        // Add get param to object
        href_object['query'][param] = query[param]
        // Regenerate link href, include received param
        links[i].href = href_object['url'] + '?' + queryString.stringify(href_object['query'])
      }
    }
  }
}

export default Trackable
