# frozen_string_literal: true

require 'bundler/setup'
require 'csv'
require 'prawn/label_sheet'

csv = CSV.read(File.join(__dir__, 'students.csv'), headers: true)
out = File.join(__dir__, 'students.pdf')

Prawn::LabelSheet.generate(
  out,
  csv,
  break_on: 'class',
  info: { Title: 'Students by class' }
) do |pdf, data|
  b = pdf.bounds
  full_width = b.width - 12
  half_width = (full_width / 2).floor - 1

  pdf.font 'Helvetica'

  pdf.move_down 12
  pdf.indent(6) do
    pdf.text_box "#{data['firstName']} #{data['lastName']}",
      at: [b.left, pdf.cursor],
      width: full_width, height: 12,
      overflow: :truncate
  end
  pdf.move_down 12
  pdf.stroke_horizontal_rule
  pdf.move_down 6
  pdf.font_size 7 do
    pdf.text_box "ID",
      at: [b.left, pdf.cursor],
      width: half_width, height: 8
    pdf.text_box "Class",
      at: [b.right - half_width, pdf.cursor],
      width: half_width, height: 8
  end
  pdf.move_down 9
  pdf.text_box data["studentId"],
    at: [b.left, pdf.cursor],
    width: half_width, height: 10,
    overflow: :shrink_to_fit
  pdf.text_box data["class"],
    at: [b.right - half_width, pdf.cursor],
    width: half_width, height: 10,
    overflow: :shrink_to_fit
end
