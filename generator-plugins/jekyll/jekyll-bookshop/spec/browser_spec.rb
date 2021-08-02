# frozen_string_literal: true

require_relative "./helpers/test_helpers"

module JekyllBookshop
  describe Tag do
    RENDERER_SETUP = begin
      @site = TestHelpers.setup_site({})
    end

    it "should render the bookshop browser element" do
      output_file = TestHelpers.read_output_file("index.html")

      target = "<div data-bookshop-browser></div>"
      expect(output_file).must_match %r!#{Regexp.quote(target)}!
    end

    it "should render the bookshop browser dependencies" do
      output_file = TestHelpers.read_output_file("index.html")

      target = "<script src=\"//localhost:1234/bookshop.js\"></script>"
      expect(output_file).must_match %r!#{Regexp.quote(target)}!
    end

    it "should render the bookshop data script" do
      output_file = TestHelpers.read_output_file("index.html")

      target = "window.bookshop_browser_site_data"
      expect(output_file).must_match %r!#{Regexp.quote(target)}!
    end

    it "should have hydrated the bookshop data script" do
      output_file = TestHelpers.read_output_file("index.html")

      target = "<script>window.bookshop_browser_site_data = null;</script>"
      expect(output_file).wont_match %r!#{Regexp.quote(target)}!
    end

    it "should render the initialization snippet" do
      output_file = TestHelpers.read_output_file("index.html")

      target = "<script>window.BookshopBrowser = new window.BookshopBrowserClass(); window.BookshopBrowser.render();</script>"
      expect(output_file).must_match %r!#{Regexp.quote(target)}!
    end

    make_my_diffs_pretty!
  end
end