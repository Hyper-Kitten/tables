require "active_support/concern"
require "forwardable"

module HyperKittenTables
  module Concerns
    module Table
      extend ActiveSupport::Concern

      included do
        extend Forwardable

        def_delegators :@view_context, :content_tag, :capture

        Column = Struct.new(:name, :method_name, :sort_key, :block, :sortable, :options)
      end

      def initialize(collection: [], requested_columns: [], &block)
        @collection = collection
        @columns = []
        @requested_columns = requested_columns
        yield self if block_given?
      end

      def column(name, method_name: nil, sort_key: nil, sortable: true, **options, &block)
        if method_name.nil?
          method_name = name.to_s.parameterize.underscore
          name = name.to_s.titleize unless block_given?
        end
        sort_key = method_name if sort_key.blank?
        @columns << Column.new(name, method_name, sort_key, block, sortable, options)
      end

      def header_sort_url(&block)
        @header_sort_url = block
      end

      def footer(&block)
        @footer = block
      end

      def render_in(view_context)
        @view_context = view_context

        render_table
      end

      private

      def visible_columns
        return @columns if @requested_columns.empty?

        @columns.select { |column| @requested_columns.include?(column.name) }
      end

      def render_table
        content_tag(:table) { render_header + render_body } + render_footer
      end

      def render_header
        content_tag(:thead) do
          content_tag(:tr) do
            visible_columns.map do |column|
              if column.sortable
                content_tag(:th) do
                  @header_sort_url.call(column, @view_context.params).html_safe
                end
              else
                content_tag(:th, column.name)
              end
            end.join.html_safe
          end
        end
      end

      def render_body
        content_tag(:tbody) do
          @collection.map do |record|
            content_tag(:tr) do
              visible_columns.map do |column|
                column_content = if column.block
                  capture(record, &column.block)
                else
                  record.public_send(column.method_name)
                end
                content_tag(:td, column_content, column.options)
              end.join.html_safe
            end
          end.join.html_safe
        end
      end

      def render_footer
        if @footer
          content_tag(:div, capture(&@footer))
        end
      end
    end
  end
end
