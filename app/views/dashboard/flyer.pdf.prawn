pdf.text "Webseite mit Ergebnissen", align: :center, size: 20
pdf.text "im WLAN", align: :center, size: 20
Discipline.types.first(5).each_with_index do |discipline, i|
  pdf.image "#{Rails.root}/app/assets/images/disciplines/#{discipline.new.decorate.image}", width: 50, at: [10, 700-i*60]
end
pdf.move_down 12

pdf.font("Courier") do
  pdf.text_box(decorated_competition.flyer_text, at: [90, 600], align: :left, width: 500, size: 16)
end

pdf.text_box(hostname_url, at: [26, 345], align: :center, width: 500, size: 20)
pdf.print_qr_code(hostname_url, extent: 300, pos: [126, 320], level: :h)

pdf_footer pdf, no_page_count: true