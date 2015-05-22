if @female.count > 0
  pdf_header pdf, "Weiblich"

  pdf.table(index_export_data(@female), {
    header: true, 
    row_colors: pdf_default_row_colors, 
    width: pdf.bounds.width,
  }) do
    row(0).style(align: :center, font_style: :bold)
    column(1).style(align: :center)
    column(2).style(align: :center)
    column(3).style(align: :center)
  end
end

pdf.start_new_page if @female.count + @male.count > 0

if @male.count > 0
  pdf_header pdf, "Männlich"

  pdf.table(index_export_data(@male), {
    header: true, 
    row_colors: pdf_default_row_colors, 
    width: pdf.bounds.width,
  }) do
    row(0).style(align: :center, font_style: :bold)
    column(1).style(align: :center)
    column(2).style(align: :center)
    column(3).style(align: :center)
  end
end

pdf_footer pdf