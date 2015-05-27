class AssessmentRequestDecorator < ApplicationDecorator
  decorates_association :assessment

  def type
    t("assessment_types.#{assessment_type}_order", group_competitor_order: group_competitor_order)
  end

  def short_type
    t("assessment_types.#{assessment_type}_short_order", group_competitor_order: group_competitor_order)
  end
end
