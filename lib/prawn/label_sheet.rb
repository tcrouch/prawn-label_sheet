# frozen_string_literal: true

require 'prawn'
require 'prawn/label_sheet/version'
require 'prawn/label_sheet/configuration'

# @see http://prawnpdf.org
module Prawn
  # Document supporting bulk label/sticker generation
  class LabelSheet
    include Prawn::View

    # Error class
    class Error < StandardError; end

    # Override Prawn::View#document
    attr_reader :document
    attr_reader :layout

    # Render and persist a set of label sheets
    #
    # @param filename [String] Name of output file
    # @param labels (see #initialize)
    # @param options (see #initialize)
    # @yieldparam (see #initialize)
    def self.generate(filename, labels, **options, &block)
      pdf = new(labels, **options, &block)
      pdf.document.render_file(filename)
    end

    # @param labels [Enumerable] collection of labels
    # @option options [String] :layout
    # @option options [Proc, Integer, String] :break_on
    # @option options [Prawn::Document] :document
    # @yieldparam doc (see #make_label)
    # @yieldparam item (see #make_label)
    def initialize(labels, **options, &block)
      @layout = setup_layout(options[:layout]).merge(info: options[:info])
      @document = setup_document(options[:document], @layout)

      @count = 0
      @break_on = options[:break_on]

      labels.each { |label| make_label(label, options, &block) }
    end

    # Generate individual label
    #
    # @param item [#[], Object]
    # @yieldparam doc [Prawn::Document] document
    # @yieldparam item [Object] label item
    # @return [Integer] tally of labels on current page
    def make_label(item, _options)
      break_page if break_page?(item)

      @document.grid(*gridref).bounding_box { yield @document, item }
      @count += 1
    end

    protected

    # Determine whether to begin a new page
    #
    # @param item [Proc, #[]]
    # @return [Boolean]
    def break_page?(item)
      return false unless @break_on

      val = @break_on.is_a?(Proc) ? @break_on.call(item) : item[@break_on]
      return false if @last_val == val

      @last_val = val
      @count.positive?
    end

    # Begin a new page
    def break_page
      @document.start_new_page
      @count = 0
    end

    # Current grid coordinates
    #
    # @return [Array(Integer, Integer)]
    def gridref
      q, r = @count.divmod(@document.grid.rows * @document.grid.columns)

      if q.positive? && r.zero?
        @document.start_new_page
        return [0, 0]
      end

      r.divmod(@document.grid.columns)
    end

    # Extract definition & provide defaults for required keys
    #
    # @param layout_def [String, #to_h] layout definition or identifier
    # @return [Hash]
    def setup_layout(layout_def)
      defs = resolve_layout(layout_def).slice(
        'page_size', 'columns', 'rows',
        'top_margin', 'bottom_margin',
        'left_margin', 'right_margin',
        'column_gutter', 'row_gutter'
      ).transform_keys(&:to_sym)

      { page_size: 'A4', top_margin: 40, left_margin: 20 }.merge!(defs)
    end

    # Lookup layout definition
    #
    # @param layout_def [String, #to_h] layout definition or identifier
    # @return [Hash]
    def resolve_layout(layout_def)
      dfn = layout_def || config.default_layout
      return dfn.to_h if dfn.respond_to?(:to_h)

      config.layouts[dfn] || raise(Error, 'Unknown layout')
    end

    # @param doc [Prawn::Document, nil]
    # @param layout [Hash]
    # @return [Prawn::Document]
    def setup_document(doc, layout)
      doc&.start_new_page(layout)
      doc ||= Document.new layout
      doc.define_grid layout
      doc
    end

    # @return [Prawn::LabelSheet::Configuration]
    def config
      self.class.config
    end
  end
end
