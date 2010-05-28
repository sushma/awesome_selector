require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
include SelectableHelper

def get_image_url
  "../../assets/images/awesome_selector/no-image.png"
end

def create_object
  obj_arr = []
  5.times do |i|
    obj_arr[i] = "user#{i+1}"
    obj_arr[i].stub!(:id).and_return(i+1)
    obj_arr[i].stub!(:name).and_return("template#{i+1}")
    obj_arr[i].stub!(:color).and_return("color#{i+1}")
    obj_arr[i].stub!(:image_url).and_return(get_image_url)
  end
  obj_arr
end

def create_hash_with_mandetory_params
  {:objects => create_object, :field_names => ["name","color"], :form_post_url => "/"}
end



###### specs to test error messages for mandatory parameters #####

describe "Should display errors if mandatory parameters are not passed " do

  it "should display error if object is not passed" do
    response_text = awesome_selector :field_names => ["name","color"]
    response_text.should have_tag('font', /Please provide an array of objects for 'objects' parameter./)
  end

  it "should display error if blank object is passed" do
    response_text = awesome_selector :field_names => ["name","color"], :object =>  []
    response_text.should have_tag('font', /Please provide an array of objects for 'objects' parameter./)
  end

  it "should display error if field_names are not passed" do
    response_text =awesome_selector :objects => create_object
    response_text.should have_tag('font', /Please provide atleast one field as 'field_names' parameter for the list to be displayed./)
  end

  it "should display error if form post url is not passed" do
    response_text = awesome_selector :objects => create_object, :field_names => ["name","color"]
    response_text.should have_tag('font', /Please provide post url as 'form_post_url' parameter to post the form after selection./)
  end

end

describe "Should not display errors if mandatory parameters are passed" do

  it "should not display error if object is passed" do
    response_text = awesome_selector :objects => create_object
    response_text.should_not have_tag('font', /Please provide an array of objects for 'objects' parameter./)
  end

  it "should not display error if field_names are passed" do
    response_text =awesome_selector :objects => create_object, :field_names => ["name","color"]
    response_text.should_not have_tag('font', /Please provide atleast one field as 'field_names' parameter for the list to be displayed./)
  end

  it "should not display error if form post url is passed" do
    response_text = awesome_selector create_hash_with_mandetory_params
    response_text.should_not have_tag('font', /Please provide post url as 'form_post_url' parameter to post the form after selection./)
    response_text.should have_tag('div#awesome_selector', :count => 1)
  end

end

###### specs to test error messages for the format of optional parameters #####

describe "Should display errors if optional parameters are passed in wrong format" do
  
  it "should display error if selected_objects passed as parameter is not an array" do
    selected_objects = {:selected_objects => ''}
    response_text = awesome_selector create_hash_with_mandetory_params.merge(selected_objects)
    response_text.should have_tag('font', /Please provide an array of selected objects for 'selected_objects' parameter./)
  end
  
  it "should display error if field_names passed as parameter is not an array" do
    response_text =awesome_selector :objects => create_object, :field_names => "name"
    response_text.should have_tag('font', /Please provide an array of field names for 'field_names' parameter./)
  end
  
  it "should display error if max_selection_limit passed as parameter is not an array" do
    parameter_hash = {:selected_objects => [], :max_selection_limit => ''}
    response_text = awesome_selector create_hash_with_mandetory_params.merge(parameter_hash)
    response_text.should have_tag('font', "Please provide an array of 'integer value as maximum selection limit' and a 'string as error message' for 'max_selection_limit' parameter. eg :max_selection_limit => [5, 'Sorry, you can not select more users.']")
  end
  
end

