class Exercise < Liquid::Block
    @@index = 0

    def initialize(tag_name, markup, tokens)
        super
        @title = markup.to_s
        @@index += 1
        puts "creating problem NO." + @@index.to_s
        @index = @@index
    end

    def render(context)
        site = context.registers[:site]
        converter = if site.respond_to?(:find_converter_instance)
            site.find_converter_instance(Jekyll::Converters::Markdown)
        else
            site.getConverterImpl(Jekyll::Converters::Markdown)
        end
        title = converter.convert("Exercise: " + @title).strip
        # hack way to avoid replace new line in code
        content = converter.convert(super(context)).gsub(/[\n]+/, "\n").strip
        # additional new line in the rendered code will make markdown parser add
        # unnecessary <p> tag between the code and cause problem
        block = '
<div class="panel-group exercise">
<div class="panel panel-default">
<div class="panel-heading">
<h4 class="panel-title">
<a data-toggle="collapse" href="#question%{index}" style="text-decoration:none;">%{title}</a>
</h4>
</div>
<div id="question%{index}" class="panel-collapse collapse">
<div class="panel-body">
    %{content}
</div></div></div>
</div>
' % {title: title, index: @index, content: content}
        return block #
    end
end

Liquid::Template.register_tag('exercise', Exercise)