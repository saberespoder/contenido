require 'contentful/webhook/listener'

class WebhookReloadHandler < Contentful::Webhook::Listener::Controllers::Wait
  def perform(*)
    logger.info 'Restarting'
    system('kill -9 $(lsof -i tcp:4567 -t); bundle exec middleman server')
  end

  def self.start(options)
    Contentful::Webhook::Listener::Server.start do |config|
      config[:endpoints] = [{
        endpoint: '/receive',
        timeout: options.webhook_timeout,
        controller: options.webhook_controller
      }]
      logger = Logger.new(STDOUT)
      logger.level = Logger::INFO
      logger.formatter = proc do |severity, datetime, progname, msg|
        date_format = datetime.strftime("%Y-%m-%d %H:%M:%S")
        if severity == "INFO"
          "Webhook Server: #{msg}\n"
        else
          "[#{date_format}] #{severity} (#{progname}): #{msg}\n"
        end
      end
      config[:logger] = logger
    end
  end
end
