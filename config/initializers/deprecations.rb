Rails.application.config.after_initialize do
  old_behaviour = ActiveSupport::Deprecation.behavior
  ActiveSupport::Deprecation.behavior = ->(message, callstack) {
    unless message.starts_with?('DEPRECATION WARNING: Extra .css in SCSS file is unnecessary.',
                                'DEPRECATION WARNING: Extra .css in SASS file is unnecessary.')
      old_behaviour.each { |behavior| behavior[message,callstack] }
    end
  }
end