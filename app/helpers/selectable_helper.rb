module SelectableHelper

  URL_ERROR_MESSAGE = "<font color='red'>Please provide post url as 'form_post_url' parameter to post the form after selection.</font>"
  FIELD_ERROR_MESSAGE = "<font color='red'>Please provide atleast one field as 'field_names' parameter for the list to be displayed.</font>"
  FIELD_ARRAY_ERROR_MESSAGE = "<font color='red'>Please provide an array of field names for 'field_names' parameter.</font>"
  OBJECT_ARRAY_ERROR_MESSAGE = "<font color='red'>Please provide an array of objects for 'objects' parameter.</font>"
  SELECTED_ARRAY_ERROR_MESSAGE = "<font color='red'>Please provide an array of selected objects for 'selected_objects' parameter.</font>"
  SELECTION_LIMIT_ERROR_MESSAGE = "<font color='red'>Please provide an array of 'integer value as maximum selection limit' and a 'string as error message' for 'max_selection_limit' parameter. eg :max_selection_limit => [5, 'Sorry, you can not select more users.']</font>"

  def awesome_selector(options = {})
    return OBJECT_ARRAY_ERROR_MESSAGE if (options[:objects].blank? || options[:objects].class.to_s != "Array")
    return FIELD_ERROR_MESSAGE if options[:field_names].blank?
    return FIELD_ARRAY_ERROR_MESSAGE if (options[:field_names].present? && options[:field_names].class.to_s != "Array")
    return URL_ERROR_MESSAGE if options[:form_post_url].blank?
    return SELECTED_ARRAY_ERROR_MESSAGE if (options[:selected_objects] && options[:selected_objects].class.to_s != "Array")
    return SELECTION_LIMIT_ERROR_MESSAGE if (options[:max_selection_limit] && options[:max_selection_limit].class.to_s != "Array")
    render :partial    => '/selectable/selector', :locals => options_hash(options)
  end

  def options_hash(options)
    {
      :template              =>  options[:template] ||= "template_1",
      :field_names           =>  options[:field_names].collect(&:strip),
      :image_url             =>  options[:image_url] ||= "",
      :objects               =>  options[:objects],
      :selected_objects      =>  options[:selected_objects].present? ? options[:selected_objects].collect{|obj| obj.id} : [],
      :auto_complete         =>  options[:auto_complete_field_name] ? options[:objects].collect{|obj| eval("obj.#{options[:auto_complete_field_name]}")} : [],
      :form_post_url         =>  options[:form_post_url],
      :max_selection_limit   =>  options[:max_selection_limit] ||= 'unlimited'
    }
  end

end
