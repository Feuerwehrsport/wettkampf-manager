pdf_header pdf, @score_result.to_s, @discipline

pdf.table(build_data_rows, {
  header: true, 
  row_colors: pdf_default_row_colors, 
  width: pdf.bounds.width
}) do
  row(0).style(align: :center, font_style: :bold)
  column(0).style(align: :center)
  column(1).style(align: :center )
end


if @score_result.group_assessment? && @discipline.single_discipline?
  pdf.start_new_page
  pdf_header pdf, "#{@score_result.to_s} - Mannschaftswertung", @discipline

  pdf.table(build_group_data_rows, {
    header: true, 
    row_colors: pdf_default_row_colors, 
    width: pdf.bounds.width,
  }) do
    row(0).style(align: :center, font_style: :bold)
    column(0).style(align: :center)
    column(1).style(align: :center )
  end

  pdf.start_new_page
  build_group_data_details_rows.each do |team_result|

    data = [[team_result.team.to_s, team_result.time.to_s]]
    team_result.rows_in.each { |row| data.push(row) }
    team_result.rows_out.each { |row| data.push(row) }

    pdf.table(data, {
      header: true,
      position: :center,
      column_widths: [200, 80]
    }) do
      team_result.rows_in.each_with_index { |row, i| row(i+1).style(size: 10)}
      team_result.rows_out.each_with_index { |row, i| row(i+1+team_result.count).style(font_style: :italic, size: 8)}
      column(0).style(align: :right)
      column(1).style(align: :center)
      row(0).style(align: :center, font_style: :bold)
    end

    pdf.move_down 10
  end
end

pdf_footer pdf