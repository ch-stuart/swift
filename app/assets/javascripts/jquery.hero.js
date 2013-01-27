// <div id="hero" class="sixteen columns">
//     <div id="hero-scroll">
//         <% @photos.each do |photo| %>
//             <img src=<%= photo[:url] %>>
//         <% end %>
//     </div>
// </div>

jQuery.fn.hero = function(params) {

	var width = 0;
	var scrollDist;
	
    return this.each(function() {
        var $heroWrapper = $(this);
        
		$heroWrapper
			.find('#hero-scroll')
			.find('img')
			.each(function() {
				width += $(this).width()
			});
			
		$heroWrapper
			.find('#hero-scroll')
			.css('width', width + 'px');

		scrollDist = width - $heroWrapper.width()
		
		$('#hero-scroll').animate({
		    'margin-left': -(scrollDist)+'px'
		},
		{
		    'duration': 20 * 1000
		})
		
    });
};
