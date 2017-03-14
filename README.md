# Setup

## Assets
Middleman maintainers have got rid of Sprockets based assets a while ago and have implemented a feature called [external_pipeline](https://middlemanapp.com/advanced/external-pipeline/) instead. In practice it allows us to use any front-end dependency manager and on this project **webpack** handles assets. To make your local development environment compatiable, please, install *yarn* first (`brew install yarn` should handle it for Mac users).

## Packages
Once yarn is installed run `./bin/setup` in the project directory – this command will pull all of the gems and npm modules required for this project.

## Environment variables
Setup creates `.env` file in the root of application directory and the most of variables already stated there, but some extra sensitive (such as AWS and Contentful credentials) were missed intentionally. Before moving forward, please, get proper values for `CONTENTFUL_` (the most important one) and `AWS_` vars and update `.env` accordingly. The best person to ask about these credentials is probably @skatkov. Or you can fetch them from CI **environment variables** section *(be careful with AWS though, CI variables refer to the live bucket)*.

## Local content
If you have Contenful ENV vars in place, you are able to say `bundle exec middleman contentful --rebuild`. This command will fetch up-to-date data from Contenful API and place categories and articles entities into project data directory. Don't warry about possible error messages from webpack – *contentful_middleman* gem is not fully compatible with Middleman v4 yet which probably causes undesirebal output. Strictly speaking, Middleman coukd work without fetched data, but you will see only the basic HTML layout without any articles.

# Development
```
bundle exec middleman server
```

# Deployment
