if @only != :group_assessment
  pdf_header pdf, @score_result.to_s, discipline: @discipline, date: @score_result.date
  
  pdf.table(build_data_rows(true), {
    header: true, 
    row_colors: pdf_default_row_colors, 
    width: pdf.bounds.width,
    cell_style: { align: :center, size: 10 }
  }) do
    row(0).style(font_style: :bold, size: 10)
    column(-1).style(font_style: :bold)
  end
end

if @only != :single_competitors && @score_result.group_assessment? && @discipline.single_discipline?
  pdf.start_new_page if @only.nil?
  pdf_header pdf, "#{@score_result.to_s} - Mannschaftswertung", discipline: @discipline, date: @score_result.date

  pdf.table(build_group_data_rows, {
    header: true, 
    row_colors: pdf_default_row_colors, 
    column_widths: [60, 200, 80],
    position: :center,
    cell_style: { align: :center, size: 10 }
  }) do
    row(0).style(font_style: :bold, size: 11)
  end

  pdf.start_new_page
  build_group_data_details_rows.each do |team_result|

    data = [[team_result.team.to_s, team_result.result_entry.to_s]]
    team_result.rows_in.each { |row| data.push(row) }
    team_result.rows_out.each { |row| data.push(row) }

    pdf.table(data, {
      header: true,
      column_widths: [200, 80],
      position: :center,
    }) do
      team_result.rows_in.each_with_index { |row, i| row(i+1).style(size: 10)}
      team_result.rows_out.each_with_index { |row, i| row(i+1+team_result.rows_in.count).style(font_style: :italic, size: 8)}
      column(0).style(align: :right)
      column(1).style(align: :center)
      row(0).style(align: :center, font_style: :bold)
    end

    pdf.move_down 10
  end
end

pdf_footer pdf, name: @score_result.to_s, date: @score_result.date