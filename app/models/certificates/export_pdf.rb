Certificates::ExportPDF = Struct.new(:pdf, :template, :rows, :background_image) do
  def render
    pdf.font_families.update('certificates_template' => { normal: font_path })

    rows.each_with_index do |row, i|
      if template.image.present? && background_image
        pdf.image(template.image.current_path, at: [0, height], width: width, height: height)
      end

      pdf.font('certificates_template') do
        template.text_fields.each { |position| render_position(position, row) }
      end

      pdf.start_new_page if i != rows.count - 1
    end
  end

  private

  def width
    @width ||= pdf.bounds.width
  end

  def height
    @height ||= pdf.bounds.height
  end

  def font_path
    template.font.present? ? template.font.current_path : Rails.root.join('app', 'assets', 'fonts', 'Arial.ttf')
  end

  def render_position(position, row)
    options = {
      at: [position.left, position.top],
      width: position.width,
      height: position.height,
      size: position.size,
      align: position.align,
      valign: :center,
    }
    pdf.text_box(row.get(position).to_s, options.merge(min_font_size: 4, overflow: :shrink_to_fit))
  rescue Prawn::Errors::CannotFit
    pdf.text_box(row.get(position).to_s, options.merge(size: 4, overflow: :truncate))
  end
end
