(function($) {
'use strict';

var toggle_controls = function(query, enable) {
	$(query).prop('disable', !enable);
};

var enable_pj_controls = function () {
	toggle_controls('.type-pf-control', false);
	toggle_controls('.type-pj-control', true);
};

var enable_pf_controls = function () {
	toggle_controls('.type-pf-control', true);
	toggle_controls('.type-pj-control', false);
};

var toggle_country = function(country_code) {
	if (country_code == 'BR') {
		$('.br-type-control').removeClass('hidden');
	} else {
		$('.br-type-control').addClass('hidden');
	}
};

$('#is_billing').change(function() {
	toggle_controls('.inputs .controls input',  !this.checked);
	toggle_controls('.inputs .controls select', !this.checked);
	if (!this.checked) {
		if ($('#type_pf')[0].checked) {
			enable_pf_controls();
		} else {
			enable_pj_controls();
		}
	}
});

var is_billing = $('#is_billing');
if (is_billing.length > 0 && is_billing[0].checked) {
	toggle_controls('.inputs .controls input',  false);
	toggle_controls('.inputs .controls select', false);
}

toggle_country($('#country_code').val());
$('#country_code').change(function(el) { toggle_country(this.value); })
$('#type_pf').click(function() { enable_pf_controls(); });
$('#type_pj').click(function() { enable_pj_controls(); });

}(jQuery));
