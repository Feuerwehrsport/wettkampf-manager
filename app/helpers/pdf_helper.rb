module PDFHelper
  def pdf_default_row_colors
    color = 267
    (1..2).map do
      color -= 12
      color.to_s(16) * 3
    end
  end

  def pdf_footer(pdf, name: nil, no_page_count: nil, date: nil)
    competition = Competition.one
    date = competition.date if date.nil?
    competition_name = [competition.name, l(date)].join(' - ')
    pdf.page_count.times do |i|
      pdf.bounding_box([pdf.bounds.left, pdf.bounds.bottom - 2], width: pdf.bounds.width, height: 30) do
        pdf.go_to_page i + 1

        text = [competition_name]
        text.push(name) if name.present?
        text.push("Seite #{i + 1} von #{pdf.page_count}") unless no_page_count

        pdf.text(text.join(' - '), align: :center, size: 8)
      end
    end
  end

  def pdf_header(pdf, name, discipline: nil, date: nil)
    competition = Competition.one
    date = competition.date if date.nil?
    competition_name = [competition.name, l(date)].join(' - ')
    headline_y = pdf.cursor
    pdf.text name, align: :center, size: 17
    pdf.text competition_name, align: :center, size: 15
    return if discipline.blank?

    pdf.image("#{Rails.root}/app/assets/images/disciplines/#{discipline.decorate.image}",
              width: 30, at: [10, headline_y])
  end
end
