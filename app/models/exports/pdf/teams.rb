# frozen_string_literal: true

Exports::PDF::Teams = Struct.new(:teams) do
  include Exports::PDF::Base
  include Exports::Teams

  def perform
    pdf_header(Team.model_name.human(count: 0))
    pdf.table(index_export_data(teams),
              header: true,
              row_colors: pdf_default_row_colors,
              width: pdf.bounds.width) do
      row(0).style(align: :center, font_style: :bold)
      column(1).style(align: :center)
      column(2).style(align: :center)
      column(3).style(align: :center) if Competition.one.lottery_numbers?
    end

    pdf_footer(name: 'Liste der Mannschaften')
  end

  def filename
    'mannschaften.pdf'
  end
end
