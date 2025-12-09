module TurboStreamActionsHelper
  def add_css_class(target, classes:)
    turbo_stream_action_tag :add_css_class, target:, classes:, template: false
  end

  def remove_css_class(target, classes:)
    turbo_stream_action_tag :remove_css_class, target:, classes:, template: false
  end
end

Turbo::Streams::TagBuilder.prepend(TurboStreamActionsHelper)
