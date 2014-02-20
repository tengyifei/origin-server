(function($) {
window.card = new Skeuocard($("#skeuocard"), {
	debug: true,
//	initialValues: {
//		name: $('#cc_name').prop('placeholder')
//	},
	strings: {
		hiddenFaceFillPrompt: "<strong>Clique aqui</strong> para <br>girar o cartão",
		hiddenFaceErrorWarning: "Existe algo errado no outro lado",
		hiddenFaceSwitchPrompt: "Esqueceu algo?<br> Gire o cartão"
	}
});

jQuery('.btn-validate').click(function() {
	if (window.card.isValid()) {
		jQuery('#form-validate').submit();
	} else {
		window.alert(jQuery('.validate_error_message').html());
	}
})

}(jQuery));
