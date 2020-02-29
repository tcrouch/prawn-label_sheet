# Prawn::LabelSheet

[![Gem Version](https://img.shields.io/gem/v/prawn-label_sheet.svg)](https://rubygems.org/gems/prawn-label_sheet)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/28933c41f8ed4d39a1c96a5895de2343)](https://app.codacy.com/manual/t.crouch/prawn-label_sheet?utm_source=github.com&utm_medium=referral&utm_content=tcrouch/prawn-label_sheet&utm_campaign=Badge_Grade_Dashboard)
[![Inline docs](http://inch-ci.org/github/tcrouch/prawn-label_sheet.svg?branch=master)](http://inch-ci.org/github/tcrouch/prawn-label_sheet)
[![Yard Docs](http://img.shields.io/badge/yard-docs-blue.svg)](http://rubydoc.info/github/tcrouch/prawn-label_sheet)

Generate sets of labels or stickers using Prawn PDF.

For simple bulk generation, can break page between groups of data.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'prawn-label_sheet'
```

And then execute:

```shell
$ bundle
```

Or install it yourself as:

```shell
$ gem install prawn-label_sheet
```

## Usage

```ruby
items = %w[red orange yellow green blue indigo violet]

Prawn::LabelSheet.generate("out.pdf", items) do |pdf, item|
  pdf.text_box item
end
```

Each item is passed to the block, together with a bounding box for the label.

For larger sets, page breaks can be inserted on change of value:

```ruby
# Change in value returned from item[3]
generate("out.pdf", items, break_on: 3)

# Change in value returned from proc
generate("out.pdf", items, break_on: ->(item) { item.downcase })
```

### Example

In a school you might want a single document with labels for all students,
where a new sheets is started for each class.

Given your class data, pre-sorted by [class, last, first]:

```csv
Arthur,Aardvark,1234,Class A
Sam,Smith,1235,Class A
Bob,Bobbington,1236,Class B
Leah,Lemon,1237,Class B
```

```ruby
csv = CSV.read("students.csv")

Prawn::LabelSheet.generate("out.pdf", csv, break_on: 3) do |pdf, data|
  last_name, first_name, class_name, student_id = data

  b = pdf.bounds
  full_width = b.width - 12
  half_width = (full_width / 2).floor - 1

  pdf.font 'Helvetica'

  pdf.move_down 12
  pdf.indent(6) do
    pdf.text_box "#{last_name} #{first_name}",
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
  pdf.text_box student_id,
    at: [b.left, pdf.cursor],
    width: half_width, height: 10,
    overflow: :shrink_to_fit
  pdf.text_box class_name,
    at: [b.right - half_width, pdf.cursor],
    width: half_width, height: 10,
    overflow: :shrink_to_fit
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tcrouch/prawn-label_sheet.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
