headline_y = pdf.cursor
pdf.text @score_list.name, align: :center, size: 18
pdf.image "#{Rails.root}/app/assets/images/disciplines/#{@score_list.discipline.image}", width: 30, at: [10, headline_y]
pdf.move_down 12

header = ["Lauf", "Bahn"]
if single_discipline?
  header.push("Vorname")
  header.push("Nachname")
end
header.push("Mannschaft")
header.push("Zeit")

data = [header]
score_list_entries do |entry, run, track|
  line = []
  if track == 1
    line.push(run)
  else
    line.push("")
  end

  line.push(track)
  line.push(entry.try(:entity).try(:first_name))
  line.push(entry.try(:entity).try(:last_name))
  line.push(entry.try(:entity).try(:team).try(:name))
  line.push(result_for entry)
  data.push(line)
end

pdf.table(data, {
  header: true, 
  row_colors: pdf_row_colors, 
  width: pdf.bounds.width,
  column_widths: { 0 => 40, 1 => 40, 5 => 40 }
}) do
  row(0).style(align: :center, font_style: :bold)
  column(0).style(align: :center)
  column(1).style(align: :center )
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
