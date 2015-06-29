first = true
@score_competition_results.each do |result|
  pdf.start_new_page unless first
  first = false
  pdf_header pdf, "Gesamtwertung - #{result}"

  pdf.table(table_data(result, true), {
    header: true,
    width: pdf.bounds.width,
    cell_style: { align: :center},
  }) do
    row(0).style(font_style: :bold)
  end
end

pdf_footer pdf
