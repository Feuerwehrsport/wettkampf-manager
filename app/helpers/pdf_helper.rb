module PDFHelper  
  def pdf_default_row_colors
    color = 264
    (1..2).map do
      color -= 12
      color.to_s(16) * 3
    end
  end

  def pdf_footer(pdf, options={})
    competition = Competition.one
    name = [competition.name, l(competition.date)].join(" - ")
    pdf.page_count.times do |i|
      pdf.bounding_box([pdf.bounds.left, pdf.bounds.bottom], width: pdf.bounds.width, height: 30) do
        pdf.go_to_page i+1
        pdf.move_down 3

        text = [name]
        text.push("Seite #{i+1} von #{pdf.page_count}") unless options[:no_page_count]

        pdf.text(text.join(' - '), align: :center)
      end
    end
  end

  def pdf_header pdf, name, discipline=nil
    headline_y = pdf.cursor
    pdf.text name, align: :center, size: 18
    if discipline.present?
      pdf.image "#{Rails.root}/app/assets/images/disciplines/#{discipline.decorate.image}", width: 30, at: [10, headline_y]
    end
    pdf.move_down 12
  end
end