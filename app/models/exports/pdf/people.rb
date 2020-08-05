# frozen_string_literal: true

Exports::PDF::People = Struct.new(:people) do
  include Exports::PDF::Base
  include Exports::People

  def perform
    first = true
    Genderable::GENDERS.keys.each do |gender|
      collection = people.gender(gender)
      next unless collection.exists?

      pdf.start_new_page unless first
      people_table(I18n.t("gender.#{gender}"), collection.decorate)
      first = false
    end

    pdf_footer(name: 'Liste der Wettkämpfer')
  end

  def filename
    'wettkaempfer.pdf'
  end

  protected

  def people_table(title, rows)
    pdf_header(title)

    pdf.table(index_export_data(rows),
              header: true,
              row_colors: pdf_default_row_colors,
              width: pdf.bounds.width) do
      row(0).style(align: :center, font_style: :bold)
      column(1).style(align: :center)
      column(2).style(align: :center)
      column(3).style(align: :center)
    end
  end
end
