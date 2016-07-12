pdf_header pdf, @score_list.name, discipline: @score_list.discipline, date: @score_list.date

track_count = @score_list.track_count

lines = show_export_data
column_widths = { 0 => 35, 1 => 35, -1 => 50 }
column_widths[2] = 35 if Competition.one.show_bib_numbers? && single_discipline?
if params[:more_columns].present?
  column_widths[-1] = 40
  column_widths[-2] = 40
  column_widths[-3] = 40
end

lines_per_page = (32/track_count)*track_count
headline = lines.shift
first = true

loop do
  current_lines = lines.shift(lines_per_page)
  break if current_lines.blank?
  pdf.start_new_page unless first
  first = false

  pdf.table([headline] + current_lines, {
    header: true, 
    row_colors: pdf_row_colors, 
    width: pdf.bounds.width,
    cell_style: { align: :center, size: 10 },
    column_widths: column_widths
  }) do
    row(0).style(font_style: :bold, border_widths: [1, 1, 2, 1])
    i = 0
    loop do
      i += track_count
      break if i > row_length
      row(i).style(border_widths: [1, 1, 2, 1])
    end
  end
end

pdf_footer pdf, name: @score_list.name
