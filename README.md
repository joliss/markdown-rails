# markdown-rails

[![Dependency Status](https://gemnasium.com/joliss/markdown-rails.png)](https://gemnasium.com/joliss/markdown-rails)

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
matching route, such as `get ':action', :controller => :home`, to route
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

Note: If you are including Markdown partials from a Haml view, `<pre>` blocks
inside your Markdown may be indented when Haml is not in ["ugly" (production)
mode](http://haml-lang.com/docs/yardoc/file.HAML_REFERENCE.html#ugly-option),
causing leading white-space to appear in development mode. To fix this, set
`Haml::Template.options[:ugly] = true`.

## Configuration

By default markdown-rails uses the
[RDiscount](https://github.com/rtomayko/rdiscount) parser. You can change this
by calling `config.render` like so:

```ruby
MarkdownRails.configure do |config|
  config.render do |markdown_source|
    # Return compiled HTML here ...
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
MarkdownRails.configure do |config|
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
Markdown views from a source if you wouldn't trust Erb views from them.

## Limitations

*   It's not possible to embed Ruby code in the Markdown code. Unfortunately,
    you cannot simply chain template handlers (`.md.erb`) like you can with
    asset handlers. This is reasonable if you consider that unlike assets,
    templates are precompiled not into strings but into Ruby code, which is
    then called every time the template is served. Still, the performance of
    modern Markdown parsers is good enough that you could afford to reparse the
    Markdown on every template view, so having Markdown with Erb in it should
    be possible in principle.

    In the meantime, you can [use HAML's :markdown
    filter](http://stackoverflow.com/a/4418389/525872) to the same effect.

*   The only truly Markdown-specific code in the source is
    `RDiscount.new(markdown_source).to_html` and the `.md`/`.markdown` file
    name extensions. This gem can and should be generalized into a
    general-purpose static template gem, so that you can easily use other
    static templating languages in Rails. Perhaps
    [tilt](https://github.com/rtomayko/tilt) will come in useful.
