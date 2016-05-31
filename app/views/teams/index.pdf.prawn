pdf_header pdf, Team.model_name.human(count: 0)

pdf.table(index_export_data, {
  header: true, 
  row_colors: pdf_default_row_colors, 
  width: pdf.bounds.width,
}) do
  row(0).style(align: :center, font_style: :bold)
  column(1).style(align: :center)
  column(2).style(align: :center )
end

pdf_footer pdf, name: 'Liste der Mannschaften'