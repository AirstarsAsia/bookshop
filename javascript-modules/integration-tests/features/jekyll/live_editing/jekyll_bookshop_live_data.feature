@jekyll @web
Feature: Jekyll Bookshop CloudCannon Live Editing Site Data

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
    Given a site/cloudcannon.config.yml file containing:
      """
      data_config: true
      """
    * [front_matter]:
      """
      layout: default
      show: false
      """
    * a site/index.html file containing:
      """
      ---
      [front_matter]
      ---
      {% bookshop block show=page.show %}
      """

  Scenario: Bookshop live renders website data
    Given a site/_data/cat.yml file containing:
      """
      name: Cheeka
      """
    * a component-lib/components/block/block.jekyll.html file containing:
      """
      <h1>{% if include.show %}{{ site.data.cat.name }}{% endif %}</h1>
      """
    * 🌐 I have loaded my site in CloudCannon
    When 🌐 CloudCannon pushes new yaml:
      """
      show: true
      """
    Then 🌐 There should be no errors
    *    🌐 There should be no logs
    *    🌐 The selector h1 should contain "Cheeka"

  Scenario: Bookshop live renders special website config
    Given a site/_config.yml file containing:
      """
      title: "My Site"
      baseurl: "/documentation"

      bookshop_locations:
        - ../component-lib

      plugins:
        - jekyll-bookshop
      """
    Given a component-lib/components/block/block.jekyll.html file containing:
      """
      {% if include.show %}
      <h1>{{ site.baseurl }}</h1>
      <h2>{{ "/home" | relative_url }}</h2>
      <h3>{{ site.title }}</h3>
      {% endif %}
      """
    * 🌐 I have loaded my site in CloudCannon
    When 🌐 CloudCannon pushes new yaml:
      """
      show: true
      """
    Then 🌐 There should be no errors
    *    🌐 There should be no logs
    *    🌐 The selector h1 should contain "/documentation"
    *    🌐 The selector h2 should contain "/documentation/home"
    *    🌐 The selector h3 should contain "My Site"

  Scenario: Bookshop live renders collections
    Given a site/_config.yml file containing:
      """
      bookshop_locations:
        - ../component-lib

      plugins:
        - jekyll-bookshop
      
      collections:
        - cats
      """
    Given a site/_cats/cheeka.md file containing:
      """
      ---
      name: Cheeka
      status: cute
      ---
      """
    Given a site/_cats/crumpet.md file containing:
      """
      ---
      name: Crumpet
      status: adorable
      ---
      """
    Given a component-lib/components/block/block.jekyll.html file containing:
      """
      <ul>{% if include.show %}{% for cat in site.cats %}{% bookshop cat bind=cat %}{% endfor %}{% endif %}</ul>
      """
    Given a component-lib/components/cat/cat.jekyll.html file containing:
      """
      <li>{{ cat.name }} ({{ cat.status }})</li>
      """
    * 🌐 I have loaded my site in CloudCannon
    When 🌐 CloudCannon pushes new yaml:
      """
      show: true
      """
    Then 🌐 There should be no errors
    *    🌐 There should be no logs
    *    🌐 The selector li:nth-of-type(1) should contain "Cheeka (cute)"
    *    🌐 The selector li:nth-of-type(2) should contain "Crumpet (adorable)"

  Scenario: Bookshop live renders a warning when using content
    Given a site/_config.yml file containing:
      """
      bookshop_locations:
        - ../component-lib

      plugins:
        - jekyll-bookshop
      
      collections:
        - cats
      """
    Given a site/_cats/cheeka.md file containing:
      """
      ---
      name: Cheeka
      status: cute
      ---
      # Meow
      """
    Given a component-lib/components/block/block.jekyll.html file containing:
      """
      <ul>{% if include.show %}{% for cat in site.cats %}{% bookshop cat bind=cat %}{% endfor %}{% endif %}</ul>
      """
    Given a component-lib/components/cat/cat.jekyll.html file containing:
      """
      <li>{{ cat.name }} ({{ cat.content }})</li>
      """
    * 🌐 I have loaded my site in CloudCannon
    When 🌐 CloudCannon pushes new yaml:
      """
      show: true
      """
    Then 🌐 There should be no errors
    *    🌐 There should be no logs
    *    🌐 The selector li:nth-of-type(1) should contain "Cheeka (Content is not available when live editing)"
