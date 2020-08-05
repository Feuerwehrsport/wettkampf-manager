# frozen_string_literal: true

class Exports::PDF::Flyer
  include Exports::PDF::Base

  def perform
    pdf.text(competition.flyer_headline, align: :center, size: 20)
    Discipline.types.first(5).each_with_index do |discipline, index|
      pdf.image(Rails.root.join('app', 'assets', 'images', 'disciplines', discipline.new.decorate.image),
                width: 50, at: [10, 700 - index * 60])
    end
    pdf.move_down(12)

    pdf.font('Courier') do
      pdf.text_box(competition.flyer_text, at: [90, 600], align: :left, width: 500, size: 16)
    end

    pdf.text_box(competition.hostname_url, at: [26, 345], align: :center, width: 500, size: 20)
    pdf.print_qr_code(competition.hostname_url, extent: 300, pos: [126, 320], level: :h)

    pdf_footer(no_page_count: true)
  end
end
