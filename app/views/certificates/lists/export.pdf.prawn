width = pdf.bounds.width
height = pdf.bounds.height

if @certificates_template.font.present?
  pdf.font_families.update(
    "certificates_template" => { normal: @certificates_template.font.current_path }
  )
end

@rows.each_with_index do |row, i|
  if @certificates_template.image.present? && @certificates_list.image.to_i == 1
    pdf.image(@certificates_template.image.current_path, at: [0, height], width: width, height: height)
  end

  if row.is_a?(Score::DoubleEventResultRow)
    time = row.sum_result_entry
  else
    time = row.best_result_entry
  end

  @certificates_template.text_positions.each do |tp|
    top = height - tp.top
    left = tp.left
    left = left - width/2 if tp.align == "center"
    left = left - width if tp.align == "right"
    
    text = case tp.key
      when :team_name
        row.entity.team.try(:numbered_name)
      when :person_name
        row.entity
      when :person_bib_number
        row.entity.try(:bib_number)
      when :time_long
        time.to_s.gsub("s", "Sekunden").gsub("D", "ungültig")
      when :time_short
       time
      when :rank
        "#{place_for_row row}."
      when :assessment
        @score_result.assessment.name.presence || @score_result.assessment.discipline
      when :assessment_with_gender
        @score_result.assessment
      when :gender
        @score_result.assessment.translated_gender
      when :date
        l(Competition.one.date)
      when :place
        Competition.one.place
      when :competition_name
        Competition.one.name
    end

    if @certificates_template.font.present?
      pdf.font("certificates_template") do
        pdf.text_box(text.to_s, at: [left, top], align: tp.align.to_sym, width: width, size: tp.size)
      end
    else
      pdf.text_box(text.to_s, at: [left, top], align: tp.align.to_sym, width: width, size: tp.size)
    end
  end
  pdf.start_new_page if  i < (@rows.count - 1)
end