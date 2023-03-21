require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require 'byebug'
require 'active_support/inflector'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
  end

  # Helper method to alias @already_built_response
  # Check that content is not rendered twice
  def already_built_response?
    @already_built_response 
  end

  # Set the response status code and header
  def redirect_to(url)
    if already_built_response?
      raise "error"
    else
      res.status = 302
      res.location = url
      @already_built_response = true
    end
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    
    if already_built_response?
      raise "error"
    else
      res.content_type=(content_type)
      res.write(content)
      @already_built_response = true
    end
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    path =  File.dirname(__FILE__)
    
    formatted_dirs = File.join(path)
    debugger
    controller_name = self.to_s.underscore
    File.read("views/#{controller_name}/#{template_name}.html.erb")
    # debugger
    rendered_html = ERB.new() #render template using ERB
    render_content(rendered_html, 'text/html')
    @already_built_response = true
  end

  # method exposing a `Session` object
  def session
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end

