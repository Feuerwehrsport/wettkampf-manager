module PDF::Base
  extend ActiveSupport::Concern

  class_methods do
    def perform(*args)
      instance = new(*args)
      instance.unicode_perform
      instance
    end
  end

  def bytestream
    @bytestream ||= pdf.render
  end

  def unicode_perform
    font_path = Rails.root.join('app', 'assets', 'fonts')
    pdf.font_families.update(
      'Arial' => {
        normal: "#{font_path}/Arial.ttf",
        bold: "#{font_path}/Arial_Bold.ttf",
        italic: "#{font_path}/Arial_Italic.ttf",
        bold_italic: "#{font_path}/Arial_Bold_Italic.ttf",
      },
    )

    pdf.font('Arial')
    perform
  end

  protected

  def pdf
    @pdf ||= Prawn::Document.new(default_prawn_options)
  end

  def default_prawn_options
    {
      page_size: 'A4',
    }
  end

  def pdf_footer(name: nil, no_page_count: nil, date: nil)
    competition = Competition.one
    date = competition.date if date.nil?
    base_footer_line = [competition.name, I18n.l(date)]
    base_footer_line.push(name) if name.present?

    pdf.page_count.times do |page|
      pdf.bounding_box([pdf.bounds.left, pdf.bounds.bottom - 2], width: pdf.bounds.width, height: 30) do
        pdf.go_to_page(page + 1)

        footer_line = base_footer_line
        footer_line.push("Seite #{page + 1} von #{pdf.page_count}") unless no_page_count

        pdf.text(footer_line.join(' - '), align: :center, size: 8)
      end
    end
  end
end
