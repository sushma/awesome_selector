
var as_selection_cnt = 0;
jQuery(document).ready(function(){
  var text_filter = jQuery('#as_awesome_selector_list_filter');
  var list_wrapper = jQuery('ul#as_selection_list_wrapper');

  /*js for text_box clear btn*/
  jQuery("#as_filter_clear_btn").click(function(){
    as_reset_list_filter();
  });

  /*js for autocomplete*/
  var ac = text_filter.autocomplete({
    minChars:1,
    maxHeight:200,
    //width:179,
    zIndex: 9999,
    deferRequestBy: 5, //miliseconds
    lookup: eval(text_filter.attr('autocomplete_array'))//local lookup values
  });
  //ac.disable();
  //ac.enable();


  /*js for word filter*/
  text_filter.jfilter({
    list: '#as_selection_list_wrapper',
    clear_btn: '#as_filter_clear_btn',
    speed: 100,
    highlight: 'highlight' // Class name with no "."
  });


  /*js for selecting item*/
  jQuery("ul#as_selection_list_wrapper li.as_selectable_element_details").each(function(){
    jQuery(this).click(function(){
      obj = jQuery(this);
      selection_limit = jQuery(this).attr('selection_limit');
      as_highlight_selected_div(obj, selection_limit);
    });
  });


  /*js display list of all the items*/
  jQuery("#as_show_all").click(function(){
    jQuery(this).addClass('as_bold');
    jQuery('#as_show_selection').removeClass('as_bold');
    jQuery('#as_selection_cnt').removeClass('as_bold');
    list_wrapper.removeClass('as_selected_elements_list');
    as_reset_list_filter();
  });


  /*js display selected item list*/
  jQuery("#as_show_selection").click(function(){
    jQuery('#as_show_all').removeClass('as_bold');
    jQuery('#as_selection_cnt').addClass('as_bold');
    jQuery(this).addClass('as_bold');
    list_wrapper.children("li:not('.as_selected')").hide();
    list_wrapper.children("li.as_selected").show();
    list_wrapper.addClass('as_selected_elements_list');
    as_reset_list_filter();
  });

  /*js to collect selected ids*/
  jQuery("#as_awesome_selector_form").submit(function(){
    var ids = new Array;
    var selection_limit;
    jQuery("ul#as_selection_list_wrapper li.as_selected").each(function(){
      ids.push(jQuery(this).attr('record_id'));
      selection_limit = jQuery(this).attr('selection_limit');
    });
    if(ids.length > 0)
    {
      var limit = eval(selection_limit);
      if ((limit != "unlimited") && (ids.length > limit[0]))
        {
         alert(limit[1]);
         return false;
        }
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
function as_reset_list_filter()
{
  jQuery("#as_awesome_selector_list_filter").val('');
  jQuery("#as_awesome_selector_list_filter").keyup();
}

/*method to display error message*/
function as_display_error(obj, msg)
{
  if(jQuery('#as_err_'+ obj).length == 0)
    jQuery('<div id="as_err_' + obj + '" >'+ msg +'</div>').appendTo(jQuery('#as_selectable_error_msg'));
}

/*method to selected or deselect list item*/
function as_highlight_selected_div(element, max_selection_limit)
{
  if(!(element.hasClass('as_selected')))
  {
    var selection_limit = eval(max_selection_limit);
    if ((selection_limit == "unlimited") || (parseInt(as_selection_cnt) < selection_limit[0]))
    {
      element.addClass('as_selected');
      as_selection_cnt = parseInt(as_selection_cnt) + 1;
      jQuery('#as_selection_cnt').html("(" + as_selection_cnt + ")");
    }
    else
      alert(selection_limit[1] ? selection_limit[1] : "You can not select more");
  }
  else
  {
    as_selection_cnt = parseInt(as_selection_cnt) - 1;
    jQuery('#as_selection_cnt').html("(" + as_selection_cnt + ")");
    element.removeClass('as_selected');
    if(jQuery('ul#as_selection_list_wrapper').hasClass('as_selected_elements_list'))
    {
      element.hide();
    }
  }
}
