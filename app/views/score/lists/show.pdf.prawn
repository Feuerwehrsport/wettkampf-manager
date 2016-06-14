pdf_header pdf, @score_list.name, @score_list.discipline

track_count = @score_list.track_count

column_widths = { 0 => 35, 1 => 35, -1 => 50 }
column_widths[2] = 35 if Competition.one.show_bib_numbers?
if params[:more_columns].present?
  column_widths[-1] = 40
  column_widths[-2] = 40
  column_widths[-3] = 40
end
pdf.table(show_export_data, {
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

pdf_footer pdf, name: @score_list.name
