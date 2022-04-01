@jekyll
Feature: Jekyll Bookshop Component Browser Granular Steps

  Background:
    Given the file tree:
      """
      package.json from starters/generate/package.json # <-- this .json line hurts my syntax highlighting
      component-lib/
        bookshop/
          bookshop.config.js from starters/jekyll/bookshop.config.js
      site/
        _config.yml from starters/jekyll/_config.yml
        Gemfile from starters/jekyll/Gemfile.cloudcannon
        Gemfile.lock from starters/jekyll/Gemfile.cloudcannon.lock
        _layouts/
          default.html from starters/jekyll/default.html
      """
    * a component-lib/components/single/single.bookshop.toml file containing:
      """
      [spec]
      structures = [ "content_blocks" ]
      label = "Single"
      description = "Single component"
      icon = "nature_people"
      tags = ["Basic"]

      [blueprint]
      title = "Hello There, World"
      """
    * a component-lib/components/single/single.jekyll.html file containing:
      """
      <h1>{{ include.title }}</h1>
      """
    * a site/index.html file containing:
      """
      ---
      ---
      {% bookshop_component_browser %}
      """

  Scenario: Bookshop adds component browser markup
    When I run "bundle exec jekyll build --trace" in the site directory
    Then stderr should be empty
    *    stdout should contain "done in"
    *    site/_site/index.html should contain each row: 
      | text |
      | <div data-bookshop-browser=""></div> |
      | <script src="http://localhost:30775/bookshop.js"></script> |

  Scenario: Bookshop Generate hydrates component browser
    Given I run "bundle exec jekyll build --trace" in the site directory
    When I run "npm start" in the . directory
    Then stderr should be empty
    *    stdout should contain "Modifying output site at ./site/_site"
    *    stdout should contain "Built component browser into 1 page"
    *    site/_site/index.html should contain each row: 
      | text |
      | <script src="/_bookshop/bookshop-browser.min.js?cb=  |

  @web
  Scenario: Bookshop component browser initialises
    When 🌐 I load my site
    And 🌐 "window.bookshopBrowser?.hasRendered === true" evaluates
    Then 🌐 There should be no errors
    *    🌐 There should be no logs
    *    🌐 The selector .tutorial should contain "Select a component using the"

  @web
  Scenario: Bookshop component browser renders a component
    When 🌐 I load my site
    And 🌐 "typeof window.BookshopBrowser !== 'undefined'" evaluates
    And 🌐 "window.bookshopBrowser?.hasRendered === true" evaluates
    And 🌐 I trigger a mousedown on li:nth-of-type(2)>button
    And 🌐 "window.bookshopComponentHasRendered === true" evaluates
    Then 🌐 There should be no errors
    *    🌐 There should be no logs
    *    🌐 The selector h1 should contain "Hello There, World"
