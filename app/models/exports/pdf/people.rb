Exports::PDF::People = Struct.new(:female, :male) do
  include Exports::PDF::Base
  include Exports::People

  def perform
    people_table('Frauen', female) if female.present?
    pdf.start_new_page             if (female.count + male.count).positive?
    people_table('Männer', male)   if male.present?

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
