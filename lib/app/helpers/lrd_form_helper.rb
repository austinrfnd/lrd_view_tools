
module LRD
  module FormHelper


    # Returns a <div> containing a label, an input, and an option comment
    # block, pre-styled in LRD style.
    #
    # pass  :label => false  to suppress the label text.  (A label tag is still emitted.)
    # pass  :required => true  to dispay as a required field (class required set on both the div and the input)
    # pass  :text => "foo"  to override the label text
    # pass  :divclass => 'foo' to add 'foo' to the CSS class of the <div>
    # pass  :comment => "text"  to append a span.comment with text after the input
    # pass  :type => 'password' } to use a password_field instead of a text_field
    #    (also supported: text, passsword, hidden, file, text_area, search, telephone, url
    #     email, range, submit)
    #
    # ==== Examples (in HAML):
    #   - form_for(@user) do
    #     = f.labeled_input(:login)
    #   # => <div class='labeled_input'>
    #   # =>   <label for='user_login'>login</label>
    #   # =>   <input type='text' name='user[login]' id='user_login' value="#{@user.login}" />
    #   # => </div>
    def labeled_input(object_name, method, options = {}, &block)
      divclass = options.delete(:divclass)
      div_final_class = labeled_input_div_class(options, divclass)
      comment = comment_for_labeled_input(options.delete(:comment))
      label_text = options.delete(:text)
      if block_given?
        input = capture(&block)
      else
        input = input_for_labeled_input(object_name, method, options)
      end

      if object_name.blank? or method.blank?
        label = "<label>&nbsp;</label>".html_safe
      elsif label_text =
        label = label(object_name, method, label_text, options)
      else
        label = label(object_name, method, options)
      end
      content_tag(:div, (label + input + comment), { :class => div_final_class })
    end

    def comment_for_labeled_input(text)
      if text
        content_tag( :span, { :class => 'comment' } ) { text }
      else
        ""
      end
    end


    def labeled_input_div_class(options, divclass = nil)
      cssclass = "labeled_input"
      cssclass += " required" if options[:required]
      cssclass += " #{divclass}" if divclass
      cssclass
    end

    def input_for_labeled_input(object_name, method, options)
      if required = options.delete(:required)
        options[:class] = (options[:class] or '') + " required"
      end
      submit_text = options.delete(:submit_text)

      case input_type = options.delete(:type).to_s
      when "text", ""
        input = text_field(     object_name, method, options)
      when "password"
        input = password_field( object_name, method, options)
      when "hidden"
        input = hidden_field(   object_name, method, options)
      when "file"
        input = file_field(     object_name, method, options)
      when "text_area", "textarea"
        input = text_area(      object_name, method, options)
      when "search"
        input = search_field(   object_name, method, options)
      when "telephone", 'tel'
        input = telephone_field(object_name, method, options)
      when "url"
        input = url_field(      object_name, method, options)
      when "email"
        input = email_field(    object_name, method, options)
      when "number"
        input = number_field(   object_name, method, options)
      when "range"
        input = range_field(    object_name, method, options)
      when "submit"
        input = submit_tag(     submit_text, options)
      else
        raise "labeled_input input_type #{input_type} is not a valid type!"
      end
      input
    end

    # Shortcut for a version of labeled_input that suppresses the
    # label text.   Just calls labeled_input with :label => false.
    def unlabeled_input(object_name, method, options)
      labeled_input(object_name, method, options.merge!(:label => false))
    end

    # creates a submit button that lines up with a bunch of labeled_input fields
    # Pass a single argument to override the default text of the submit button.
    #
    # ==== Examples (in HAML):
    #   - form_for(@user) do
    #     = f.unlabeled_submit("Click Me")
    #   # => <div class='labeled_input'>
    #   # =>   <label> </label>
    #   # =>   <input type='submit' name='[]' value='Click Me' />
    #   # => </div>
    def unlabeled_submit(text = nil, options={})
      labeled_input(nil, nil, options.merge!({:type => :submit, :submit_text => text}))
    end
  end
end

  # # pass { :nolabel => true } to replace the label with a spacer
  #   # pass { :required => true } to dispay as a required field
  #   # pass { :text => "foo" } to override the label text
  #   # pass { :class => 'foo'} to add 'foo' to the CSS class of the <div>
  #   #
  #   # input_options hash gets passed directly to the input field
  #   def labeled_input(form, field, options = {}, input_options = {})
  #     options[:text] = "&nbsp;".html_safe if options[:nolabel]
  #     options.reverse_merge!(:text => nil,:required => false, :nolabel => false)
  #     options.merge!(:form => form, :field => field)
  #     input_options.reverse_merge!( :size => 30 )
  #
  #     cssclass = "labeled_input"
  #     cssclass += " required" if options[:required]
  #     cssclass += " #{options[:class]}" if options[:class]
  #
  #     unless input = options[:input]
  #       input = form.text_field field, input_options
  #     end
  #
  #     if field.blank?
  #       label = (content_tag :label, options[:text]).html_safe
  #     else
  #       label = (form.label field, options[:text]).html_safe
  #     end
  #     comment = options[:comment] ? content_tag( :span, { :class => 'comment' } ) { options[:comment] }  : ""
  #
  #     content_tag(:div, (label + input + comment), { :class => cssclass }).html_safe
  #   end
# f.labeled_input(stuff, :input_type => :hidden)
#
# f.labeled_input(stuff){ f.hidden_field(stuff) }
#

module LRD::FormBuilder
  def labeled_input(method, options = {}, &block)
    @template.labeled_input(@object_name, method, objectify_options(options), &block)
  end
  def unlabeled_submit(text = nil, options={})
    @template.unlabeled_submit(text, options)
  end
end


