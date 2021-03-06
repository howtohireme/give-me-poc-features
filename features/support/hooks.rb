# frozen_string_literal: true

DatabaseCleaner.strategy = :truncation
Faker::Config.locale = :en
Watir.logger.level = :debug
Watir.logger.output = 'artifacts/watir.log'

Before do |scenario|
  DatabaseCleaner.clean

  @cucumber_host = ENV['CUCUMBER_HOST'] || default_host
  browser_options = headless? || !dev_env? ? browser_capabilities : []

  @browser = Watir::Browser.new(:chrome, switches: browser_options)
  @browser.window.resize_to(1200, 800)
end

After do |scenario|
  debug! if scenario.failed? && debug?
  deauth_github(@browser) if scenario.failed? && requires_github_cleanup?(scenario)
  make_screenshot(@browser, scenario) if scenario.failed? && !dev_env?
  @browser.close
  DatabaseCleaner.clean
end

def browser_capabilities
  %w[
    --whitelisted-ips=""
    --enable-logging
    --verbose
    --log-level=1
    --log-path=/tmp/chromedriver.log
    --disable-gpu
    --headless
    --no-sandbox
  ]
end

def dev_env?
  !ENV['CUCUMBER_HOST']
end

def headless?
  !ENV['HEADLESS'].nil?
end

def debug?
  ENV['DEBUG']
end

def debug!
  binding.pry
end

def default_host
  'http://lvh.me:3000'
end

def make_screenshot(browser, scenario)
  Screenshoter.new(browser, scenario.name).call
end

def requires_github_cleanup?(scenario)
  scenario.source_tag_names.include?('@github-interaction')
end

def deauth_github(browser)
  goto('https://github.com/settings/applications')
  page = Pages::Public::GithubPage.new(browser)
  page = page.deauthorize_app
  page = page.confirm_deauthorize_app
end
