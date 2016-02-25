
width = pdf.bounds.width
height = pdf.bounds.height
pdf.image(@certificates_template.image.current_path, at: [0, height], width: width, height: height)


@certificates_template.text_positions.each do |tp|
    top = height - tp.top + tp.size
  if tp.align == "left"
    left = tp.left

    pdf.bounding_box([left, top], width: width, height: tp.size) do
      pdf.stroke_color 'FFFF00'
      pdf.stroke_bounds
    end
    pdf.text_box("#{tp.example}-#{tp.left}x#{tp.top}", at: [left, top], align: :left, width: width)
  elsif tp.align == "center"
    left = tp.left - width/2

    pdf.bounding_box([left, top], width: width, height: tp.size) do
      pdf.stroke_color 'FFFF00'
      pdf.stroke_bounds
    end
    pdf.text_box("#{tp.example}-#{tp.left}x#{tp.top}", at: [left, top], align: :center, width: width)
  elsif tp.align == "right"
  end
end