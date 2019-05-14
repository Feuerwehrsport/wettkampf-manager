class Score::ListFactories::Best < Score::ListFactory
  validates :best_count, numericality: { greater_than_or_equal_to: 0 }, if: -> { step_reached?(:finish) }
  validates :before_result, presence: true, if: -> { step_reached?(:finish) }
  validate :result_assessments_match, if: -> { step_reached?(:finish) }

  def self.generator_params
    %i[before_result best_count]
  end

  def preview_entries_count
    [before_result.rows.count, best_count].min
  end

  protected

  def create_list_entry(result_row, run, track)
    any_list = result_row.list_entries.first
    list.entries.create!(
      entity: result_row.entity,
      run: run,
      track: track,
      assessment_type: any_list.assessment_type,
      assessment: result_row.result.assessment,
    )
  end

  def result_rows
    before_result.rows
  end

  def perform_rows
    all_rows = result_rows.dup
    result_rows = all_rows.shift(best_count.to_i)
    result_rows.push(all_rows.shift) while all_rows.present? && (result_rows.last <=> all_rows.first).zero?
    result_rows.reverse
  end

  private

  def result_assessments_match
    if assessments.length != 1
      errors.add(:before_result, 'Es darf nur eine Wertungsgruppe ausgewählt werden')
    elsif before_result.present? && before_result.assessment != assessments.first
      errors.add(:before_result, 'muss mit jetziger Wertungsgruppe übereinstimmen')
    end
  end
end
