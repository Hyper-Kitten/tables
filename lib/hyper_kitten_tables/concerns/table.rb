require "active_support/concern"
require "forwardable"

module HyperKittenTables
  module Concerns
    module Table
      extend ActiveSupport::Concern

      included do
        extend Forwardable

        def_delegators :@view_context, :content_tag, :capture, :request

        const_set :Column, Struct.new(:name, :method_name, :sort_key, :block, :sortable, :options, :header_options)
      end

      def initialize(collection: [], requested_columns: [], sortable_column_default: false, &block)
        @collection = collection
        @sortable_column_default = sortable_column_default
        @columns = []

        @table_options = {}
        @thead_options = {}
        @tbody_options = {}
        @tr_options = {}
        @th_options = {}

        @requested_columns = requested_columns
        yield self if block_given?
      end

      def td(name, method_name: nil, sort_key: nil, sortable: @sortable_column_default, header_options: {}, **options, &block)
        if method_name.nil?
          method_name = name.to_s.parameterize.underscore
          name = name.to_s.titleize unless block_given?
        end
        sort_key = method_name if sort_key.blank?
        @columns << self.class::Column.new(name, method_name, sort_key, block, sortable, options, header_options)
      end

      def define_header_sort_url(&block)
        define_singleton_method(:header_sort_url, &block)
      end

      def header_sort_url(column, query_params)
        # Override this method to define the sort url for the header.

        raise NotImplementedError, "You must define #header_sort_url if you want sortable table columns."
      end

      def footer(&block)
        @footer = block
      end

      def table(**options)
        @table_options = options
      end

      def tbody(**options)
        @tbody_options = options
      end

      def thead(**options)
        @thead_options = options
      end

      def tr(**options)
        @tr_options = options
      end

      def th(**options)
        @th_options = options
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
        content_tag(:table, @table_options) { render_header + render_body } + render_footer
      end

      def render_header
        content_tag(:thead, @thead_options) do
          content_tag(:tr, @tr_options) do
            visible_columns.map do |column|
              header_options = @th_options.merge(column.header_options)
              if column.sortable
                content_tag(:th, header_options) do
                  header_sort_url(column, query_params).html_safe
                end
              else
                content_tag(:th, column.name, header_options)
              end
            end.join.html_safe
          end
        end
      end

      def render_body
        content_tag(:tbody, @tbody_options) do
          @collection.map do |record|
            content_tag(:tr, @tr_options) do
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
        capture(&@footer) if @footer
      end

      def query_params
        request.query_parameters
      end
    end
  end
end
