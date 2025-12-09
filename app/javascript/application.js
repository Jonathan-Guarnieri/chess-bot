// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

Turbo.StreamActions.add_css_class = function() {
  const classes = this.getAttribute("classes").split(" ")
  this.targetElements.forEach(el => el.classList.add(...classes))
}

Turbo.StreamActions.remove_css_class = function() {
  const classes = this.getAttribute("classes").split(" ")
  this.targetElements.forEach(el => el.classList.remove(...classes))
}
