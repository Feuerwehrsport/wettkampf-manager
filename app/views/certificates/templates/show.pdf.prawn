width = pdf.bounds.width
height = pdf.bounds.height

pdf.image(@certificates_template.image.current_path, at: [0, height], width: width, height: height)

@certificates_template.text_positions.each do |tp|
  top = height - tp.top
  left = tp.left
  left = left - width/2 if tp.align == "center"
  left = left - width if tp.align == "right"
  
  pdf.text_box(tp.example, at: [left, top], align: tp.align.to_sym, width: width, size: tp.size)
end