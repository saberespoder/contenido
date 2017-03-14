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
To run project locally say `bundle exec middleman server`. From now on, local instance of content platform is available on [http://localhost:4567/](http://localhost:4567/). We use *middleman-livereload* which means that if you update any of local files page will be reloaded automatically (except for Contentful data - you'll have to rerun rebuild command from the section above, stop Middleman and run it again).

# Deployment
Basically, you don't have to perform any extra movements to get your changes deployed to production – CI server handles everything for you and once you push to `master`, CI compiles static build and synchronises files (both articles and assets) with S3. Though I'd recommend to take a look at [circle.yml](circle.yml) so you have better understanding what steps involved.

Data management on the Contentful side based on the similar principle – once article or category is update there, Contentful fires webhook which hits CI rebuild so we have files built and data synchronised.
