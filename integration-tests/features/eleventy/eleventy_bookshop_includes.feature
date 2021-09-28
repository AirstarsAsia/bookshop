Feature: Eleventy Bookshop Includes
  As a user of Eleventy with Bookshop
  I want includes scoped to the bookshop
  So that I can use them on the site or in components

  Background:
    Given the file tree:
      """
      component-lib/
        bookshop/
          bookshop.config.js from starters/eleventy/bookshop.config.js
      site/
        .eleventy.js from starters/eleventy/.eleventy.js
        .eleventyignore from starters/eleventy/.eleventyignore
        package.json from starters/eleventy/package.json # <-- this .json line hurts my syntax highlighting
      """

  Scenario: Basic Bookshop Include
    Given a component-lib/shared/eleventy/basic.eleventy.liquid file containing:
      """
      {{label}}🎉
      """
    Given a component-lib/components/block/block.eleventy.liquid file containing:
      """
      <div>Block—{% bookshop_include "basic" label: title %}</div>
      """
    And a site/index.html file containing:
      """
      ---
      ---
      {% bookshop "block" title: "Component" %}
      <span>Inline—{% bookshop_include "basic" label: "Site" %}</span>
      """
    When I run "yarn install && yarn start" in the site directory
    Then stderr should be empty
    And stdout should contain "v0.12.1"
    And site/_site/index.html should contain the text "Block—Component🎉"
    And site/_site/index.html should contain the text "Inline—Site🎉"
