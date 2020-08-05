# frozen_string_literal: true

class AssessmentRequestDecorator < ApplicationDecorator
  decorates_association :assessment

  def self.fs_names
    %w[
      A1 A2 A3 A4
      B1 B2 B3 B4
      C1 C2 C3 C4
      D1 D2 D3 D4
    ]
  end

  def self.la_names
    [
      '1 Maschinist',
      '2 A-Länge',
      '3 Saugkorb',
      '4 B-Schlauch',
      '5 Strahlrohr links',
      '6 Verteiler',
      '7 Strahlrohr rechts',
    ]
  end

  def self.la_names_short
    [
      ['1', h.tag.span('(Ma)', class: 'small')],
      ['2', h.tag.span('(A)', class: 'small')],
      ['3', h.tag.span('(SK)', class: 'small')],
      ['4', h.tag.span('(B)', class: 'small')],
      ['5', h.tag.span('(SL)', class: 'small')],
      ['6', h.tag.span('(V)', class: 'small')],
      ['7', h.tag.span('(SR)', class: 'small')],
    ]
  end

  def self.gs_names
    [
      '1 B-Schlauch',
      '2 Verteiler',
      '3 C-Schlauch',
      '4 Knoten',
      '5 D-Schlauch',
      '6 Läufer',
    ]
  end

  def self.gs_names_short
    [
      ['1', h.tag.span('(B)', class: 'small')],
      ['2', h.tag.span('(V)', class: 'small')],
      ['3', h.tag.span('(C)', class: 'small')],
      ['4', h.tag.span('(Kn)', class: 'small')],
      ['5', h.tag.span('(D)', class: 'small')],
      ['6', h.tag.span('(Lä)', class: 'small')],
    ]
  end

  def type
    if group_competitor?
      t('assessment_types.group_competitor_order', competitor_order: group_competitor_order)
    elsif single_competitor?
      t('assessment_types.single_competitor_order', competitor_order: single_competitor_order)
    elsif out_of_competition?
      t('assessment_types.out_of_competition_order')
    elsif competitor?
      case assessment.discipline.key
      when :fs
        self.class.fs_names[competitor_order]
      when :la
        self.class.la_names[competitor_order]
      when :gs
        self.class.gs_names[competitor_order]
      end
    else
      0
    end
  end

  def short_type
    if group_competitor?
      t('assessment_types.group_competitor_short_order', competitor_order: group_competitor_order)
    elsif single_competitor?
      t('assessment_types.single_competitor_short_order', competitor_order: single_competitor_order)
    elsif out_of_competition?
      t('assessment_types.out_of_competition_short')
    elsif competitor?
      case assessment.discipline.key
      when :fs
        self.class.fs_names[competitor_order]
      when :la
        h.safe_join(self.class.la_names_short[competitor_order] || [])
      when :gs
        h.safe_join(self.class.gs_names_short[competitor_order] || [])
      end
    else
      0
    end
  end
end
