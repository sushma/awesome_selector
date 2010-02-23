module SelectableHelper

  URL_ERROR_MESSAGE = "<font color='red'>Please provide post url as 'form_post_url' parameter to post the form after selection. </font>"
  FIELD_ERROR_MESSAGE = "<font color='red'>Please provide atleast one field as 'field_names' parameter for the list to be displayed. </font>"
  ARRAY_ERROR_MESSAGE = "<font color='red'>Please provide array of objects.</font>"

  def awesome_selector(options = {})
    return ARRAY_ERROR_MESSAGE if (options[:objects].blank? || options[:objects].class.to_s != "Array")
    return FIELD_ERROR_MESSAGE if options[:field_names].blank?
    return URL_ERROR_MESSAGE if options[:form_post_url].blank?
    render :partial    => '/selectable/selector', :locals => options_hash(options)
  end

  def options_hash(options)
    {
      :template              =>  options[:template] ||= "template_1",
      :field_names           =>  options[:field_names].collect(&:strip),
      :image_url             =>  options[:image_url] ||= "",
      :objects                =>  options[:objects],
      :auto_complete         =>  options[:auto_complete_field_name] ? options[:objects].collect{|obj| eval("obj.#{options[:auto_complete_field_name]}")} : [],
      :form_post_url         =>  options[:form_post_url],
      :max_selection_limit   =>  options[:max_selection_limit] ||= 'unlimited'
    }
  end

end
