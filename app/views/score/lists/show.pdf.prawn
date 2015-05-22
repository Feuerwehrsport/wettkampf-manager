pdf_header pdf, @score_list.name, @score_list.discipline

pdf.table(show_export_data, {
  header: true, 
  row_colors: pdf_row_colors, 
  width: pdf.bounds.width,
  column_widths: { 0 => 40, 1 => 40, 5 => 40 }
}) do
  row(0).style(align: :center, font_style: :bold)
  column(0).style(align: :center)
  column(1).style(align: :center )
end

pdf_footer pdf
