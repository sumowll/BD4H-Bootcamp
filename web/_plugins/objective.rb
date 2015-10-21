class LearningObjective < Liquid::Block
    def render(context)
        site = context.registers[:site]
        converter = site.getConverterImpl(::Jekyll::Converters::Markdown)
        output = converter.convert(super(context))

        '<div class="bs-callout bs-callout-info" id="callout-helper-context-color-specificity">
        <h4>Learning Objectives</h4>' + 
        output + 
        '</div>'
    end
end

Liquid::Template.register_tag('objective', LearningObjective)