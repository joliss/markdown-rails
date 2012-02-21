This gem enables static
[Markdown](http://daringfireball.net/projects/markdown/syntax) views and
partials in Rails.

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

## Limitations

* This gem uses the fabulous [Redcarpet](https://github.com/tanoku/redcarpet)
  library, but does not yet support setting any of its options to enable parts
  of [GitHub-flavored
  Markdown](http://github.github.com/github-flavored-markdown/), such as
  `:fenced_code_blocks`.
