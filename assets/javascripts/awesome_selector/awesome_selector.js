
var selection_cnt = 0;
jQuery(document).ready(function(){
  var text_filter = jQuery('#awesome_selector_list_filter');
  var list_wrapper = jQuery('ul#selection_list_wrapper');

  /*js for text_box clear btn*/
  jQuery("#filter_clear_btn").click(function(){
    reset_list_filter();
  });

  /*js for autocomplete*/
  var ac = text_filter.autocomplete({
    minChars:1,
    maxHeight:200,
    width:179,
    zIndex: 9999,
    deferRequestBy: 5, //miliseconds
    lookup: eval(text_filter.attr('autocomplete_array'))//local lookup values
  });
  //ac.disable();
  //ac.enable();


  /*js for word filter*/
  text_filter.jfilter({
    list: '#selection_list_wrapper',
    clear_btn: '#filter_clear_btn',
    speed: 100,
    highlight: 'highlight' // Class name with no "."
  });


  /*js for selecting item*/
  jQuery("ul#selection_list_wrapper li.selectable_element_details").each(function(){
    jQuery(this).click(function(){
      id = jQuery(this).attr('id');
      selection_limit = jQuery(this).attr('selection_limit');
      highlight_selected_div(id, selection_limit);
    });
  });


  /*js display list of all the items*/
  jQuery("#show_all").click(function(){
    jQuery(this).addClass('bold');
    jQuery('#show_selection').removeClass('bold');
    jQuery('#selection_cnt').removeClass('bold');
    list_wrapper.removeClass('selected_elements_list');
    reset_list_filter();
  });


  /*js display selected item list*/
  jQuery("#show_selection").click(function(){
    jQuery('#show_all').removeClass('bold');
    jQuery('#selection_cnt').addClass('bold');
    jQuery(this).addClass('bold');
    list_wrapper.children("li:not('.selected')").hide();
    list_wrapper.children("li.selected").show();
    list_wrapper.addClass('selected_elements_list');
    reset_list_filter();
  });

  /*js to collect selected ids*/
  jQuery("#awesome_selector_form").submit(function(){
    var ids = new Array;
    jQuery("ul#selection_list_wrapper li.selected").each(function(){
      ids.push(jQuery(this).attr('record_id'));
    });
    if(ids.length > 0)
    {
      jQuery('#selected_element_ids').val(ids.join());
      return true;
    }
    else
    {
      alert("Please select an item!");
      return false;
    }
  });
});


/*method to reset filter textbox and filter result*/
function reset_list_filter()
{
  jQuery("#awesome_selector_list_filter").val('');
  jQuery("#awesome_selector_list_filter").keyup();
}

/*method to display error message*/
function display_error(obj, msg)
{
  if(jQuery('#err_'+ obj).length == 0)
    jQuery('<div id="err_' + obj + '" >'+ msg +'</div>').appendTo(jQuery('#selectable_error_msg'));
}

/*method to selected or deselect list item*/
function highlight_selected_div(element_id, max_selection_limit)
{
  var element = jQuery('#'+ element_id);
  if(!(element.hasClass('selected')))
  {
    var selection_limit = eval(max_selection_limit);
    if ((selection_limit == "unlimited") || (parseInt(selection_cnt) < selection_limit[0]))
    {
      element.addClass('selected');
      selection_cnt += 1;
      jQuery('#selection_cnt').html("(" + selection_cnt + ")");
    }
    else
      alert(selection_limit[1] ? selection_limit[1] : "You can not select more");
  }
  else
  {
    selection_cnt -= 1;
    jQuery('#selection_cnt').html("(" + selection_cnt + ")");
    element.removeClass('selected');
    if(jQuery('ul#selection_list_wrapper').hasClass('selected_elements_list'))
    {
      element.hide();
    }
  }
}
