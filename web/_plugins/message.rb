class Message < Liquid::Block
    def initialize(tag_name, markup, tokens)
        super
        @type=tag_name.to_s[3..-1]
    end

    def render(context)
        site = context.registers[:site]
        converter = if site.respond_to?(:find_converter_instance)
            site.find_converter_instance(Jekyll::Converters::Markdown)
        else
            site.getConverterImpl(Jekyll::Converters::Markdown)
        end
        # hack way to avoid replace new line in code
        content = converter.convert(super(context)).gsub(/[\n]+/, "\n").strip
        header = @type.capitalize
        if header == "Info"
            header = "Information"
        end
        '<div class="msgbox bg-%{type}"><h4>%{header}</h4>%{content}
</div>' % {type: @type, header: header, content: content}
    end
end

Liquid::Template.register_tag('msgprimary', Message)
Liquid::Template.register_tag('msgsuccess', Message)
Liquid::Template.register_tag('msginfo', Message)
Liquid::Template.register_tag('msgwarning', Message)
Liquid::Template.register_tag('msgdanger', Message)
