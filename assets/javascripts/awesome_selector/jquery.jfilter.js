// Highlight function
jQuery.fn.extend({
  highlight: function(search, insensitive, hls_class){
    //var regex = new RegExp("(<[^>]*>)|("+ search.replace(/([-.*+?^${}()|[\]\/\\])/i,"\\$1") +")", insensitive ? "i" : "g");
    //Removed (<[^>]*>)| from above regexp to fix the problem of tags in search text
    var regex = new RegExp("("+ search.replace(/([-.*+?^${}()|[\]\/\\])/i,"\\$1") +")", insensitive ? "i" : "g");
    return this.html(this.html().replace(regex, function(a, b, c){
      //return (a.charAt(0) == "<") ? a : "<span class=\""+ hls_class +"\">" + c + "</span>";
      return "<span class=\""+ hls_class +"\">" + b + "</span>";
    }));
  }
});




// Unwrap function

jQuery.fn.extend({
  unwrap: function(){
    return this.each(function(){
      jQuery(this.childNodes).insertBefore(this);
    }).remove();
  }
});

// jFilter function

jQuery.fn.jfilter = function(o) {

  // Defaults
  /*var o = jQuery.extend({
  list: '#filterable',
	speed: '100',
	highlight: 'highlight'
  },o);*/

  return this.each(function(){
    jQuery(this).keyup(function(){
      var li = jQuery(o.list).hasClass('selected_elements_list')? 'li.selected' : 'li'
      var str = jQuery(this).val().replace( /<|>/, "" );
      jQuery(this).val(str);
      (str != '') ? jQuery(o.clear_btn).show() : jQuery(o.clear_btn).hide();
      jQuery('.'+o.highlight).unwrap();
      var filter = jQuery(this).val();
      jQuery(o.list + ' ' + li +' p').each(function () {
        if (jQuery(this).text().search(new RegExp(filter, "i")) < 0) {
          jQuery(this.parentNode).fadeOut(o.speed);
        }
        else {
          jQuery(this.parentNode).show();
          jQuery(this).highlight(filter, 1, o.highlight);
        }
      });
    });
  });
};
