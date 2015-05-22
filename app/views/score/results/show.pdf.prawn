pdf_header pdf, @score_result.to_s, @discipline

pdf.table(build_data_rows, {
  header: true, 
  row_colors: pdf_default_row_colors, 
  width: pdf.bounds.width,
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
end

pdf_footer pdf