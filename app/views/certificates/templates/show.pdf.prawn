width = pdf.bounds.width
height = pdf.bounds.height

if @certificates_template.font.present?
  pdf.font_families.update(
    "certificates_template" => { normal: @certificates_template.font.current_path }
  )
end

if @certificates_template.image.present?
  pdf.image(@certificates_template.image.current_path, at: [0, height], width: width, height: height)
end

@certificates_template.text_positions.each do |tp|
  top = height - tp.top
  left = tp.left
  left = left - width/2 if tp.align == "center"
  left = left - width if tp.align == "right"
  
  if @certificates_template.font.present?
    pdf.font("certificates_template") do
      pdf.text_box(tp.example, at: [left, top], align: tp.align.to_sym, width: width, size: tp.size)
    end
  else
    pdf.text_box(tp.example, at: [left, top], align: tp.align.to_sym, width: width, size: tp.size)
  end
end