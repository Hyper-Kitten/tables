# require "hyper_kitten_tables/concerns/table"
require 'hyper-kitten-tables'
require 'rails_helper'

RSpec.describe HyperKittenTables::Components::Table do
  User = Struct.new(:name)
  describe "rendering a table" do
    it "with defaults" do
      component = described_class.new(collection: []) do |table|
        table.td(:name, sortable: false)
      end

      render component

      assert_select "table" do
        assert_select "thead" do
          assert_select "tr" do
            assert_select "th", text: "Name"
          end
        end
        assert_select "tbody" do
          assert_select "tr", count: 0
        end
      end
    end

    it "with custom column options" do
      user = User.new("Hyper Kitten")
      component = described_class.new(collection: [user]) do |table|
        table.td(:name, sortable: false, class: "custom-class")
      end

      render component

      assert_select "table" do
        assert_select "tbody" do
          assert_select "tr" do
            assert_select "td.custom-class", text: "Hyper Kitten"
          end
        end
      end
    end

    it "with custom table options" do
      component = described_class.new(collection: []) do |table|
        table.td(:name, sortable: false)
        table.table(class: "custom-class")
      end

      render component

      assert_select "table.custom-class"
    end

    it "with custom tbody options" do
      component = described_class.new(collection: []) do |table|
        table.tbody(class: "custom-class")
        table.td(:name, sortable: false)
      end

      render component

      assert_select "table" do
        assert_select "tbody.custom-class"
      end
    end

    it "with custom thead options" do
      component = described_class.new(collection: []) do |table|
        table.thead(class: "custom-class")
        table.td(:name, sortable: false)
      end

      render component

      assert_select "table" do
        assert_select "thead.custom-class"
      end
    end

    it "with custom tr options" do
      component = described_class.new(collection: []) do |table|
        table.tr(class: "custom-class")
        table.td(:name, sortable: false)
      end

      render component

      assert_select "table" do
        assert_select "thead" do
          assert_select "tr.custom-class"
        end
      end
    end

    it "with custom th options" do
      component = described_class.new(collection: []) do |table|
        table.th(class: "custom-class")
        table.td(:name, sortable: false)
      end

      render component

      assert_select "table" do
        assert_select "thead" do
          assert_select "tr" do
            assert_select "th.custom-class"
          end
        end
      end
    end

    it "rendered only the specified columns when requested" do
      component = described_class.new(collection: [], requested_columns: ["Name"]) do |table|
        table.td(:name, sortable: false)
        table.td(:email, sortable: false)
      end

      html = render component

      assert_select "table" do
        assert_select "thead" do
          assert_select "tr" do
            assert_select "th", text: "Name"
            assert_select "th", text: "Email", count: 0
          end
        end
        assert_select "tbody" do
          assert_select "tr", count: 0
        end
      end
    end

    it "with sortable columns" do
      component = described_class.new(collection: []) do |table|
        table.define_header_sort_url do |column, params|
          link_direction = case params
          when { column.sort_key => "asc" }
            "desc"
          when { column.sort_key => "" }
            "desc"
          else
            "asc"
          end
          "<a href='/?order[#{column.sort_key}]=#{link_direction}'>#{column.name}</a>"
        end
        table.td(:name, sortable: true)
        table.td(:age, sortable: true)
      end

      render component, params: { "name" => "asc" }

      assert_select "table" do
        assert_select "thead" do
          assert_select "tr" do
            assert_select "th" do
              assert_select "a", text: "Name" do
                assert_select "[href=?]", "/?order[name]=desc"
              end
              assert_select "a", text: "Age" do
                assert_select "[href=?]", "/?order[age]=asc"
              end
            end
          end
        end
        assert_select "tbody" do
          assert_select "tr", count: 0
        end
      end
    end

    it "with a footer " do
      component = described_class.new(collection: []) do |table|
        table.td(:name, sortable: false)
        table.footer do
          "Footer"
        end
      end

      html = render component

      assert_select "div", text: "Footer"
    end

    def render(component, params: {})
      request = Struct.new(:query_parameters).new(params)

      view = Class.new(ActionView::Base.with_empty_template_cache) do
        attr_accessor :request
        def view_cache_dependencies; []; end
        # def params; parameters; end

        def combined_fragment_cache_key(key)
          [ :views, key ]
        end
      end.with_view_paths([])

      view.request = request

      html = view.render component

      @html_document = Nokogiri::HTML::Document.parse(html)
    end

    def document_root_element
      @html_document.root
    end
  end
end
