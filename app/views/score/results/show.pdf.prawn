headline_y = pdf.cursor
pdf.text @score_result.to_s, align: :center, size: 18
pdf.image "#{Rails.root}/app/assets/images/disciplines/#{@discipline.image}", width: 30, at: [10, headline_y]
pdf.move_down 12

pdf.table(build_data_rows, {
  header: true, 
  row_colors: pdf_row_colors, 
  width: pdf.bounds.width,
}) do
  row(0).style(align: :center, font_style: :bold)
  column(0).style(align: :center)
  column(1).style(align: :center )
end


if @score_result.group_assessment? && @discipline.single_discipline?
  pdf.start_new_page
  headline_y = pdf.cursor
  pdf.text "#{@score_result.to_s} - Mannschaftswertung", align: :center, size: 18
  pdf.image "#{Rails.root}/app/assets/images/disciplines/#{@discipline.image}", width: 30, at: [10, headline_y]
  pdf.move_down 12

  pdf.table(build_group_data_rows, {
    header: true, 
    row_colors: pdf_row_colors, 
    width: pdf.bounds.width,
  }) do
    row(0).style(align: :center, font_style: :bold)
    column(0).style(align: :center)
    column(1).style(align: :center )
  end
end

competition = Competition.first
name = [competition.name, l(competition.date)].join(" - ")
pdf.page_count.times do |i|
  pdf.bounding_box([pdf.bounds.left, pdf.bounds.bottom], width: pdf.bounds.width, height: 30) do
    pdf.go_to_page i+1
    pdf.move_down 3

    pdf.text "#{name} - Seite #{i+1} von #{pdf.page_count}", align: :center
  end
end