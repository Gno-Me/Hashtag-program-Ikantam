(function($) {
    $(document).ready(function() {
    	
		/* placeholder */
		$('.ie8 [placeholder], .ie9 [placeholder]').focus(function() {
			var input = $(this);
			if (input.val() == input.attr('placeholder')) {
				input.val('');
				input.removeClass('placeholder');
			}
		}).blur(function() {
			var input = $(this);
			if (input.val() == '' || input.val() == input.attr('placeholder')) {
				input.addClass('placeholder');
				input.val(input.attr('placeholder'));
			}
		}).blur().parents('form').submit(function() {
			$(this).find('[placeholder]').each(function() {
				var input = $(this);
				if (input.val() == input.attr('placeholder')) {
					input.val('');
				}
			})
		});

		$('input[type=file]').bootstrapFileInput();

    	/* custom checkbox/radio button */	
        if($('.cf, #cf').get(0)) {
			$('.cf, #cf').cf();
		}

		if($('.scroll-pane').get(0)) {
			$('.scroll-pane').jScrollPane();
		}

        $(".chosen").chosen({disable_search_threshold: 10});


        // $(".birthday").on("click", function() {
        // 	var $this = $(this),
        // 		$input = 

        // 	$input.hide();
        // 	$this.addClass("select-group");
        // });

    var $birthday = $(".birthday");
    var $birthdayInput = $birthday.find(".birth");
    $birthdayInput.hide();
    $birthday.addClass("select-group");



    });

})(jQuery);