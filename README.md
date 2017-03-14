# Setup

## Assets
Middleman maintainers have got rid of Sprockets based assets a while ago and have implemented a feature called [external_pipeline](https://middlemanapp.com/advanced/external-pipeline/) instead. In practice it allows us to use any dependency manager and on this project `webpack` handles assets. `external_pipeline` is a pretty modest tool so all that you need to say is `npm i` before the first run in development.

## Development server
```
bundle exec middleman server
```
