pdf_header pdf, @score_list.name, @score_list.discipline

pdf.table(show_export_data, {
  header: true, 
  row_colors: pdf_row_colors, 
  width: pdf.bounds.width,
  cell_style: { align: :center, size: 10 },
  column_widths: { 0 => 40, 1 => 40, -1 => 50 }
}) do
  row(0).style(font_style: :bold)
end

pdf_footer pdf
