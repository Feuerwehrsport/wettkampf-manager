pdf_header pdf, "Gesamtwertung - weiblich"

pdf.table(table_data(:female, @female), {
  header: true,
  width: pdf.bounds.width,
  cell_style: { align: :center},
}) do
  row(0).style(font_style: :bold)
end

pdf.start_new_page

pdf_header pdf, "Gesamtwertung - männlich"
pdf.table(table_data(:male, @male), {
  header: true,
  width: pdf.bounds.width,
  cell_style: { align: :center },
}) do
  row(0).style(font_style: :bold)
end

pdf_footer pdf
