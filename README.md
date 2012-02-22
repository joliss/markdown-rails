# markdown-rails

This gem allows you to write static Rails views and partials using the
[Markdown](http://daringfireball.net/projects/markdown/syntax) syntax. No more
editing prose in HTML!

## Usage

Add the following to your Gemfile:

```ruby
gem 'markdown-rails'
```

Now add views or partials ending in `.md` or `.markdown`.

## Examples

### Static View

In `app/views/home/about.html.md`:

```markdown
# About This Site

*Markdown code goes here ...*
```

Keep in mind that unlike static files dropped in `public`, you still need a
matching route, such as `get ':action', :controller => :home` to route
`/about` to `home#about`.

### Static Partial

In `app/views/posts/edit.html.erb`:

```erb
<form>... dynamic code goes here ...</form>
<div class="help">
  <%= render :partial => "posts/edit_help" %>
</div>
```

In `app/views/posts/_edit_help.html.md`:

```markdown
## How To Edit

This text is written in **Markdown**. :-)
```

## Configuration

By default markdown-rails uses the
[RDiscount](https://github.com/rtomayko/rdiscount) parser. You can change this
by calling `config.render` like so:

```ruby
Markdown::Rails.configure do |config|
  config.render do |markdown_source|
    ... return compiled HTML here ...
  end
end
```

You might in particular want to use
[Redcarpet](https://github.com/tanoku/redcarpet), which allows you to enable
various aspects of [GitHub Flavored
Markdown](http://github.github.com/github-flavored-markdown/) through its
parser options. To do so, add the `redcarpet` gem to your Gemfile, and add the
following into a `config/initializers/markdown.rb` file:

```ruby
Markdown::Rails.configure do |config|
  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
    :fenced_code_blocks => true,
    :autolink => true,
    ... etc ...)
  config.render do |markdown_source|
    markdown.render(markdown_source)
  end
end
```

## Security

Despite Markdown being a static language, you should not use this gem to
process untrusted Markdown views (or partials). In other words, do not add
Markdown views from any source if you wouldn't trust Erb views from them.

## To-Do

* The only truly Markdown-specific code in the source is
  `RDiscount.new(markdown_source).to_html` and the Markdown file name
  extensions. This gem can and should be generalized into a general-purpose
  static template gem, so that you can easily use other static templating
  languages in Rails. Perhaps [tilt](https://github.com/rtomayko/tilt) will
  come in useful.

## Limitations

* This gem uses the fabulous [Redcarpet](https://github.com/tanoku/redcarpet)
  library, but does not yet support setting any of its options to enable parts
  of [GitHub-flavored
  Markdown](http://github.github.com/github-flavored-markdown/), such as
  `:fenced_code_blocks`.
