class Jekyll::Converters::Markdown::CustomProcessor
  def initialize(config)
    require 'Redcarpet'
    @config = config
  rescue LoadError
    STDERR.puts 'You are missing a library required for Markdown. Please run:'
    STDERR.puts '  $ [sudo] gem install Redcarpet'
    raise FatalException.new("Missing dependency: Redcarpet")
  end

  def convert(content)
    renderer = Redcarpet::Render::HTML.new(filter_html: true, hard_wrap: false)
    markdown = Redcarpet::Markdown.new(renderer, autolink: true, tables: true, fenced_code_blocks: true, quote: true, prettify: true, footnotes: true)
    markdown.render(content)
  end
end