pdf_header pdf, @result.to_s, @result.assessment.discipline

head = ["", "Name", "Punkte", "Teil.", "Summe"]
@result.competitions.each do |competition|
  head.push(content: competition.name.truncate(13), colspan: 2, border_widths: [1, 1, 1, 2])
end

data = [head]
@result.rows.each do |row|
  data_row = [
    "#{place_for_row row}.",
    row.person.to_s,
    row.points.to_s,
    row.count.to_s,
    row.stopwatch_time.to_s,
  ]
  @result.competitions.each do |competition|
    result = row.result_for_competition(competition).try(:decorate)
    data_row.push(content: result.try(:points).to_s, size: 10, border_widths: [1, 1, 1, 2])
    data_row.push(content: result.try(:stopwatch_time).to_s, size: 10)
  end
  data.push(data_row)
end


pdf.table(data, {
  header: true,
  width: pdf.bounds.width,
  cell_style: { align: :center},
}) do
  row(0).style(font_style: :bold)
end

pdf_footer pdf