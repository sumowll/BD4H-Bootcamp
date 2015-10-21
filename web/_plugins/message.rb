class Message < Liquid::Block
    def initialize(tag_name, markup, tokens)
        super
        @type=tag_name.to_s[3..-1]
    end

    def render(context)
        content = super
        '<p class="msgbox bg-%{type}">%{content}</p>' % {type: @type, content: content}
    end
end

Liquid::Template.register_tag('msgprimary', Message)
Liquid::Template.register_tag('msgsuccess', Message)
Liquid::Template.register_tag('msginfo', Message)
Liquid::Template.register_tag('msgwarning', Message)
Liquid::Template.register_tag('msgdanger', Message)
