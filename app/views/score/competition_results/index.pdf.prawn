first = true
@score_competition_results.each do |result|
  pdf.start_new_page unless first
  first = false
  pdf_header pdf, "Gesamtwertung - #{result}"

  pdf.table(table_data(result), {
    header: true,
    width: pdf.bounds.width,
    cell_style: { align: :center, size: 8},
    row_colors: pdf_default_row_colors,
  }) do
    row(0).style(font_style: :bold, size: 10)
    column([0, 1]).style(size: 12)
    column(-1).style(size: 12)
  end
end

pdf_footer pdf, name: 'Gesamtwertung'