describe "Should not display errors if optional parameters are passed in right format" do

  it "should not display error if selected_objects passed as parameter is an array" do
    selected_objects = {:selected_objects => []}
    response_text = awesome_selector create_hash_with_mandetory_params.merge(selected_objects)
    response_text.should_not have_tag('font', /Please provide an array of selected objects for 'selected_objects' parameter./)
  end

  it "should not display error if field_names passed as parameter is an array" do
    response_text =awesome_selector :objects => create_object, :field_names => ["name"]
    response_text.should_not have_tag('font', /Please provide an array of field names for 'field_names' parameter./)
  end

  it "should not display error if max_selection_limit passed as parameter is an array" do
    parameter_hash = {:selected_objects => [], :max_selection_limit => [1]}
    response_text = awesome_selector create_hash_with_mandetory_params.merge(parameter_hash)
    response_text.should_not have_tag('font', "Please provide an array of 'integer value as maximum selection limit' and a 'string as error message' for 'max_selection_limit' parameter. eg :max_selection_limit => [5, 'Sorry, you can not select more users.']")
  end

end


################ specs for form elements ####################

describe "Should create form elements based on parameters " do

  it "should apply 'template_1' as default" do
    awesome_selector create_hash_with_mandetory_params
    response.should have_tag('div#awesome_selector.awesome_selector_template_1', :count => 1)
  end

  it "should apply template if template is provided" do
    awesome_selector create_hash_with_mandetory_params.merge(:template => 'template_2')
    response.should_not have_tag('div#awesome_selector.awesome_selector_template_1')
    response.should have_tag('div#awesome_selector.awesome_selector_template_2', :count => 1)
  end

  it "Should create filter textbox and link to clear text" do
    awesome_selector create_hash_with_mandetory_params
    response.should have_tag('input#awesome_selector_list_filter[type=text]', :count => 1)
    response.should have_tag("a#filter_clear_btn", :count => 1)
  end

  it "should create links 'all' and 'selected'" do
    awesome_selector create_hash_with_mandetory_params
    response.should have_tag("#header p#show_all.bold", :count => 1)
    response.should have_tag("#header p#show_selection", :count => 1)
  end

  it "should create form with form_post_url as action" do
    awesome_selector create_hash_with_mandetory_params
    response.should have_tag("form[action='/selectable/selector?url=%2F'][method=post]")
  end

  it "should create form with list element divs" do
    awesome_selector create_hash_with_mandetory_params
    response.should have_tag('div#awesome_selector_main form ul#selection_list_wrapper', :count => 1)
    response.should have_tag('ul#selection_list_wrapper li.selectable_element_details', :count => 5)
  end

  it "should show value of all the field names provided as parameter for each list element" do
    awesome_selector create_hash_with_mandetory_params
    5.times do |i|
      cnt = i+1
      template = "template" + cnt.to_s
      color = "color" + cnt.to_s
      response.should have_tag("ul li#selectable_element_div_#{cnt} p#details", /template/, :count => 1)
      response.should have_tag("ul li#selectable_element_div_#{cnt} p#details br", :count => 2)
      response.should have_tag("ul li#selectable_element_div_#{cnt} p#details", /color/, :count => 1)
    end
  end

  it "should not show the fields value, if not provided as parameter" do
    awesome_selector :objects => create_object, :field_names => ["name"], :form_post_url => 'awesome_selector_path'
    5.times do |i|
      response.should have_tag("ul li#selectable_element_div_#{i+1} p#details", /template/, :count => 1)
      response.should have_tag("ul li#selectable_element_div_#{i+1} p#details br", :count => 1)
    end
  end

  it "should show image if image_url is provided" do
    awesome_selector create_hash_with_mandetory_params.merge(:image_url => "image_url")
    5.times do |i|
      response.should have_tag("ul li#selectable_element_div_#{i+1} img[src='#{get_image_url}']", :count => 1)
    end
  end

  it "should not show image if image_url is not provided" do
    awesome_selector create_hash_with_mandetory_params
    5.times do |i|
      response.should_not have_tag("li#selectable_element_div_#{i+1} img[src='#{get_image_url}']")
    end
  end

  it "should create hidden textfield and submit button" do
    awesome_selector create_hash_with_mandetory_params
    response.should have_tag("input#selected_element_ids[type='hidden']", :count => 1)
    response.should have_tag("input[type='submit']", :count => 1)
  end

end




