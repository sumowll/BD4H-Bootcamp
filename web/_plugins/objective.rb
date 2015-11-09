class LearningObjective < Liquid::Block
    def render(context)
        site = context.registers[:site]
        converter = if site.respond_to?(:find_converter_instance)
            site.find_converter_instance(Jekyll::Converters::Markdown)
        else
            site.getConverterImpl(Jekyll::Converters::Markdown)
        end
        output = converter.convert(super(context))

        '<div class="bs-callout bs-callout-info" id="callout-helper-context-color-specificity">
        <h4>Learning Objectives</h4>' + 
        output + 
        '</div>'
    end
end

Liquid::Template.register_tag('objective', LearningObjective)