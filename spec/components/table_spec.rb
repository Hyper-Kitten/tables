# require "hyper_kitten_tables/concerns/table"
require 'hyper-kitten-tables'
require 'rails_helper'

RSpec.describe HyperKittenTables::Components::Table do
  User = Struct.new(:name)
  describe "rendering a table" do
    it "with defaults" do
      component = described_class.new(collection: []) do |table|
        table.column(:name, sortable: false)
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
        table.column(:name, sortable: false, class: "custom-class")
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

    it "rendered only the specified columns when requested" do
      component = described_class.new(collection: [], requested_columns: ["Name"]) do |table|
        table.column(:name, sortable: false)
        table.column(:email, sortable: false)
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
        table.header_sort_url do |column, params|
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
        table.column(:name, sortable: true)
        table.column(:age, sortable: true)
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
        table.column(:name, sortable: false)
        table.footer do
          "Footer"
        end
      end

      html = render component

      assert_select "div", text: "Footer"
    end

    def render(component, params: {})
      assigns = { secret: "in the sauce" }

      view = Class.new(ActionView::Base.with_empty_template_cache) do
        attr_accessor :params
        def view_cache_dependencies; []; end
        # def params; parameters; end

        def combined_fragment_cache_key(key)
          [ :views, key ]
        end
      end.with_view_paths([], assigns)

      view.params =  params

      html = view.render component

      @html_document = Nokogiri::HTML::Document.parse(html)
    end

    def document_root_element
      @html_document.root
    end
  end
end
