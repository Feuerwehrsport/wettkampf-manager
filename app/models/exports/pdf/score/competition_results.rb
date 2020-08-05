# frozen_string_literal: true

Exports::PDF::Score::CompetitionResults = Struct.new(:results) do
  include Exports::PDF::Base
  include Exports::CompetitionResults

  def perform
    results.each_with_index do |result, index|
      pdf.start_new_page unless index.zero?
      pdf_header("Gesamtwertung - #{result}")

      pdf.table(table_data(result),
                header: true,
                width: pdf.bounds.width,
                cell_style: { align: :center, size: 8 },
                row_colors: pdf_default_row_colors) do
        row(0).style(font_style: :bold, size: 10)
        column([0, 1]).style(size: 12)
        column(-1).style(size: 12)
      end
    end

    pdf_footer(name: 'Gesamtwertung')
  end

  def filename
    'gesamtwertungen.pdf'
  end

  protected

  def default_prawn_options
    super.merge(page_layout: :landscape)
  end
end
